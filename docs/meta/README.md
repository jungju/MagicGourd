# MagicGourd Meta Workflow

이 폴더는 저장소의 운영 문서와 파이프라인 자체를 점검하는 메타 레이어다.

## 목적

- 운영 문서와 실행 기준선의 드리프트 점검
- 문서와 운영 흐름 개선
- 충돌 방지 규칙 강화
- 관리 단계에서만 안전하게 유지보수 수행

## 핵심 원칙

메타 레이어는 게임 기능보다 **운영 체계**를 다룬다.
기능 구현 라운드를 방해하지 않도록 관리 창에서만 조정한다.

## Dirty Tree Guard

저장소에 미커밋 구현 작업이 있으면 메타 작업 범위를 더 줄인다.

## Design Change Mode Guard

명시적 설계 전환 모드 문서가 생기면 메타 레이어도 그것을 존중해야 한다.

기본 규칙:
- `docs/design/*design-change-mode*.md` 문서가 존재하고 주기 실행 스킵을 지시하면 메타 작업은 기본적으로 no-op 또는 `observe`만 수행한다.
- 이때 허용되는 수정은 메타 문서의 소규모 충돌 방지 보강 정도로 제한한다.
- 이 상태에서 PM 체크리스트 재판정이나 루프 우선순위 재정렬은 하지 않는다.

이 규칙은 설계 방향 재정의가 끝나기 전, 메타 유지보수가 파이프라인을 다시 흔드는 일을 막기 위한 것이다.

## Stale Transition Marker Rule

설계 전환 모드 문서가 남아 있는데도 저장소의 실제 기준은 이미 새 방향으로 이동했을 수 있다.

판정 신호 예시:
- `README.md`가 새 활성 방향을 직접 명시함
- `docs/pm/TASKS.md`가 새 방향 기준으로 이미 정렬됨
- 새 방향 설계에 `04-adopted-design.md` + `05-verification.md`가 있음
- 코드/런타임 구조가 이미 그 방향을 따름

이 경우 메타 작업은 전환 모드 문서를 즉시 덮어쓰지 않는다. 대신:
- 기본 동작은 여전히 `observe` 또는 작은 `tune`에 머문다
- 충돌 사실을 메타 레이어에만 기록한다
- 해당 전환 문서를 `stale exit candidate`로 취급해 이후 설계/PM 정리 라운드로 넘긴다
- 이 충돌만을 이유로 PM 우선순위나 active task를 메타 목적만으로 다시 섞지 않는다

## Design Freeze Gate

메타 레이어는 설계 산출물이 아직 굳지 않았는데 PM 체크리스트가 앞질러 흔들리는 상황을 줄여야 한다.

기본 규칙:
- `04-adopted-design.md` + `05-verification.md`가 함께 있는 설계만 PM의 활성 체크리스트 후보로 본다.
- 그 이전 산출물은 design backlog이며, 메타 작업이 성급히 PM 항목으로 끌어올리지 않는다.
- 이미 코드 구현이 선행된 경우만 예외적으로 PM이 역판정할 수 있다.

## Validation Debt Handling

Studio/MCP 실측 대기는 중요하지만, 메타 라운드에서 쉽게 중복 추천으로 불어난다.

기본 규칙:
- 비슷한 성격의 Studio/MCP 확인은 한 번의 validation pass로 묶는 것을 우선한다.
- 메타 작업은 active-work 구간에서 validation recommendation을 여러 줄로 증식시키기보다 통합 원칙만 남긴다.
- 검증 대기가 남아 있다는 이유만으로 PM 우선순위를 메타 목적만으로 다시 섞지 않는다.

## Drift Sentinel Rules

메타 레이어는 active-work 구간에서 본문 문서를 크게 다시 쓰지 않더라도, 아래 종류의 드리프트를 관찰 대상으로 분리해 둔다.

### 1. Stale transition doc vs active repo baseline
다음 신호가 함께 보이면 `design-change-mode`류 문서를 stale transition candidate로 취급한다.
- `README.md`가 이미 새 활성 방향을 직접 설명함
- `docs/pm/TASKS.md`가 새 방향 기준으로 정렬됨
- 활성 설계에 `04-adopted-design.md` + `05-verification.md`가 존재함

