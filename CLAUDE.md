# CLAUDE.md

## 커밋/푸시 루틴 (필수)

하나의 태스크가 완료되면 반드시 아래 루틴을 따른다.

1. 태스크의 변경분을 논리적 단위의 세부 작업으로 나눈다.
   - 예: 데이터 모델 추가 / repository·provider 구현 / UI 화면 구현 / 라우팅 등록 / 테스트 추가
2. 세부 작업 단위별로 관련 파일만 `git add` 하여 개별 커밋을 만든다.
   - 하나의 커밋에 서로 다른 성격의 변경을 섞지 않는다.
   - 커밋 메시지는 기존 저장소 스타일(영어, 명령형)을 따른다.
3. 모든 세부 커밋이 끝나면 `git push`로 원격에 푸시한다.
4. 커밋 전에 `flutter analyze`와 `flutter test`를 실행해 통과를 확인한다.

## UI 변경 시 스크린샷 프리뷰 (필수)

UI 화면을 새로 만들거나 수정한 경우:

- flutter 위젯 테스트에서 `matchesGoldenFile`을 사용해 해당 화면의 골든(스크린샷) PNG를 프로젝트 루트의 `preview/` 폴더에 저장한다.
- 테스트에서 실제 한글 폰트를 로드하여 한글이 깨지지 않게 렌더링한다.
- `preview/` 폴더에는 **이번 태스크에서 수정한 화면의 스크린샷만** 남긴다.
  1. 골든 생성 전에 `preview/` 폴더의 기존 PNG를 모두 삭제한다.
  2. 수정한 화면의 테스트만 지정해 골든을 생성한다:
     `flutter test --update-goldens test/preview/preview_golden_test.dart --plain-name "<테스트 이름>"`
  3. 전체 갱신(`flutter test --update-goldens`)은 사용자가 명시적으로 요청할 때만 실행한다.
- 골든 테스트는 `--update-goldens` 없이 실행하면 비교를 건너뛰므로, `preview/`에 일부 PNG만 있어도 `flutter test`는 통과한다.
- UI 변경이 없는 태스크에서는 이 단계를 생략한다.
