# MagicGourd Asset IDs

프로젝트에서 사용할 Roblox 에셋 ID를 모아두는 파일.

## Core Character / House Assets

- **Nolbu**
  - Asset ID: `81648951264309`
  - Use: 놀부 캐릭터/NPC 필요 시 참조

- **Nolbu House**
  - Asset ID: `76012677304613`
  - Use: 놀부집 모델 필요 시 참조

- **Heungbu House**
  - Asset ID: `93969099298348`
  - Use: 흥부집 모델 필요 시 참조

## Usage Rule

- 현재 개발 단계에서는 파트 기반 구현을 우선한다.
- 실제 모델이 필요할 때 이 파일의 ID를 참조한다.
- Studio/MCP/런타임 로드에서 불안정성이 있으면, 우선 파트 기반 placeholder를 유지한다.
- 모델/아트 교체 단계에서 이 파일을 기준으로 연결한다.

## Notes

- 이 파일은 "에셋 레지스트리" 역할이다.
- 코드에 하드코딩하기 전에 여기서 먼저 관리하는 것을 우선한다.
- 2026-04-01 static world placement pass에서 `Heungbu House`, `Nolbu House` ID를 사용해 `Workspace.Map.PlacedAssets`에 배치했다.
- 추가 에셋이 생기면 계속 누적한다.
