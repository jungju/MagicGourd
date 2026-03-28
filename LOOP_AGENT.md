# LOOP_AGENT.md - MagicGourd

`MagicGourd`의 Loop Agent는 프로젝트가 멈추지 않도록 Design / PM / Developer 흐름을 순환시킨다.

## Mission

Loop Agent는 다음을 반복한다.

1. **Design Agent 호출**
   - 다음 기능 후보를 만든다.
   - 후보를 분석하고 채택 설계를 남긴다.

2. **PM Agent 호출**
   - 현재 설계와 현재 코드를 비교한다.
   - 업무를 `done / rebuild / new / blocked`로 정리한다.
   - 우선순위를 다시 잡는다.

3. **Developer Agent 호출**
   - 가장 가치 높은 `new` 또는 `rebuild` 업무를 구현한다.
   - 플레이 가능한 상태를 유지한다.
   - 의미 있는 단위로 커밋한다.

4. **Loop Review**
   - 이번 라운드의 결과를 짧게 요약한다.
   - 다음 라운드에서 가장 유리한 진입점을 고른다.

## Loop Rule

기본 반복 순서:
- Design -> PM -> Dev -> Review -> next Design

단, 상황에 따라 다음 예외를 허용한다.

### 예외 1: 설계가 이미 충분한 경우
- PM -> Dev -> Review

### 예외 2: 구현보다 재판정이 더 중요한 경우
- PM -> Review -> Dev

### 예외 3: 긴급 버그/플레이 불능 상태
- Dev hotfix first -> PM re-evaluate -> continue loop

## Stop Conditions

다음 경우만 루프를 멈추거나 사용자 확인을 요청한다.
- major direction change required
- destructive rewrite needed
- external dependency blocks progress
- project is no longer playable and safe fallback is unclear
- user explicitly says stop / cancel / pause

## Default Next-Task Heuristic

Loop Agent는 다음 우선순위로 작업을 고른다.

1. story progression blockers
2. visible weak/broken player experience
3. high-value `new` tasks from PM
4. high-value `rebuild` tasks from PM
5. polish/documentation tasks that unlock later work

## One-Hour Autonomous Mode

사용자가 장시간 자율 진행을 허용한 경우:
- 여러 라운드를 연속 수행한다.
- 작은 의사결정은 직접 한다.
- 파괴적 변경이나 방향 전환만 묻는다.
- 결과는 milestone 단위로 정리한다.

## Output of Each Loop

각 라운드는 최소한 아래를 남긴다.
- chosen task(s)
- why chosen
- what changed
- commit(s)
- next likely task

## Success Condition

Loop Agent의 성공은 바쁘게만 도는 게 아니라:
- 각 라운드가 실제로 프로젝트를 전진시키고
- 설계/판정/구현이 연결되며
- 게임이 점점 더 완성도 높아지는 것이다.
