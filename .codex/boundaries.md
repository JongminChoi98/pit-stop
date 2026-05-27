# 코덱스 작업 경계 (boundaries.md)

> 코덱스의 쓰기 영역을 정의하는 단일 진실 공급원.
> CI와 CODEOWNERS는 이 문서의 분류를 기준으로 동작한다.
> 이 파일 자체는 Tier C(금지 영역)에 속한다.

## 3개의 Tier

| Tier | 의미 | 머지 방식 |
|---|---|---|
| **A** | 자유 영역 | 코덱스가 자유롭게 쓰고, CI green 시 자동 머지 |
| **B** | 제안 영역 | 코덱스가 PR 제안만 가능. CODEOWNERS가 사람 리뷰 요구 |
| **C** | 금지 영역 | 코덱스 수정 불가. CI fail. 사람이 직접 main에 커밋 |

**안전 기본값**: 아래 표에 명시되지 않은 모든 경로는 **Tier B**로 간주한다.

---

## Tier A — 자유 영역 (자동 머지 후보)

| 경로 | 설명 |
|---|---|
| `assets/content/**` | 콘텐츠 YAML 파일 (차량, DTC, 손님, 시나리오) |
| `lib/**` | 모든 Dart 코드 (코어, 콘텐츠 로더, UI, 게임 로직) |
| `test/**` | 모든 테스트 코드 |
| `.codex/examples/**` | 톤 기준선 예시 콘텐츠 |

### Tier A 룰
- PR 변경 파일이 **모두 Tier A**일 때 `auto-mergeable` 라벨 자동 부착
- 모든 CI 검사 통과 시 자동 머지 (squash)
- 자가 검증 체크리스트 4가지가 모두 체크되어 있어야 함

---

## Tier B — 제안 영역 (사람 검토 필수)

| 경로 | 이유 |
|---|---|
| `pubspec.yaml` | 의존성 추가 = 부채 1단위 (헌장 4절) |
| `pubspec.lock` | 의존성 변경의 부산물 |
| `android/**` | 플랫폼 설정, 서명, 권한 |
| `ios/**` | 플랫폼 설정 (사용 안 하지만 보호) |
| `README.md` | 사람용 문서 |
| `analysis_options.yaml` | 린트 룰 |
| `.gitignore` | 저장소 위생 |
| **명시되지 않은 모든 경로** | 안전한 기본값 |

### Tier B 룰
- PR이 Tier B 파일을 **한 줄이라도** 포함하면 `needs-human-review` 라벨 자동 부착
- CODEOWNERS가 종민 리뷰를 요구함 → 종민 승인 전 자동 머지 불가
- PR 본문에 "왜 이 변경이 필요한가" 명시해야 함

---

## Tier C — 금지 영역 (코덱스 수정 불가)

| 경로 | 이유 |
|---|---|
| `pit-stop-charter.md` | 프로젝트 헌장 |
| `AGENTS.md` | 코덱스 매뉴얼 |
| `.codex/boundaries.md` | 이 파일 자체 |
| `.codex/schemas/**` | 콘텐츠 형식 정의 |
| `.codex/forbidden_keywords.txt` | 금지 키워드 목록 |
| `.github/**` | CI 워크플로우, CODEOWNERS, 템플릿 |
| `scripts/verify.sh` | 검증 스크립트 |

### Tier C 룰
- PR에 Tier C 파일이 한 줄이라도 변경되어 있으면 CI 즉시 fail
- 변경이 필요하면 Issue로 제안하거나, 종민이 직접 main 브랜치에 커밋
- **자동화의 룰을 자동화가 바꾸지 못하게 막는 게 핵심**

---

## 자주 헷갈리는 케이스

- **`assets/` 아래 콘텐츠 아닌 파일** (이미지, 사운드, 폰트): Tier B. `assets/content/**`만 Tier A.
- **새 디렉토리 신설**: 어느 Tier인지 명확하지 않으면 Tier B로 간주.
- **`lib/main.dart`**: Tier A (`lib/**` 하위).
- **테스트 픽스처** (`test/fixtures/`): Tier A (`test/**` 하위).
- **`.vscode/`, `.idea/`**: Tier B (안전 기본값).

---

## 이 파일의 변경 절차

`boundaries.md` 자체의 변경은:
1. 종민이 직접 main 브랜치에 커밋 (Tier C)
2. 변경 사유를 commit message에 명시
3. AGENTS.md의 "작업 영역" 섹션도 함께 동기화