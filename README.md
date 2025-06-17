# ✈️OGGO

여행을 좋아하는 "오지 마니아"를 위한 맞춤형 여행사 웹 플랫폼
**OGGO**는 사용자 맞춤형 여행 상품 추천, 동행자 모집, Q&A 커뮤니티 등 다양한 기능을 제공하는 웹 기반 여행사 플랫폼입니다. 사용자 경험(UX)을 중심으로 예약의 편의성, 안전성, 탐색 효율성을 높이기 위해 설계되었습니다.

PPT: https://docs.google.com/presentation/d/1vicd2JI_HV7yJ8tI90K5VFAnn4lZ44YZ/edit?usp=sharing&ouid=103656476575692687607&rtpof=true&sd=true

업무분장표: https://docs.google.com/spreadsheets/d/1YrEMrZKyFPtsMr_5ESlqyWjY_eqCMgedgRq8Y3eHgck/edit?usp=sharing

## 프로젝트 기간
2025년 5월 21일 ~ 5월 27일(7일간)

## 팀원 소개

| 이름   | 담당 역할                           |
|--------|-------------------------------------|
| 홍다영 (팀장) | 유효성 검사, 비밀번호 암호화 처리, 회원가입  |
| 문성식 | 관리자 기능, FAQ/QnA 필터링, ECharts 기반 매출 분석 시각화 |
| 오건윤 | 검색 자동완성, 추천 키워드 시스템, 예약 기능 로직 |
| 박정원 | 동행자 모집 기능, FAQ/QnA 시스템, 게시판 제작  |

## 기술 스택

- **Frontend**: JSP, HTML/CSS, JavaScript
- **Backend**: Java Spring MVC (Controller → Service → DAO → Oracle DB)
- **Database**: Oracle
- **Visualization**: ECharts
- **기타 기능**: 비밀번호 암호화 (Salt + Hash), 검색 자동완성, 추천 키워드 기반 필터링

## ERD / 시스템 구조

- Spring 기반 MVC 구조
- 사용자 → JSP(View) → Controller → DAO → Oracle DB
- ERD 및 와이어프레임은 `/docs` 폴더 참고

## 주요 기능

### 사용자 기능

- **회원가입 및 로그인**
  - 랜덤 Salt 및 Hash를 통한 암호화 저장
- **여행 상품 검색 및 예약**
  - 자동완성 및 태그 기반 검색
  - 오버부킹 방지 (프론트/백엔드 이중 확인)
- **동행자 모집**
  - 모집글 등록, 참여 및 상태 자동 업데이트
  - 중복 참여 방지, 참여 인원 수 자동 반영
- **FAQ & QnA**
  - FAQ 자동 전환 (조회수 100 이상 + 답변 존재 시)
  - QnA 미응답 게시물 자동 필터링 및 관리 알림

### 관리자 기능

- **콘텐츠 관리**
  - 불량 키워드 자동 필터링
  - QnA 24시간 내 미응답 관리
- **예약 통계 및 시각화**
  - 월별/상품별 매출 분석
  - ECharts 기반 차트 시각화

## 화면 예시

- 검색어 자동완성
- 태그 기반 필터링
- 관리자용 통계 차트 (매출 추이, 상품 비중 등)

## 개선 및 보완 사항

- 관리자 단어 필터링 기능 고도화 예정
- QnA 답변 시간 초과 시 알림 시스템 추가 예정
- UI/UX 개선 지속 중
