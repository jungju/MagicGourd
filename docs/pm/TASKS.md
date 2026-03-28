# MagicGourd Task Checklist

이 체크리스트는 설계/문서/현재 코드 상태를 비교하며 유지한다.

## Legend
- `done` = 구현 완료 및 현재 기준 충족
- `rebuild` = 구현 흔적은 있으나 재개발/재정비 필요
- `new` = 새롭게 개발 필요
- `blocked` = 외부 확인/의존성으로 판정 유보

---

## Story / Progression

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-001 | Intro / Story Stone / Heungbu onboarding | current quest slice | done | README와 server quest stages에 intro, Heungbu 시작 흐름 존재 | 유지 | P1 |
| MG-PM-002 | Seed -> Plant -> Harvest -> Heungbu delivery loop | current quest slice | done | server/client HUD 및 퀘스트 단계 설명 반영 | 유지 | P1 |
| MG-PM-003 | Nolbu tribute quest | current quest slice | done | Nolbu tribute 단계 및 전달 흐름 문서화/구현됨 | 유지 | P1 |
| MG-PM-004 | Swallow injury / herb healing slice | swallow healing story slice | done | 퀘스트 단계와 약초 인벤토리, 제비 단계 추가됨 | 유지 | P1 |
| MG-PM-005 | Blessed seed / true magic gourd payoff | 2026-03-28 blessed seed payoff design | done | 설계 문서와 함께 blessed seed, golden vine, true magic gourd harvest, Heungbu payoff, HUD/effect 반영 구현됨 | 유지, Studio 체감만 추가 검증 | P1 |
| MG-PM-006 | Nolbu retaliation after magic payoff | 2026-03-28 blessed seed payoff design | done | Nolbu jealousy 대화, patch bramble sabotage, clear-brambles recovery 단계가 구현됨 | 유지 | P1 |
| MG-PM-007 | Ending / branching outcome structure | 2026-03-28 branching ending structure | done | `FINAL_AUDIENCE -> CHOOSE_ENDING -> ENDING_RESTORATION/ENDING_TRIBUTE -> COMPLETE` 흐름, 선택 UI RemoteEvent, ending 결과/HUD 힌트/간판 반영 구현됨 | 유지, Studio 체감만 추가 검증 | P1 |
| MG-PM-008 | Retaliation pressure expansion | 2026-03-28 retaliation pressure pass | done | retaliation 이후 `CLEAR_BRAMBLES -> STABILIZE_VALLEY -> FINAL_AUDIENCE` 분기, Heungbu yard marker 파손/수리 연출, 표지판/패치 카피 갱신, 복구 프롬프트 및 보상 흐름이 `init.server.luau`에 구현됨 | 유지, Studio에서 yard marker 가시성/동선만 최종 확인 | P1 |
| MG-PM-009 | Post-ending replay variations | 2026-03-28 post-ending replay variations | done | `COMPLETE` 이후 restoration용 shared basket, tribute용 road-due stand, 1-gourd hand-in, modest coin 보상, 분기 대사/간판/카운터가 `init.server.luau`에 구현됨 | 유지, Studio에서 위치/가독성만 최종 확인 | P1 |
| MG-PM-010 | Post-ending errand escalation | 2026-03-28 post-ending errand escalation | done | 반복 심부름 3회 단위 milestone 보상(복원: 씨앗 반환 / 공물: inspection coin), 분기별 QuestHint/간판 문구 상승, milestone 전용 effect/dialogue가 `init.server.luau`와 신규 설계 문서에 반영됨 | 유지, Studio에서 sign 가독성과 보상 체감만 최종 확인 | P2 |
| MG-PM-011 | Post-ending support-point rotations | 2026-03-28 post-ending support rotations | done | `init.server.luau`에 restoration/tribute 3개 지점 프롬프트 연결, per-player active-point gating/redirect, rotation threshold advancement, QuestHint 활성 지점 반영, 그리고 `refreshVillageSigns()`에서 안전한 `updateEndingSupportSigns` 연결 + village-level active-point copy 갱신이 구현됨 | 유지, Studio에서 각 지점 동선/가독성만 최종 확인 | P2 |
| MG-PM-012 | Post-ending landmark accrual tiers | 2026-03-28 post-ending landmark accrual | done | `init.server.luau`에 landmark tier helper(`getEndingLandmarkTier*`), village-global tier sign/hint copy, restoration/tribute Tier 1/2 prop visibility, 그리고 basket/pantry/relief + road/gate/route까지 3지점 전부의 landmark accrual 연출이 구현됨 | 유지, Studio에서 각 tier 가독성과 충돌만 최종 확인 | P2 |

