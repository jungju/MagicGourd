# MagicGourd Developer Workflow

이 폴더는 PM 업무 리스트를 실제 구현으로 옮기는 개발 레이어다.

## 기본 흐름

1. `docs/pm/TASKS.md`에서 우선순위 높은 업무 선택
2. 관련 설계 문서 확인
3. 구현
4. 플레이 가능 상태 확인
5. 커밋
6. 다음 업무로 연결

## 기준 문서

- `AGENTS.md`
- `docs/pm/TASKS.md`
- 활성 설계 폴더의 `04-adopted-design.md` / `05-verification.md`
- 현재 코드 상태

## 역할 분리

- 설계 문서는 무엇을 왜 만들지 정의한다.
- PM 문서는 지금 무엇이 `done` / `rebuild` / `new` / `blocked`인지 정리한다.
- 개발 레이어는 그 우선순위를 실제 구현으로 옮긴다.
