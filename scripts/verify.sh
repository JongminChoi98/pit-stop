#!/usr/bin/env bash
# pit-stop / scripts/verify.sh
#
# 로컬 검증 스크립트. CI verify.yml과 동일한 검사를 실행.
# PR 푸시 전 자가 검증용.
#
# 사용법:
#   ./scripts/verify.sh         # main 대비 변경 파일 기준 검사
#   ./scripts/verify.sh --all   # 저장소 전체 검사
#
# 사전 준비 (한 번만):
#   pip3 install pyyaml jsonschema

set -u

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

MODE="${1:-changed}"
EXIT_CODE=0

echo "════════════════════════════════════════"
echo "  pit-stop verify  (mode: $MODE)"
echo "════════════════════════════════════════"

# ─── 변경 파일 추출 ───
CHANGED=""
if [ "$MODE" = "changed" ]; then
  CHANGED=$(
    {
      git diff --name-only origin/main...HEAD 2>/dev/null || true
      git diff --name-only --cached 2>/dev/null || true
      git diff --name-only 2>/dev/null || true
    } | sort -u | grep -v '^$' || true
  )

  if [ -z "$CHANGED" ]; then
    echo ""
    echo "변경 파일 없음."
  else
    echo ""
    echo "변경 파일:"
    echo "$CHANGED" | sed 's/^/  /'
  fi
fi

# ─── [1/3] Tier 분류 ───
echo ""
echo "── [1/3] Tier 분류 ──"
if [ "$MODE" = "changed" ] && [ -n "$CHANGED" ]; then
  CHANGED_FILES="$CHANGED" python3 << 'PYEOF'
import os, re

files = os.environ.get('CHANGED_FILES', '').strip().split('\n')

TIER_C = [
    r'^pit-stop-charter\.md$',
    r'^AGENTS\.md$',
    r'^\.codex/boundaries\.md$',
    r'^\.codex/schemas/',
    r'^\.codex/forbidden_keywords\.txt$',
    r'^\.github/',
    r'^scripts/verify\.sh$',
]
TIER_A = [
    r'^assets/content/',
    r'^lib/',
    r'^test/',
    r'^\.codex/examples/',
]

touches_c = False
all_a = bool(files)
for f in files:
    if not f: continue
    if any(re.match(p, f) for p in TIER_C):
        touches_c = True; all_a = False
        print(f"  Tier C: {f}")
    elif any(re.match(p, f) for p in TIER_A):
        print(f"  Tier A: {f}")
    else:
        all_a = False
        print(f"  Tier B: {f}")

print()
if touches_c:
    print("⚠️  Tier C 변경 — 종민 직접 커밋만 허용됨")
if all_a:
    print("✓ Tier A only — 자동 머지 후보")
elif not touches_c:
    print("ⓘ Tier B 포함 — 종민 리뷰 필수")
PYEOF
else
  echo "  (스킵)"
fi

# ─── [2/3] 금지 키워드 ───
echo ""
echo "── [2/3] 금지 키워드 ──"
if [ ! -f .codex/forbidden_keywords.txt ]; then
  echo "  ⚠️  forbidden_keywords.txt 없음. 스킵."
else
  KEYWORDS=$(grep -vE '^[[:space:]]*#|^[[:space:]]*$' .codex/forbidden_keywords.txt || true)

  if [ -z "$KEYWORDS" ]; then
    echo "  키워드 없음. 스킵."
  else
    if [ "$MODE" = "changed" ] && [ -n "$CHANGED" ]; then
      TARGETS="$CHANGED"
    else
      TARGETS=$(git ls-files | grep -vE '\.(png|jpg|jpeg|gif|webp|ico|svg|pdf|zip|jar|so|dll)$' || true)
    fi

    FOUND=0
    while IFS= read -r kw; do
      [ -z "$kw" ] && continue
      while IFS= read -r f; do
        [ -z "$f" ] && continue
        [ ! -f "$f" ] && continue
        if grep -niF -- "$kw" "$f" >/dev/null 2>&1; then
          echo "  ❌ $f: '$kw'"
          grep -niF -- "$kw" "$f" | head -3 | sed 's/^/      /'
          FOUND=1
        fi
      done <<< "$TARGETS"
    done <<< "$KEYWORDS"

    if [ $FOUND -eq 0 ]; then
      echo "  ✓ 금지 키워드 없음"
    else
      EXIT_CODE=1
    fi
  fi
fi

# ─── [3/3] 스키마 검증 ───
echo ""
echo "── [3/3] 스키마 검증 ──"
if [ ! -d assets/content ]; then
  echo "  ⓘ assets/content/ 없음. 스킵."
elif [ ! -d .codex/schemas ]; then
  echo "  ⚠️  .codex/schemas/ 없음. 스킵."
else
  python3 << 'PYEOF'
import sys
try:
    import yaml
    from jsonschema import validate, ValidationError
except ImportError as e:
    print(f"  ⚠️  필수 패키지 미설치 ({e.name}). 다음 실행:")
    print("       pip3 install pyyaml jsonschema")
    sys.exit(2)

from pathlib import Path

TYPE_TO_SCHEMA = {
    'vehicles': 'vehicle.yaml',
    'dtc': 'dtc.yaml',
    'customers': 'customer.yaml',
    'scenarios': 'scenario.yaml',
    'procedures': 'procedure.yaml',
    'services': 'service.yaml',
    'parts': 'part.yaml',
}

SCHEMA_DIR = Path('.codex/schemas')
CONTENT_DIR = Path('assets/content')

schemas = {}
for type_name, schema_file in TYPE_TO_SCHEMA.items():
    path = SCHEMA_DIR / schema_file
    if path.exists():
        with open(path) as f:
            schemas[type_name] = yaml.safe_load(f)

errors = 0
checked = 0
for type_dir in sorted(CONTENT_DIR.iterdir()):
    if not type_dir.is_dir():
        continue
    type_name = type_dir.name
    if type_name not in schemas:
        print(f"  ⚠️  스키마 없음: {type_name}/")
        continue

    schema = schemas[type_name]
    for content_file in sorted(type_dir.glob('*.yaml')):
        checked += 1
        with open(content_file) as f:
            try:
                data = yaml.safe_load(f)
            except yaml.YAMLError as e:
                print(f"  ❌ {content_file}: YAML 파싱 실패")
                errors += 1
                continue
        try:
            validate(instance=data, schema=schema)
        except ValidationError as e:
            print(f"  ❌ {content_file}")
            print(f"      {e.message}")
            errors += 1

if checked == 0:
    print("  ⓘ 검증할 콘텐츠 파일 없음")
elif errors == 0:
    print(f"  ✓ {checked}개 파일 모두 통과")
else:
    print(f"  ❌ {checked}개 중 {errors}개 실패")

sys.exit(1 if errors > 0 else 0)
PYEOF
  [ $? -ne 0 ] && EXIT_CODE=1
fi

# ─── 결과 ───
echo ""
echo "════════════════════════════════════════"
if [ $EXIT_CODE -eq 0 ]; then
  echo "  ✓ 모든 검사 통과"
else
  echo "  ❌ 검사 실패"
fi
echo "════════════════════════════════════════"
exit $EXIT_CODE