## NPC / World

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-101 | Nolbu wandering patrol NPCs | village runtime slice | done | 배회 NPC 2명/pathfinding 구현 보고됨 | 실제 체감만 계속 다듬기 | P1 |
| MG-PM-102 | Heungbu interaction presence | village runtime slice | done | Heungbu 대화/보상 루프 존재 | 유지 | P1 |
| MG-PM-103 | House placement/orientation final polish | house setup goal | rebuild | pad/yaw 기반 house placement contract, bottom anchoring, front-anchor metadata, and prompt/tribute alignment logic are now implemented in server code; final visual confirmation in Studio is still pending | Run one Studio visual pass, then close if imported houses read upright and grounded | P1 |
| MG-PM-104 | World storytelling props | village decor slice | done | 울타리/나무/돌/등불 및 추가 마당 연출 반영 | 유지 | P2 |
| MG-PM-105 | Swallow/nest scene staging | swallow healing slice | done | 담벼락 근처 제비/둥지 연출 추가됨 | 유지 | P2 |
| MG-PM-106 | Post-ending ambient follow-through | 2026-03-28 post-ending ambient followthrough | done | `init.server.luau`에 ambient ending mode, 엔딩별 패치 무드/표지판 문구, Heungbu/Nolbu/tribute basket 분기 대사, restoration/tribute accent prop 가시성 제어가 구현됨 | 유지, Studio 체감만 추가 검증 | P2 |

## UX / Interface

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-201 | Quest HUD | guided quest slice | done | quest title/objective/stats HUD 구현됨 | 유지 | P1 |
| MG-PM-202 | Dialogue box system | guided quest slice | done | RemoteEvent 기반 대화창 구현됨 | 유지 | P1 |
| MG-PM-203 | Dialogue readability / sizing polish | guided quest slice | done | client HUD/dialogue/ending UI가 viewport 기반 responsive sizing으로 재구성되어 `TextScaled` 의존이 줄고 작은 화면에서도 읽기 쉬운 고정 글자 크기와 패널 크기 보정이 들어감 | 유지, Studio 실기에서 최종 체감만 확인 | P2 |
| MG-PM-204 | Stronger cinematic payoff UI/effects | 2026-03-28 payoff presentation pass | done | `StoryEffectEvent` kind/duration/pulse 기반 연출, Heungbu ceremony multi-beat 보상 타이밍, retaliation/restoration presentation이 구현됨 | 유지, Studio 체감만 추가 검증 | P2 |

## Systems / Robustness

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-301 | InsertService fallback houses | runtime robustness goal | done | 집 로드 실패 시 fallback 집 생성 로직 존재 | 유지 | P1 |
| MG-PM-302 | Fallback NPC behavior | runtime robustness goal | done | NPC fallback 생성/운영 로직 존재 | 유지 | P1 |
| MG-PM-303 | Runtime layout table for tuning | placement workflow goal | done | `villageLayout` 구조 도입됨 | 유지 | P2 |
| MG-PM-304 | Anti-z-fighting / terrain overlap fixes | map polish goal | done | 밭 Y 조정 등 수정 이력 있음 | 유지 | P2 |
| MG-PM-305 | Studio/MCP-dependent final validation pass | PM verification | blocked | 코드상 개선은 진행됐지만 일부 항목은 Studio 실검증 필요 | 실측 시 점검 | P1 |

## Current PM Recommendation

### Keep as done
- onboarding / story stone / Heungbu 시작 흐름
- 씨앗/심기/수확/전달 루프
- 놀부 공물 루프
- 제비 부상/약초 치유 퀘스트
- 놀부 순찰 NPC
- 퀘스트 HUD / 대화 시스템
- fallback house / NPC 구조

### Rebuild / revisit soon
- 실제 집 배치/방향/크기 최종 튜닝

### Next new work to prioritize
1. one Studio/MCP validation pass across house placement, dialogue readability, ending aftermath feel, post-ending errand readability, support-point readability, and retaliation yard-marker readability
2. broader post-ending replay extensions beyond errand escalation + point rotation (rare-event variants, extra branch flavor, optional landmark polish)
3. landmark-accrual follow-on that turns repeated post-ending errands into visible restoration/tribute landmark tiers
