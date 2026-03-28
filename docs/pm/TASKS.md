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
| MG-PM-006 | Nolbu retaliation after magic payoff | 2026-03-28 blessed seed payoff design | done | Nolbu jealousy 대화, patch bramble sabotage, clear-brambles recovery 단계가 구현됨 | 유지, 후속 retaliation 확장만 검토 | P1 |
| MG-PM-007 | Ending / branching outcome structure | 2026-03-28 branching ending structure | done | `FINAL_AUDIENCE -> CHOOSE_ENDING -> ENDING_RESTORATION/ENDING_TRIBUTE -> COMPLETE` 흐름, 선택 UI RemoteEvent, ending 결과/HUD 힌트/간판 반영 구현됨 | 유지, Studio 체감만 추가 검증 | P1 |

## NPC / World

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-101 | Nolbu wandering patrol NPCs | village runtime slice | done | 배회 NPC 2명/pathfinding 구현 보고됨 | 실제 체감만 계속 다듬기 | P1 |
| MG-PM-102 | Heungbu interaction presence | village runtime slice | done | Heungbu 대화/보상 루프 존재 | 유지 | P1 |
| MG-PM-103 | House placement/orientation final polish | house setup goal | rebuild | fallback/런타임 안정화는 있으나 실제 자산 배치 완성도는 미확정 | Studio 기준 튜닝 | P1 |
| MG-PM-104 | World storytelling props | village decor slice | done | 울타리/나무/돌/등불 및 추가 마당 연출 반영 | 유지 | P2 |
| MG-PM-105 | Swallow/nest scene staging | swallow healing slice | done | 담벼락 근처 제비/둥지 연출 추가됨 | 유지 | P2 |

## UX / Interface

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-201 | Quest HUD | guided quest slice | done | quest title/objective/stats HUD 구현됨 | 유지 | P1 |
| MG-PM-202 | Dialogue box system | guided quest slice | done | RemoteEvent 기반 대화창 구현됨 | 유지 | P1 |
| MG-PM-203 | Dialogue readability / sizing polish | guided quest slice | rebuild | 실제 화면 기준 검증 필요 메모 존재 | 실기 검증 후 보정 | P2 |
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
- 대화창 실제 화면 가독성 조정

### Next new work to prioritize
1. house placement/orientation final polish
2. dialogue readability / sizing polish
3. retaliation expansion beyond the current sabotage beat
4. richer post-ending ambient follow-through / replay variations
