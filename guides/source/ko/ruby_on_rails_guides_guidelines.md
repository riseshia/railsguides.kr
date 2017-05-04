
Rails 가이드의 가이드라인
===============================

이 가이드는 Ruby on Rails 가이드를 작성하기 위한 가이드라인 입니다. 이 가이드 자체가 이 가이드에 따라서 작성되었으며, 바람직한 가이드라인의 예가 됨과 동시에 우아한 루프를 형성하고 있습니다.

이 가이드의 내용:

* Rails 문서의 기술
* 가이드를 로컬에서 생성하기

--------------------------------------------------------------------------------

마크다운(Markdown)
-------

가이드는 [GitHub Flavored Markdown](https://github.github.com/github-flavored-markdown/)으로 작성되어 있습니다. 참고자료로 정리된 [Markdown 문서](http://daringfireball.net/projects/markdown/syntax), [치트 시트](http://daringfireball.net/projects/markdown/basics), 일반 마크다운과의 차이점에 관한 [문서](https://github.github.com/github-flavored-markdown/)가 있습니다.

Prologue
--------

가이드의 시작 부분에는 독자들의 동기부여를 위한 내용을 기술해주세요. 가이드의 파란색 부분이 이에 해당합니다. 프롤로그에서는 그 가이드의 개요와 가이드에서 배울 수 있는 것들에 대해서 설명해주세요. 예제로서 [Rails 라우팅](routing.html)을 참고해주세요.

제목
------

가이드의 제목에는 `h1`, 가이드의 절에는 `h2`, 작은 절에는 `h3`를 각각 사용해주세요. 그리고 실제로 생성된 HTML에서는 `<h2>`부터 시작됩니다.

```
가이드의 타이틀
===========

절
-------

### 작은 절
```

관사, 전치사, 접속사, be동사 이외의 단어는 모두 대문자로 시작해주세요.

```
#### Middleware 스택은 배열
#### 객체가 저장되는 타이밍
```

일반 텍스트와 같은 스타일을 사용해주세요.

```
##### `:content_type` 옵션
```

API 문서의 작성법
----------------------------

가이드와 API는 필요한 장소에서 각각 수미일관되어야 합니다. [API 문서 작성 가이드라인](api_documentation_guidelines.html)의 다음 절을 참고해주세요.

* [어조](api_documentation_guidelines.html#어조)
* [샘플 코드](api_documentation_guidelines.html#샘플-코드)
* [파일명](api_documentation_guidelines.html#파일-이름)
* [폰트](api_documentation_guidelines.html#폰트)

이 가이드라인은 가이드에서도 적용됩니다.

HTML 가이드
-----------

가이드를 생성하기 전에 시스템에 최신 Bundler가 설치되었는지 확인하세요. 현 시점에서는 1.3.5가 설치되어있어야 합니다.

최신 Bundler를 설치하려면 `gem install bundler`를 실행해주세요.

### 생성

모든 가이드를 생성하려면 `cd` 명령으로 `guides` 폴더에 이동하여 `bundle install`를 실행한 뒤에 다음 중 하나를 실행합니다.

```
bundle exec rake guides:generate
```

또는

```
bundle exec rake guides:generate:html
```

`my_guide.md` 파일만을 생성하고 싶은 경우에는 환경변수 `ONLY`를 사용합니다.

```
touch my_guide.md
bundle exec rake guides:generate ONLY=my_guide
```

기본으로는 변경이 없는 가이드의 생성은 생략되므로 `ONLY`를 사용할 기회는 많지 않을 것입니다.

모든 가이드를 강제적으로 생성하려면 `ALL=1`를 주면 됩니다.

생성할 때에는 `WARNINGS=1`를 지정하기를 권장합니다. 이를 통해 중복된 ID를 찾을 수 있으며, 내부 링크가 깨져있는 경우에도 경고가 출력됩니다.

영어 이외의 언어에서 생성하고 싶은 경우에는 `source` 폴더밑의 `source/es`와 같이 해당 언어의 폴더를 생성하고 `GUIDES_LANGUAGE` 환경변수를 넘겨주세요.

```
bundle exec rake guides:generate GUIDES_LANGUAGE=es
```

생성 스크립트의 설정에 사용할 수 있는 환경변수를 모두 알고 싶은 경우에는 다음을 실행하면 됩니다.

```
rake
```

### 검증

생성된 HTML을 검증하기 위해 다음을 실행하세요.

```
bundle exec rake guides:validate
```

특히 제목을 사용해서 ID가 생성되기 때문에, 제목이 중복될 가능성이 높습니다. 중복을 찾기 위해서는 가이드를 생성할 때에 `WARNINGS=1`를 지정해주세요. 경고와 함께 해결할 방법이 출력됩니다.

Kindle 가이드
-------------

### 생성

Kindle 용 가이드를 생성하기 위해서 다음의 rake 태스크를 실행해주세요.

```
bundle exec rake guides:generate:kindle
```

TIP: 이 가이드는 [Rails Guilde 일본어판](http://railsguides.jp)으로부터 번역되었습니다.
