# MagicGourd PM Workflow

이 폴더는 설계와 실제 구현을 비교해서 업무 상태를 관리하는 PM 레이어다.

## 목적

- 설계만 있고 안 된 것 찾기
- 구현은 됐지만 기준 미달인 것 찾기
- 이미 충분히 끝난 것 찾기
- 다음 개발 우선순위를 명확하게 만들기

## 핵심 파일

- `docs/pm/TASKS.md`
  - 전체 업무 체크리스트
- `docs/pm/audits/`
  - 특정 기능/시점 감사 기록

## 상태 정의

- `done`
- `rebuild`
- `new`
- `blocked`

세부 기준은 `PM_AGENT.md`를 따른다.
