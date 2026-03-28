# MagicGourd Design Workflow

이 폴더는 `MagicGourd`의 기능 설계를 위한 작업 공간이다.

## 목적

기능을 바로 구현하지 않고,

- 제안
- 후보화
- 분석
- 채택
- 상세 설계
- 최종 검증

단계를 거쳐 더 정교한 결정을 내리기 위한 구조다.

## 사용 방식

새 기능을 설계할 때마다 다음 형식의 폴더를 만든다.

- `docs/design/YYYY-MM-DD-<feature-slug>/`

예시:

- `docs/design/2026-03-28-blessed-gourd/`
- `docs/design/2026-03-28-nolbu-retaliation/`

그 안에 아래 파일을 채운다.

- `00-brief.md`
- `01-proposals.md`
- `02-candidates.md`
- `03-analysis.md`
- `04-adopted-design.md`
- `05-verification.md`

## 원칙

- 구현 전에 설계 산출물을 남긴다.
- 기능이 작아도 최소한 brief / adopted design / verification은 남긴다.
- 설계는 실제 구현 가능한 수준까지 구체적이어야 한다.
- Roblox 제약, Rojo 구조, 플레이 체감, 서사 연결을 동시에 본다.
