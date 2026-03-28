# MagicGourd Design Agent

`MagicGourd`의 설계 Agent는 기능을 바로 만들기 전에 아래 순서를 거친다.

1. **제안 수집 (Propose)**
   - 플레이 경험을 개선할 수 있는 아이디어를 3~7개 제안한다.
   - 각 제안은 문제, 목표, 플레이 체감, 구현 난이도를 짧게 적는다.

2. **후보 정리 (Candidate Set)**
   - 제안 중 실제 후보를 2~4개로 압축한다.
   - 후보는 서로 다른 방향(스토리, 시스템, 연출, 경제, UX)을 포함하는 것이 좋다.

3. **분석 (Analyze)**
   - 각 후보를 아래 기준으로 분석한다.
     - 흥부전 테마 적합성
     - 플레이어 체감 가치
     - 구현 난이도
     - 현재 코드/맵과의 결합도
     - 리스크 / 의존성
     - MVP와 확장 가능성
   - 가능한 경우 점수화한다.

4. **채택 (Adopt)**
   - 가장 가치가 높은 후보 1개를 채택한다.
   - 채택 이유와 기각 이유를 함께 남긴다.

5. **설계 작성 (Design Spec)**
   - 유저 흐름
   - 상태 전이
   - 월드 오브젝트
   - 서버 로직
   - 클라이언트 UI/HUD/연출
   - 데이터 모델
   - 실패/예외 케이스
   - 검증 방법
   를 포함한 상세 설계를 작성한다.

6. **최종 검증 (Final Verification)**
   - 설계 누락 여부 확인
   - 플레이 루프가 실제로 재미를 만드는지 확인
   - 기존 퀘스트/자원/보상과 충돌 없는지 확인
   - 구현 전에 체크리스트를 모두 통과해야 한다.

## Operating Rules

- 작은 기능도 가능하면 이 과정을 축약해서라도 거친다.
- 큰 기능은 반드시 `docs/design/` 아래 산출물을 남긴다.
- 설계는 "그럴듯한 문서"가 아니라 실제 구현에 바로 들어갈 수 있어야 한다.
- 구현 이후에는 설계와 실제 결과 차이를 짧게 회고한다.
- 흥부전 테마와 플레이 체감이 약한 아이디어는 과감히 버린다.

## Quality Bar

설계는 아래 질문에 답할 수 있어야 한다.

- 왜 이 기능이 지금 필요한가?
- 플레이어는 무엇을 하게 되는가?
- 이전 단계와 다음 단계는 무엇인가?
- 실패하면 어떻게 복구되는가?
- Roblox에서 실제로 안정적으로 구현 가능한가?
- Rojo-safe하게 관리 가능한가?
- 향후 스토리/경제/연출 확장에 어떤 발판이 되는가?

## Default Artifact Flow

기능 하나를 설계할 때 기본 산출물 흐름:

- `docs/design/YYYY-MM-DD-<slug>/00-brief.md`
- `docs/design/YYYY-MM-DD-<slug>/01-proposals.md`
- `docs/design/YYYY-MM-DD-<slug>/02-candidates.md`
- `docs/design/YYYY-MM-DD-<slug>/03-analysis.md`
- `docs/design/YYYY-MM-DD-<slug>/04-adopted-design.md`
- `docs/design/YYYY-MM-DD-<slug>/05-verification.md`

## Suggested Scoring

후보 분석 점수는 1~5점으로 기록한다.

- Theme Fit
- Player Value
- Implementation Confidence
- Reusability
- Visual/Emotional Payoff
- Risk (역점수 또는 별도 메모)

총점만 보지 말고, 낮은 점수의 이유를 반드시 기록한다.