이 경우 메타 작업은 전환 문서를 즉시 삭제/수정하지 않는다. 대신:
- maintenance pass 결과에 충돌 사실만 기록한다
- loop/PM/dev 쪽 활성 문서를 메타 목적만으로 재정렬하지 않는다
- 이후 Design 또는 PM 라운드에서 정식 종료 정리를 하도록 넘긴다

### 2. Task table vs recommendation block drift
`docs/pm/TASKS.md`에서 개별 task 상태표와 하단 추천 블록이 서로 다른 판정을 말하기 시작할 수 있다.

예:
- task row는 `done`
- 바로 아래 recommendation block은 여전히 `rebuild next`

이 경우 메타 작업의 기본 동작:
- active-work 구간이면 PM 본문을 크게 재작성하지 말고 drift만 기록한다
- recommendation block은 status table의 최신 판정을 반복하지 말고, 정말 남은 다음 액션만 요약해야 한다는 원칙을 유지한다
- 후속 PM 라운드에서 status table과 recommendation block을 한 번에 정렬하도록 넘긴다

### 3. Legacy refinement focus vs active loop baseline drift
`refinement-mode`류 문서가 남아 있어도, 그 안의 즉시 집중 항목이 현재 활성 루프 기준과 이미 어긋날 수 있다.

예:
- 활성 README / PM / adopted design은 arcade loop를 기준으로 움직임
- refinement 문서의 focus list는 이전 구조(예: house placement, dialogue quest flow)를 그대로 가리킴

이 경우 메타 작업의 기본 동작:
- refinement 문서를 메타 목적만으로 즉시 갈아엎지 않는다
- 대신 해당 focus list를 `legacy refinement hints`로 해석하고, 현재 활성 README / adopted design / PM checklist가 우선 기준이라는 원칙만 메타에 남긴다
- active-work 구간에서는 예전 refinement focus를 근거로 새 PM 항목이나 Dev 우선순위를 다시 열지 않는다
- 후속 Design 또는 PM 라운드에서 현재 루프에 맞는 refinement focus로 정식 재작성할 수 있게 넘긴다

### 4. Combined stale-transition + legacy-refinement collision
`design-change-mode` 문서는 아직 "주기 실행 스킵"을 말하고, `refinement-mode` 문서는 예전 집중 항목을 가리키지만, 실제 저장소 기준선은 이미 새 arcade loop로 굳어 있는 상태가 함께 나타날 수 있다.

이 조합이 보이면 메타 작업은 아래 우선순위를 사용한다.
- 실행 기준선은 `README.md` + 최신 adopted design + `docs/pm/TASKS.md` 조합을 우선한다.
- `design-change-mode`는 stale transition candidate로만 기록하고, 메타 목적만으로 즉시 종료 처리하지 않는다.
- `refinement-mode`의 예전 focus list는 legacy hints로만 취급하고, active Dev/PM 우선순위 근거로 재사용하지 않는다.
- 이 상태에서 남은 실질적 다음 액션은 보통 신규 기능 선정이 아니라 이미 PM에 남아 있는 통합 Studio validation / readability follow-through인지 먼저 확인하는 것이다.

### 5. Repo-level workflow doc vs active baseline drift
`AGENTS.md`나 workflow README가 살아 있는 활성 기준선보다 오래된 기본 타깃/스토리 순서를 남길 수 있다.

예:
- `README.md` / adopted design / PM checklist는 arcade loop를 기준으로 움직임
- repo-level workflow docs는 여전히 이전 story quest, house placement, dialogue quest flow를 기본 타깃처럼 제시함

이 경우 메타 작업의 기본 동작:
- active-work 구간에서도 worker handoff를 직접 흔드는 충돌이면, repo-level workflow 문구를 최신 baseline에 맞추는 소규모 tune은 허용한다
- 단, active task table이나 설계 산출물 자체를 메타 목적만으로 재판정하지는 않는다
- workflow docs는 "현재 무엇을 기본값으로 집을지"만 최신화하고, historical docs는 reference로 남긴다

### 6. Priority ladder vs active refinement baseline drift
repo-level 우선순위 문구가 남아 있어 worker handoff가 은근히 확장 방향으로 새는 경우가 있다.

