# Adopted Design

## Chosen Candidate
문서 중심의 Design Agent Workflow를 프로젝트에 내장하고, 모든 중대 기능은 단계별 산출물을 남기도록 한다.

## Why Chosen
- 구현 리스크가 낮다.
- 바로 적용 가능하다.
- 이후 자동 에이전트/인간 협업 모두에 쓸 수 있다.
- 스토리/시스템/연출 설계 품질을 동시에 올릴 수 있다.

## Why Others Were Rejected
- 별도 자동화 도구/스크립트부터 만드는 방식은 초기에 과하다.
- 게임 런타임 안에 설계 시스템을 넣는 방식은 목적에 비해 복잡하다.

## Player Flow
플레이어 직접 흐름보다는 개발 흐름 개선이 목적이다.

## Quest / State Flow
- 기능 요청 발생
- brief 작성
- proposals 생성
- candidates 압축
- analysis 수행
- adopted design 작성
- verification 통과 후 구현 시작

## World Objects
없음. 이 설계는 개발 워크플로우용이다.

## Server Design
없음.

## Client Design
없음.

## Data Model
문서 산출물 구조만 정의한다.

## Failure / Edge Cases
- 기능이 너무 작으면 전체 단계가 과할 수 있음 → 축약 적용 허용
- 구현이 급하면 brief / adopted design / verification 최소 세트만 사용

## MVP Cut Line
- DESIGN_AGENT.md
- docs/design/README.md
- 템플릿 파일
- 첫 bootstrap 설계 폴더

## Future Extensions
- 설계 점수 자동 집계
- 기능 제안 백로그
- 설계 리뷰 역할 분리
- 구현 후 회고 템플릿 추가
