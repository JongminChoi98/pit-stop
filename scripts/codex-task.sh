#!/usr/bin/env bash
# pit-stop / scripts/codex-task.sh
#
# 코덱스 작업의 전체 사이클 자동화.
# 브랜치 생성 → 코덱스 실행 → 로컬 검증 → 커밋 → 푸시 → PR 생성.
#
# 사용법:
#   ./scripts/codex-task.sh "작업 설명"
#
# 예시:
#   ./scripts/codex-task.sh "현대 K5 DL3 차량 추가"
#   ./scripts/codex-task.sh "P0301 DTC 추가"
#
# 사전 조건:
#   - GitHub CLI (gh) 설치 + 인증:   brew install gh && gh auth login
#   - 코덱스 CLI 설치 + 인증
#   - main 브랜치에서 시작 (워킹 디렉토리 깨끗)

set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

# ───── 인자 확인 ─────
if [ -z "${1:-}" ]; then
    echo "사용법: $0 \"작업 설명\""
    exit 1
fi
TASK="$1"

# ───── 의존성 확인 ─────
command -v gh >/dev/null 2>&1 || { echo "❌ gh CLI 미설치 → brew install gh"; exit 1; }
command -v codex >/dev/null 2>&1 || { echo "❌ codex CLI 미설치"; exit 1; }

# ───── 상태 확인 ─────
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ main 브랜치에서 시작해야 합니다. 현재: $CURRENT_BRANCH"
    exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "❌ 워킹 디렉토리가 깨끗하지 않음. 커밋 또는 stash 후 다시."
    exit 1
fi

# ───── main 최신화 ─────
echo "📥 main 최신화..."
git pull --rebase origin main

# ───── 브랜치 이름 생성 ─────
SLUG=$(echo "$TASK" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cs 'a-zA-Z0-9' '-' \
    | sed 's/^-*//;s/-*$//' \
    | cut -c1-30)
[ -z "$SLUG" ] && SLUG="task"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BRANCH="codex/${SLUG}-${TIMESTAMP}"

echo ""
echo "════════════════════════════════════════"
echo "  Task:   $TASK"
echo "  Branch: $BRANCH"
echo "════════════════════════════════════════"
echo ""

git checkout -b "$BRANCH"

# ───── 코덱스 실행 ─────
echo "🤖 코덱스 실행..."
echo ""

# ⚠️  본인이 사용하는 코덱스 CLI 명령어로 아래 한 줄을 교체하세요.
# 예시 후보 (실제 도구에 맞게 수정):
#   codex exec "$TASK"
#   codex run --task "$TASK"
#   openai codex "$TASK"
codex "$TASK"   # ← 이 줄을 본인의 명령어로 교체

# ───── 변경 사항 확인 ─────
if git diff --quiet && \
   git diff --cached --quiet && \
   [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo ""
    echo "ℹ️  코덱스가 변경 사항을 만들지 않음. 브랜치 폐기."
    git checkout main
    git branch -D "$BRANCH"
    exit 0
fi

# ───── 로컬 검증 ─────
echo ""
echo "🔍 로컬 검증..."
git add -A   # 검증이 staged + unstaged 모두 봐야 하므로 임시 staging

if ! ./scripts/verify.sh; then
    echo ""
    echo "❌ 검증 실패."
    echo "   브랜치 $BRANCH 에 변경 유지됨."
    echo "   수정 후 다시 커밋하거나, 폐기:"
    echo "     git checkout main && git branch -D $BRANCH"
    exit 1
fi

# ───── 커밋 ─────
echo ""
echo "💾 커밋..."
git commit -m "[task] ${TASK}

자동 생성 (codex-task.sh)
헌장 정합성: 변경 파일이 boundaries.md의 허용 영역에 위치.
"

# ───── 푸시 + PR ─────
echo ""
echo "📤 푸시..."
git push -u origin "$BRANCH"

echo ""
echo "🔗 PR 생성..."
PR_BODY="자동 생성 PR.

**작업**: $TASK

**자가 검증** (verify.sh 로컬 통과):
- [x] 스키마 통과
- [x] 금지 키워드 미포함
- [x] 변경 파일이 정의된 영역에 위치
- [x] 헌장 머지 게이트 충족

생성자: codex-task.sh"

gh pr create \
    --base main \
    --head "$BRANCH" \
    --title "[task] $TASK" \
    --body "$PR_BODY"

# ───── 마무리 ─────
echo ""
echo "════════════════════════════════════════"
echo "  ✓ 완료"
echo "════════════════════════════════════════"
echo ""
echo "다음 단계 (자동):"
echo "  1. GitHub Actions의 verify.yml 실행"
echo "  2. Tier 분류 → 자동 라벨링"
echo "  3. Tier A only + 모든 체크 통과 시 → auto-merge 발동"
echo "  4. 그 외 → PR 페이지에서 종민 리뷰 + 머지"
echo ""
echo "PR URL이 위에 출력됐습니다. 'gh pr view' 로 진행 상황 확인 가능."