예:
- `README.md` / 최신 adopted design / `docs/pm/TASKS.md`는 shared arcade loop refinement를 활성 기준선으로 둠
- 하지만 역할 문서의 working priorities / default heuristics는 여전히 `main story progression`, `new feature`, `quest expansion`처럼 읽힘

이 경우 메타 작업의 기본 동작:
- active-work 구간에서는 구현/PM 본문을 다시 섞지 말고, 우선 메타 레이어에 drift 사실을 기록한다
- 실행 기준선은 `README.md` + 최신 adopted design + PM checklist의 공통 교집합을 우선한다
- repo-level priority ladder는 후속 maintenance window에서만 작은 문구 조정 대상으로 다루고, 그 전까지는 "arcade refinement > new story expansion" 해석 규칙을 우선한다
- 특히 `story progression blockers` 같은 오래된 heuristic은 현재 arcade loop 안의 progression/readability blocker로 좁혀 해석하고, 별도 신규 스토리 확장 근거로 쓰지 않는다

### 7. Canonical design source / folder-name drift
활성 설계 폴더의 실제 이름, `README.md`의 참조 경로, `docs/pm/TASKS.md`의 `Design Source` 표기가 서로 다르면 다음 작업이 잘못된 설계 폴더를 기준선으로 집을 위험이 생긴다.

예:
- 실제 활성 설계 폴더는 `docs/design/2026-03-28-heungbu-arcade-loop/`
- `README.md`는 다른 폴더명(예: HHMM 포함 경로)을 가리킴
- PM table은 날짜 없는 축약 표기만 남겨 exact folder lookup이 어려움

이 경우 메타 작업의 기본 동작:
- active-work 구간에서는 활성 설계 폴더를 메타 목적만으로 rename/move 하지 않는다
- 우선 메타 레이어에 `canonical design source drift`로 기록하고, worker는 **실제 폴더 + 그 안의 `04-adopted-design.md` / `05-verification.md`**를 최우선 기준으로 해석하도록 안내한다
- 후속 maintenance 또는 PM/Design 정리 라운드에서만 `README.md` 참조, PM `Design Source`, 설계 naming rule을 한 번에 맞춘다
- 같은 날 다수 설계가 생겨도 exact folder lookup이 가능한 표기를 유지하고, 축약 이름만 단독 기준으로 쓰지 않는다
- 충돌 시에는 README의 예시 경로나 naming rule보다, **실제로 존재하는 design folder path**와 그 안의 `04-adopted-design.md` / `05-verification.md`, 그리고 `docs/pm/TASKS.md` 헤더가 가리키는 exact path를 우선한다

### 8. Naming rule vs real design tree drift
`docs/design/README.md`가 `YYYY-MM-DD-HHMM-<slug>` naming rule을 강하게 요구해도, 실제 활성 설계 폴더들이 날짜-only 형식(`YYYY-MM-DD-<slug>`)으로 이미 운영 중일 수 있다.

이 경우 메타 작업의 기본 동작:
- active-work 구간에서는 열린 설계 폴더를 메타 목적만으로 rename 하지 않는다
- worker handoff에서는 문서 규칙보다 **실제 존재하는 폴더와 그 adopted/verification 파일**을 우선 기준으로 삼는다
- naming rule drift는 메타 레이어에만 기록하고, 후속 maintenance window에서 `docs/design/README.md` / repo `README.md`를 한 번에 정리하도록 넘긴다
- 혼재 상태가 끝나기 전까지는 exact folder path를 축약 없이 적는 쪽을 기본값으로 본다

활성 작업 신호 예시:
- `git status`에 여러 설계 폴더가 새로 열려 있음
- `AGENTS.md` 같은 운영 문서가 방금 수정 중임
- PM 체크리스트와 설계 문서가 같은 라운드에서 함께 흔들리고 있음
- 구현 검증이 아직 Studio/MCP 확인 대기 상태임

그때 우선 허용되는 일:
- observe 기록
- 작은 운영 문서 보강
- 충돌 방지 규칙 추가
- 메타 레이어 문서 정합성 수선

그때 피해야 하는 일:
- 근거가 아직 굳지 않은 PM 상태 대규모 재판정
- 진행 중인 설계 폴더 구조 재배치
- gameplay code 개입
- active feature 라운드의 우선순위를 메타 목적만으로 재정렬

핵심은 **파이프라인을 돕되, 활성 개발의 발을 밟지 않는 것**이다.
