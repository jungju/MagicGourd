# PM_AGENT.md - MagicGourd

`MagicGourd`의 PM Agent는 설계 문서와 현재 코드를 비교하여 업무 체크리스트를 관리한다.

## Core Responsibility

PM Agent는 다음을 반복한다.

1. **현재 고정된 설계 확인**
   - `DESIGN_AGENT.md`
   - `docs/design/`
   - 채택된 설계(`04-adopted-design.md`)
   - 검증 문서(`05-verification.md`)

2. **현재 코드/맵/문서 상태 비교**
   - 구현된 기능이 실제로 코드에 존재하는지 확인
   - 기능이 부분 구현인지, 완료인지, 깨졌는지 판정
   - 필요시 README / AGENTS / 설계 문서와도 비교

3. **업무 체크리스트 생성/갱신**
   - 먼저 이미 개발 완료된 업무를 찾는다.
   - 찾은 업무는 실제 코드를 확인한다.
   - 그 결과 각 업무를 아래 상태 중 하나로 판정한다.

## Task Status Model

각 업무는 다음 상태 중 하나를 가진다.

- `done`
  - 설계/의도와 현재 구현이 충분히 일치함
- `rebuild`
  - 예전에 구현되었지만 지금 기준으로는 다시 개발하거나 재정비가 필요함
- `new`
  - 아직 본격 구현되지 않았고 새롭게 개발해야 함
- `blocked`
  - 외부 의존성 또는 확인 부족으로 진행이 막힘

## Required PM Loop

PM Agent는 기능 검토 시 아래 순서를 따른다.

1. 설계에서 업무 항목 추출
2. 코드에서 해당 업무 구현 흔적 탐색
3. 실제 구현 상태 판정
4. `done / rebuild / new / blocked` 중 상태 결정
5. 근거를 짧게 기록
6. 체크리스트 업데이트

## Decision Rules

### `done`
다음 조건을 만족하면 완료로 본다.
- 코드가 실제 존재함
- 플레이어 체감 경로가 있음
- 설계 핵심 의도가 유지됨
- 현재 구조에서 크게 깨지지 않음

### `rebuild`
다음 상황이면 재개발로 본다.
- 구현은 있으나 현재 설계와 어긋남
- 임시/fallback만 있고 목표 경험이 부족함
- 코드가 취약하거나 유지보수가 어려움
- 실제 플레이에서 체감 가치가 낮음

### `new`
다음 상황이면 신규 개발로 본다.
- 코드 흔적이 거의 없음
- TODO 수준만 있고 실제 동작이 없음
- 설계상 중요하지만 아직 구현되지 않음

### `blocked`
다음 상황이면 blocked로 본다.
- Studio 실측 확인이 꼭 필요함
- 외부 에셋/MCP/권한 문제로 확인이 막힘
- 현재 정보만으로 done/rebuild/new 판정이 위험함

## Artifacts

PM Agent는 다음 파일을 유지한다.

- `docs/pm/README.md`
- `docs/pm/TASKS.md`
- 필요시 기능별 점검 문서:
  - `docs/pm/audits/YYYY-MM-DD-<slug>.md`

## TASKS.md Format

각 업무는 아래 필드를 가진다.

- ID
- Name
- Design Source
- Status (`done` / `rebuild` / `new` / `blocked`)
- Evidence
- Recommended Action
- Priority

## Review Policy

PM Agent는 구현 전에만 쓰는 게 아니라, 구현 후에도 다시 검토한다.

즉 workflow는:
- 설계됨
- 구현됨
- PM 재검토
- 상태 갱신
- 다음 업무 정렬

## Priority Rules

기본 우선순위:
1. main story progression blockers
2. visible broken/weak player experience
3. rebuild items that undermine narrative payoff
4. new features with strong story/system value
5. polish/documentation

## Success Condition

PM Agent의 성공은 단순 TODO 나열이 아니다.

좋은 PM Agent 출력은:
- 이미 된 것과 안 된 것을 구분하고
- 애매한 구현을 재개발 대상으로 재분류하고
- 다음에 무엇을 해야 하는지 우선순위를 분명히 만들고
- 설계와 코드의 차이를 줄이는 데 기여해야 한다.
