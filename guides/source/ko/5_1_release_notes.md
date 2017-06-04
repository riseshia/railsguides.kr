**DO NOT READ THIS FILE ON GITHUB, GUIDES ARE PUBLISHED ON http://guides.rubyonrails.org.**

Ruby on Rails 5.1 릴리스 노트
===============================

Rails 5.1에서 주목할 점

* Yarn 지원
* 조건부 Webpack 지원
* jQuery는 더 이상 기본 의존성이 아님
* 시스템 테스트
* 암호화된 secrets
* 메일러에 인자를 넘길 수 있게 됨
* 직접 & 다형 라우트
* form_for와 form_tag를 form_with로 통합

이 릴리스 노트에서는 주요 변경점에 대해서만 설명합니다. 수정된 버그 및 변경점에
대해서는 GitHub에서 확인할 수 있는 changelog나
[커밋 목록](https://github.com/rails/rails/commits/5-1-stable)을 참고해주세요.

--------------------------------------------------------------------------------

Rails 5.1로 업그레이드하기
----------------------

기존 애플리케이션을 업그레이드한다면 그 전에 충분한 테스트 커버리지를 확보하는
것이 좋습니다. 애플리케이션이 Rails 5.0로 업그레이드되지 않았다면 우선 이를
우선하고, 애플리케이션이 정상적으로 동작하는지 충분히 확인한 뒤에 Rails 5.1로
올려주세요. 업그레이드 시의 주의점에 대해서는
[Ruby on Rails 업그레이드 가이드](upgrading_ruby_on_rails.html#rails-5-0에서-rails-5-1로-업그레이드)를 참고해주세요.


주요 변경점
--------------

### Yarn 지원

[Pull Request](https://github.com/rails/rails/pull/26836)

Rails 5.1은 NPM의 JavaScript 의존성을 Yarn을 통해서 관리할 수 있도록 해줍니다.
이를 통해 React, VueJS와 같은 NPM 세계의 라이브러리들을 쉽게 사용할 수 있습니다.
Yarn은 어셋 파이프라인과 통합되어 있으므로, Rails 5.1 앱과 부드럽게 동작합니다.

### 조건부 Webpack 지원

[Pull Request](https://github.com/rails/rails/pull/27288)

Rails 앱은 JavaScript 어셋 번들러인 [Webpack](https://webpack.js.org/)과
통합될 수 있으며, 새 [Webpacker](https://github.com/rails/webpacker) 젬을
통해서 쉽게 사용할 수 있습니다. Webpack 통합 기능을 함께 사용하시려면 `--webpack`
옵션을 사용하여 새 앱을 생성하세요.

이는 어셋 파이프라인과 완전히 호환되며, 다시 말해 이미지, 폰트, 소리 등의 어셋들을
그대로 사용할 수 있습니다. 또는 몇몇 JavaScript 코드만 어셋 파이프라인을 통해서
관리하고 나머지 코드는 Webpack을 통해서 처리할 수도 있습니다. 이 모든 것들은
기본적으로 Yarn을 통해서 관리됩니다.

### jQuery는 더 이상 기본 의존성이 아님

[Pull Request](https://github.com/rails/rails/pull/27113)

jQuery는 Rails의 `data-remote`, `data-confirm` 등의 겸손한 JavaScript 기능을
제공하기 위하여 이전부터 기본 의존성으로 사용되었습니다. UJS가 이제 의존성이 없는
JavaScript로 재작성되었으므로 더 이상 필수가 아니게 되었습니다. 이 코드는 이제
Action View의 내부에서 `rails-ujs`라는 형태로 포함됩니다.

필요하다면 여전히 jQuery를 사용할 수 있지만, 이제 필수가 아닙니다.

### 시스템 테스트

[Pull Request](https://github.com/rails/rails/pull/26703)

Rails 5.1에는 시스템 테스트라는 형태로 Capybara 테스트를 작성하는 가능이
포함되었습니다. 이제 더이상 Capybara나 관련 테스트들의 데이터베이스 정리 전략을
신경쓸 필요가 없습니다. Rails 5.1은 테스트를 크롬에서 동작시키기 위한 래퍼를
제공하며, 이는 실패할 경우의 스크린샷 찍기 등의 추가 기능을 가지고 있습니다.

### 암호화된 secrets

[Pull Request](https://github.com/rails/rails/pull/28038)

Rails는 이제 [sekrets](https://github.com/ahoward/sekrets) 잼을 통해,
애플리케이션의 secret을 안전한 방법으로 다룰 수 있도록 합니다.

새로운 암호화된 secret 파일을 설정하려면 `bin/rails secrets:setup`을 실행하세요.
이는 마스터 키를 생성하며, 이는 반드시 저장소의 외부에 보관해야 합니다.
secret은 암호화된 상태로 버전 관리 시스템에 안전하게 저장할 수 있습니다.

Secret은 배포 환경에서 `RAILS_MASTER_KEY` 환경 변수나 키 파일을 통해서
복호화됩니다.

### 메일러에 인자를 넘길 수 있게 됨

[Pull Request](https://github.com/rails/rails/pull/27825)

인스턴스 변수나 헤더, 그 외의 공통 설정을 메일러 클래스의 모든 메소드에서
공유할 수 있도록 일반화된 인자를 넘길 수 있게 됩니다.

``` ruby
class InvitationsMailer < ApplicationMailer
  before_action { @inviter, @invitee = params[:inviter], params[:invitee] }
  before_action { @account = params[:inviter].account }

  def account_invitation
    mail subject: "#{@inviter.name} invited you to their Basecamp (#{@account.name})"
  end
end

InvitationsMailer.with(inviter: person_a, invitee: person_b)
                 .account_invitation.deliver_later
```

### 직접 & 다형 라우트

[Pull Request](https://github.com/rails/rails/pull/23138)

Rails 5.1은 `resolve`와 `direct`라는 라우팅 DSL을 추가했습니다. `resolve`는
모델의 다형성 매핑을 변경할 수 있게 해줍니다.

``` ruby
resource :basket

resolve("Basket") { [:basket] }
```

``` erb
<%= form_for @basket do |form| %>
  <!-- basket form -->
<% end %>
```

이는 `/baskets/:id`라는 일반적인 경로 대신에 `/basket` 이라는 단수형 URL을
생성합니다.

`direct` 메소드는 임의의 URL 헬퍼를 생성합니다.

``` ruby
direct(:homepage) { "http://www.rubyonrails.org" }

>> homepage_url
=> "http://www.rubyonrails.org"
```

블럭의 반환값은 `url_for`에 넘겼을 때 유효한 값이어야 합니다. 그러므로
유효한 문자열 URL, Hash, Array, Active Model 인스턴스, Active Model 클래스를
사용할 수 있습니다.

``` ruby
direct :commentable do |model|
  [ model, anchor: model.dom_id ]
end

direct :main do
  { controller: 'pages', action: 'index', subdomain: 'www' }
end
```

### form_for와 form_tag를 form_with로 통합

[Pull Request](https://github.com/rails/rails/pull/26976)

Rails 5.1 이전에는 HTML 폼을 처리하기 위한 2개의 인터페이스가 존재했습니다.
모델 인스턴스를 위한 `form_for`와 임의의 URL을 위한 `form_tag`가 그것입니다.

Rails 5.1은 이 인터페이스들을 `form_with`로 합쳤으며, URL, 스코프, 모델을 사용해
폼 태그를 생성할 수 있습니다.

URL을 사용하는 경우:

``` erb
<%= form_with url: posts_path do |form| %>
  <%= form.text_field :title %>
<% end %>

<%# 는 다음을 생성합니다. %>

<form action="/posts" method="post" data-remote="true">
  <input type="text" name="title">
</form>
```

스코프를 추가하면 input 필드 이름에 접두사가 추가됩니다. 

``` erb
<%= form_with scope: :post, url: posts_path do |form| %>
  <%= form.text_field :title %>
<% end %>

<%# 는 다음을 생성합니다. %>

<form action="/posts" method="post" data-remote="true">
  <input type="text" name="post[title]">
</form>
```

모델을 사용하면 URL과 스코프를 추론합니다.

``` erb
<%= form_with model: Post.new do |form| %>
  <%= form.text_field :title %>
<% end %>

<%# 는 다음을 생성합니다. %>

<form action="/posts" method="post" data-remote="true">
  <input type="text" name="post[title]">
</form>
```

저장된 모델 인스턴스는 업데이트를 위한 폼을 생성하며, 필드의 값을 채웁니다.

``` erb
<%= form_with model: Post.first do |form| %>
  <%= form.text_field :title %>
<% end %>

<%# 는 다음을 생성합니다. %>

<form action="/posts/1" method="post" data-remote="true">
  <input type="hidden" name="_method" value="patch">
  <input type="text" name="post[title]" value="<the title of the post>">
</form>
```

비호환 목록
-----------------

다음 변경사항들은 업그레이드에 앞서 반드시 처리되어야 합니다.

### 여러 커넥션을 사용하는 트랜잭션 테스트

트랜잭션 테스트는 이제 데이터베이스 트랜젝션에 포함된 모든 Active Record 커넥션을
감싸게 됩니다.

테스트가 추가 스레드를 생성하고, 그 스레드에서 데이터베이스 커넥션을 생성하는
경우, 이들은 특별하게 관리됩니다.

스레드들은 하나의 커넥션을 공유하며, 트랜잭션의 내부에서 관리됩니다.
이는 외부의 트랜잭션과 관계 없이 모든 스레드가 같은 상태의 데이터베이스를
바라보도록 보장합니다. 예를 들어, 이전에는 이러한 추가 커넥션들은 픽스쳐의
데이터를 가져오지 못했습니다.

스레드가 중첩된 트랜잭션에 돌입하는 경우, 고립 상태를 유지하기 위해서
일시적으로 커넥션을 독점하게 됩니다.

만약 테스트가 생성된 스레드에서 트랜젝션의 외부에서 분리된 커넥션에 의존한다면
이를 좀 더 명시적인 커넥션 관리 방식으로 바꾸어야 합니다.

만약 테스트가 스레드를 생성하고, 그 스레드들이 명시적인 데이터베이스 트랜젝션을
사용하고 있다면, 데드락을 야기하게 됩니다.

이 새로운 사양으로 야기되는 문제에서 벗어나려면 영향 범위에 있는 테스트에서
트랜잭션 테스트를 비활성화하는 것이 가장 쉬운 방법일 것입니다.

Railties
--------

자세한 변경 사항은 [Changelog][railties]를 확인하세요.

### 제거

*   제거 예정이었던 `config.static_cache_control`이 제거되었습니다.
    ([commit](https://github.com/rails/rails/commit/c861decd44198f8d7d774ee6a74194d1ac1a5a13))

*   제거 예정이었던 `config.serve_static_files`이 제거되었습니다.
    ([commit](https://github.com/rails/rails/commit/0129ca2eeb6d5b2ea8c6e6be38eeb770fe45f1fa))

*   제거 예정이었던 파일 `rails/rack/debugger`이 제거되었습니다.
    ([commit](https://github.com/rails/rails/commit/7563bf7b46e6f04e160d664e284a33052f9804b8))

*   제거 예정이었던 태스크(`rails:update`, `rails:template`, `rails:template:copy`,
    `rails:update:configs`, `rails:update:bin`)가 제거되었습니다.
    ([commit](https://github.com/rails/rails/commit/f7782812f7e727178e4a743aa2874c078b722eef))

*   제거 예정이었던`CONTROLLER` environment variable for `routes` task.
    ([commit](https://github.com/rails/rails/commit/f9ed83321ac1d1902578a0aacdfe55d3db754219))

*   `rails new` 명령어에서 -j (--javascript) 옵션이 제거되었습니다.
    ([Pull Request](https://github.com/rails/rails/pull/28546))

### 주요 변경점

*   `config/secrets.yml`에 공통 부분이 추가되었으며, 이는 모든 환경에서
    로드됩니다.
    ([commit](https://github.com/rails/rails/commit/e530534265d2c32b5c5f772e81cb9002dcf5e9cf))

*   `config/secrets.yml` 파일은 이제 모든 키를 심볼로 로드합니다.
    ([Pull Request](https://github.com/rails/rails/pull/26929))

*   jquery-rails가 기본 스택에서 제거됨. 기본 UJS 어댑터는 rails-ujs에 포함되어
    Action View에 들어감.
    ([Pull Request](https://github.com/rails/rails/pull/27113))

*   Yarn에 대한 지원의 일부로 새 앱에는 yarn을 위한 빈스텁과 package.json이 포함됨.
    ([Pull Request](https://github.com/rails/rails/pull/26836))

*   `--webpack` 옵션으로 새 앱을 생성하면 rails/webpacker 젬을 추가하여
    Webpack을 지원함.
    ([Pull Request](https://github.com/rails/rails/pull/27288))

*   새 애플리케이션을 생성할 때에 `--skip-git` 옵션이 없는 경우 Git 저장소를
    초기화함.
    ([Pull Request](https://github.com/rails/rails/pull/27632))

*  `config/secrets.yml.enc`이라는 암호화된 secrets이 추가됨.
    ([Pull Request](https://github.com/rails/rails/pull/28038))

*   `rails initializers` 명령이 railtie 클래스 이름을 출력하도록 변경.
    ([Pull Request](https://github.com/rails/rails/pull/25257))

Action Cable
-----------

자세한 변경 사항은 [Changelog][action-cable]를 확인하세요.

### 주요 변경점

*   같은 Redis서버를 사용하는 여러 애플리케이션 간의 이름 충돌을 방지하기 위하여
    `cable.yml`의 Redis와 이벤트 Redis 어댑터에 `channel_prefix` 지원이 추가됨.
    ([Pull Request](https://github.com/rails/rails/pull/27425))

*   같은 도메인을 가지는 커넥션을 기본으로 허용.
    ([commit](https://github.com/rails/rails/commit/dae404473409fcab0e07976aec626df670e52282))

*   브로드캐스트된 데이터를 위한 `ActiveSupport::Notifications` 훅이 추가됨.
    ([Pull Request](https://github.com/rails/rails/pull/24988))

Action Pack
-----------

자세한 변경 사항은 [Changelog][action-pack]를 확인하세요.

### 제거

*   `ActionDispatch::IntegrationTest`와 `ActionController::TestCase`의 클래스에서
    `#process`, `#get`, `#post`, `#patch`, `#put`, `#delete`, `#head`에서
    키워드를 사용하지 않는 인수들에 대한 지원이 제거됩니다.
    ([Commit](https://github.com/rails/rails/commit/98b8309569a326910a723f521911e54994b112fb),
    [Commit](https://github.com/rails/rails/commit/de9542acd56f60d281465a59eac11e15ca8b3323))

*   제거 예정이었던 `ActionDispatch::Callbacks.to_prepare`와
    `ActionDispatch::Callbacks.to_cleanup`가 제거됩니다.
    ([Commit](https://github.com/rails/rails/commit/3f2b7d60a52ffb2ad2d4fcf889c06b631db1946b))

*   제거 예정이었던 컨트롤러 필터 관련 메소드가 제거됩니다.
    ([Commit](https://github.com/rails/rails/commit/d7be30e8babf5e37a891522869e7b0191b79b757))

### 제거 예정

*   `:controller`, `:action` 경로 매개변수가 제거될 예정입니다.
    ([Pull Request](https://github.com/rails/rails/pull/23980))

*   `config.action_controller.raise_on_unfiltered_parameters`가 제거 예정입니다.
    이는 Rails 5.1에 어떤 영향도 주지 않습니다.
    ([Commit](https://github.com/rails/rails/commit/c6640fb62b10db26004a998d2ece98baede509e5))

### 주요 변경점

*   라우팅 DSL에 `direct`와 `resolve` 메소드가 추가됩니다.
    ([Pull Request](https://github.com/rails/rails/pull/23138))

*   시스템 테스트를 위한 새로운 `ActionDispatch::SystemTestCase` 클래스가
    추가됩니다.
    ([Pull Request](https://github.com/rails/rails/pull/26703))

Action View
-------------

자세한 변경 사항은 [Changelog][action-view]를 확인하세요.

### 제거

*   제거 예정이었던 `ActionView::Template::Error`의 `#original_exception`가 제거됩니다.
    ([commit](https://github.com/rails/rails/commit/b9ba263e5aaa151808df058f5babfed016a1879f))

*   `strip_tags`로부터 `encode_special_chars` 옵션이 제거됩니다.
    ([Pull Request](https://github.com/rails/rails/pull/28061))

### 제거 예정

*   Erubis ERB 핸들러가 제거 예정이 됩니다. Eruby를 사용하세요.
    ([Pull Request](https://github.com/rails/rails/pull/27757))

### 주요 변경점

*   로우 템플릿 핸들러(Rails 5의 기본 템플릿 핸들러)는 이제
    HTML 안전한 문자열을 출력합니다.
    ([commit](https://github.com/rails/rails/commit/1de0df86695f8fa2eeae6b8b46f9b53decfa6ec8))

*   `datetime_field`와 `datetime_field_tag`가 `datetime-local` 필드를
    생성합니다.
    ([Pull Request](https://github.com/rails/rails/pull/28061))

*   HTML 태그를 위한 새 빌더 스타일 문법 추가(`tag.div`, `tag.br` 등)
    ([Pull Request](https://github.com/rails/rails/pull/25543))

*   `form_tag`와 `form_for`의 용도를 합친 `form_with`를 추가.
    ([Pull Request](https://github.com/rails/rails/pull/26976))

*   `current_page?`에 `check_parameters` 옵션을 추가함.
    ([Pull Request](https://github.com/rails/rails/pull/27549))

Action Mailer
-------------

자세한 변경 사항은 [Changelog][action-mailer]를 확인하세요.

### 주요 변경점

*   메일러 액션, 메시지 전송, 지연된 전송 작업에서 발생한 에러를 `rescue_from`으로
    잡을 수 있습니다.
    ([commit](https://github.com/rails/rails/commit/e35b98e6f5c54330245645f2ed40d56c74538902))

*   첨부 파일이 포함되어 있고, 본문이 인라인으로 설정되어 있을 경우에 커스텀
    컨텐츠 타입을 지정할 수 있게 됨.
    ([Pull Request](https://github.com/rails/rails/pull/27227))

*   `default` 메소드에 람다를 값으로 넘길 수 있게 됨.
    ([Commit](https://github.com/rails/rails/commit/1cec84ad2ddd843484ed40b1eb7492063ce71baf))

*   서로 다른 메일러 액션에서 before 필터와 기본값을 공유하기 위해,
    파라미터화된 메일러의 호출에 대한 지원을 추가.
    ([Commit](https://github.com/rails/rails/commit/1cec84ad2ddd843484ed40b1eb7492063ce71baf))

*   메일러 액션에 넘겨진 인자들을 `process.action_mailer` 이벤트의 `args` 키로
    가져올 수 있음.
    ([Pull Request](https://github.com/rails/rails/pull/27900))

Active Record
-------------

자세한 변경 사항은 [Changelog][action-record]를 확인하세요.

### 제거

*   `ActiveRecord::QueryMethods#select`에서 블록과 인자를 같이 넘기는 방식이
    제거됨.
    ([Commit](https://github.com/rails/rails/commit/4fc3366d9d99a0eb19e45ad2bf38534efbf8c8ce))

*   제거 예정이었던 `activerecord.errors.messages.restrict_dependent_destroy.one`와
    `activerecord.errors.messages.restrict_dependent_destroy.many`의 i18n 스코프가 제거됨.
    ([Commit](https://github.com/rails/rails/commit/00e3973a311))

*   제거 예정이었던 어소시에이션 리더의 강제 리로드 옵션이 제거됨.
    ([Commit](https://github.com/rails/rails/commit/09cac8c67af))

*   제거 예정이었던 `#quote`에 컬럼을 넘기는 기능이 제거됨.
    ([Commit](https://github.com/rails/rails/commit/e646bad5b7c))

*   제거 예정이었던 `#tables`의 `name` 인수가 제거됨.
    ([Commit](https://github.com/rails/rails/commit/d5be101dd02214468a27b6839ffe338cfe8ef5f3))

*   제거 예정이었던 `#tables`와 `#table_exists?`이 테이블과 뷰를 반환하던 동작이
    테이블만을 반환함.
    ([Commit](https://github.com/rails/rails/commit/5973a984c369a63720c2ac18b71012b8347479a8))

*   제거 예정이었던 `ActiveRecord::StatementInvalid#initialize`와
    `ActiveRecord::StatementInvalid#original_exception`의 `original_exception` 인수가 제거됨.
    ([Commit](https://github.com/rails/rails/commit/bc6c5df4699d3f6b4a61dd12328f9e0f1bd6cf46))

*   제거 예정이었던 쿼리의 값으로 클래스를 넘기는 기능이 제거됨.
    ([Commit](https://github.com/rails/rails/commit/b4664864c972463c7437ad983832d2582186e886))

*   제거 예정이었던 LIMIT에서 쉼표를 사용하여 질의하는 기능이 제거됨.
    ([Commit](https://github.com/rails/rails/commit/fc3e67964753fb5166ccbd2030d7382e1976f393))

*   제거 예정이었던 `#destroy_all`의 `conditions` 매개 변수가 제거됨.
    ([Commit](https://github.com/rails/rails/commit/d31a6d1384cd740c8518d0bf695b550d2a3a4e9b))

*   제거 예정이었던 `#delete_all`의 `conditions` 매개 변수가 제거됨.
    ([Commit](https://github.com/rails/rails/pull/27503/commits/e7381d289e4f8751dcec9553dcb4d32153bd922b))

*   제거 예정이었던 `#load_schema_for`가 제거됨. 앞으로는  `#load_schema`를 사용.
    ([Commit](https://github.com/rails/rails/commit/419e06b56c3b0229f0c72d3e4cdf59d34d8e5545))

*   제거 예정이었던 `#raise_in_transactional_callbacks` 옵션이 제거됨.
    ([Commit](https://github.com/rails/rails/commit/8029f779b8a1dd9848fee0b7967c2e0849bf6e07))

*   제거 예정이었던 `#use_transactional_fixtures` 옵션이 제거됨.
    ([Commit](https://github.com/rails/rails/commit/3955218dc163f61c932ee80af525e7cd440514b3))

### 제거 예정

*   `error_on_ignored_order_or_limit`이 제거 예정이 됨.
    `error_on_ignored_order`를 사용할 것.
    ([Commit](https://github.com/rails/rails/commit/451437c6f57e66cc7586ec966e530493927098c7))

*   `sanitize_conditions`이 제거 예정이 됨. `sanitize_sql`를 사용할 것.
    ([Pull Request](https://github.com/rails/rails/pull/25999))

*   커넥션 어댑터의 `supports_migrations?`이 제거 예정이 됨.
    ([Pull Request](https://github.com/rails/rails/pull/28172))

*   `Migrator.schema_migrations_table_name`이 제거 예정이 됨. `SchemaMigration.table_name`을 대신 사용할 것.
    ([Pull Request](https://github.com/rails/rails/pull/28351))

*   쿼팅과 타입 캐스팅에서 사용하는 `#quoted_id`이 제거 예정이 됨.
    ([Pull Request](https://github.com/rails/rails/pull/27962))

*   `#index_name_exists?`의 `default` 인자가 제거 예정이 됨.
    ([Pull Request](https://github.com/rails/rails/pull/26930))

### 주요 변경점

*   기본키의 기본 타입이 BIGINT로 변경됨.
    ([Pull Request](https://github.com/rails/rails/pull/26266))

*   MySQL 5.7.5+, MariaDB 5.2.0+에 대한 가상/생성된 컬럼 지원이 추가됨.
    ([Commit](https://github.com/rails/rails/commit/65bf1c60053e727835e06392d27a2fb49665484c))

*   배치 프로세싱에서의 갯수 제한 지원이 추가됨.
    ([Commit](https://github.com/rails/rails/commit/451437c6f57e66cc7586ec966e530493927098c7))

*   트랜잭셔널 테스트는 이제 데이터베이스의 모든 Active Record 접속을
    감쌈.
    ([Pull Request](https://github.com/rails/rails/pull/28726))

*   `mysqldump` 명령의 출력에서 주석을 기본으로 생략하도록 변경.
    ([Pull Request](https://github.com/rails/rails/pull/23301))

*   `ActiveRecord::Relation#count`가 블럭이 넘겨지면 이를 무시하지 않고,
    루비의 `Enumerable#count`를 사용하여 레코드의 갯수를 세도록 변경.
    ([Pull Request](https://github.com/rails/rails/pull/24203))

*   SQL 에러를 무시하지 않도록 `psql`에 `"-v ON_ERROR_STOP=1"`를 넘김.
    ([Pull Request](https://github.com/rails/rails/pull/24773))

*   `ActiveRecord::Base.connection_pool.stat`을 추가.
    ([Pull Request](https://github.com/rails/rails/pull/26988))

*   `ActiveRecord::Migration`를 직접 상속하면 에러를 던짐.
    어떤 버전의 Rails를 사용하고 있는지 명시할 것.
    ([Commit](https://github.com/rails/rails/commit/249f71a22ab21c03915da5606a063d321f04d4d3))

*   `through`가 애매한 리플렉션 이름을 가지고 있는 경우 에러를 던짐.
    ([Commit](https://github.com/rails/rails/commit/0944182ad7ed70d99b078b22426cbf844edd3f61))

Active Model
------------

자세한 변경 사항은 [Changelog][action-model]를 확인하세요.

### 제거

*   제거 예정이었던 `ActiveModel::Errors`의 메소드들을 제거.
    ([commit](https://github.com/rails/rails/commit/9de6457ab0767ebab7f2c8bc583420fda072e2bd))

*   제거 예정이었던 길이 검증자의 `:tokenizer` 옵션을 제거.
    ([commit](https://github.com/rails/rails/commit/6a78e0ecd6122a6b1be9a95e6c4e21e10e429513))

*   제거 예정이었던 콜백이 false를 반환하는 경우 체인이 종료되던 동작을 제거.
    ([commit](https://github.com/rails/rails/commit/3a25cdca3e0d29ee2040931d0cb6c275d612dffe))

### 주요 변경점

*   모델 속성에 할당 되었던 원 문자열이 더이상 잘못 얼려지지 않도록
    변경됨.
    ([Pull Request](https://github.com/rails/rails/pull/28729))

Active Job
-----------

자세한 변경 사항은 [Changelog][active-job]를 확인하세요.

### 제거

*   제거 예정이었던 `queue_adapter`에 클래스를 넘기는 기능을 제거.
    ([commit](https://github.com/rails/rails/commit/d1fc0a5eb286600abf8505516897b96c2f1ef3f6))

*   제거 예정이었던 `ActiveJob::DeserializationError`의 `#original_exception`을 제거.
    ([commit](https://github.com/rails/rails/commit/d861a1fcf8401a173876489d8cee1ede1cecde3b))

### 주요 변경점

*   `ActiveJob::Base.retry_on`와 `ActiveJob::Base.discard_on`를 통한 선언적인 에러 처리 기능을 추가.
    ([Pull Request](https://github.com/rails/rails/pull/25991))

*   재시도 실패 뒤의 처리를 위한 블록에 잡 인스턴스를 넘겨주게 되며
    `job.arguments` 처럼 접근할 수 있습니다.
    ([commit](https://github.com/rails/rails/commit/a1e4c197cb12fef66530a2edfaeda75566088d1f))

Active Support
--------------

자세한 변경 사항은 [Changelog][active-support]를 확인하세요.

### 제거

*   `ActiveSupport::Concurrency::Latch` 클래스를 제거.
    ([Commit](https://github.com/rails/rails/commit/0d7bd2031b4054fbdeab0a00dd58b1b08fb7fea6))

*   `halt_callback_chains_on_return_false`를 제거.
    ([Commit](https://github.com/rails/rails/commit/4e63ce53fc25c3bc15c5ebf54bab54fa847ee02a))

*   제거 예정이었던 콜백이 false를 반환하여 체인을 종료하는 동작을 제거.
    ([Commit](https://github.com/rails/rails/commit/3a25cdca3e0d29ee2040931d0cb6c275d612dffe))

### 제거 예정

*   최상위 `HashWithIndifferentAccess` 클래스가 제거 예정이 되었으며,
    `ActiveSupport::HashWithIndifferentAccess` 사용을 권장함.
    ([Pull Request](https://github.com/rails/rails/pull/28157))

*   `set_callback`과 `skip_callback`의 `:if`와 `:unless` 조건부 옵션에 문자열을 넘기는 기능이 제거 예정이 됨.
    ([Commit](https://github.com/rails/rails/commit/0952552)

### 주요 변경점

*   기간 파싱과 DST 관련 시간 변경에 대한 일관성을 가지도록 수정.
    ([Commit](https://github.com/rails/rails/commit/8931916f4a1c1d8e70c06063ba63928c5c7eab1e),
    [Pull Request](https://github.com/rails/rails/pull/26597))

*   Unicode의 버전이 9.0.0이 됨.
    ([Pull Request](https://github.com/rails/rails/pull/27822))

*   Duration#before와 #after를 #ago와 #since의 별칭으로 추가함.
    ([Pull Request](https://github.com/rails/rails/pull/27721))

*   현재 객체에서 정의되지 않은 매소드 호출을 프록시 오브젝트로 위임하는
    `Module#delegate_missing_to`를 추가.
    ([Pull Request](https://github.com/rails/rails/pull/23930))

*   현재 날짜/시간을 기준으로 하루의 시작부터 끝을 표현하는 범위 객체를
    반환하는 `Date#all_day`를 추가.
    ([Pull Request](https://github.com/rails/rails/pull/24930))

*   테스트를 위한 `assert_changes`와 `assert_no_changes` 메소드를 추가.
    ([Pull Request](https://github.com/rails/rails/pull/25393))

*   `travel`과 `travel_to` 메소드는 중첩된 호출을 할 수 없도록 변경.
    ([Pull Request](https://github.com/rails/rails/pull/24890))

*   `DateTime#change`가 usec과 nsec을 지원하도록 변경.
    ([Pull Request](https://github.com/rails/rails/pull/28242))

크레딧 표기
-------

Rails를 견고하고 안정적인 프레임워크로 만들기 위해 많은 시간을 사용해주신 많은 개발자들에 대해서는 [Rails 기여자 목록](http://contributors.rubyonrails.org/)을 참고해주세요. 이 분들에게 경의를 표합니다.

[railties]:       https://github.com/rails/rails/blob/5-1-stable/railties/CHANGELOG.md
[action-pack]:    https://github.com/rails/rails/blob/5-1-stable/actionpack/CHANGELOG.md
[action-view]:    https://github.com/rails/rails/blob/5-1-stable/actionview/CHANGELOG.md
[action-mailer]:  https://github.com/rails/rails/blob/5-1-stable/actionmailer/CHANGELOG.md
[action-cable]:   https://github.com/rails/rails/blob/5-1-stable/actioncable/CHANGELOG.md
[active-record]:  https://github.com/rails/rails/blob/5-1-stable/activerecord/CHANGELOG.md
[active-model]:   https://github.com/rails/rails/blob/5-1-stable/activemodel/CHANGELOG.md
[active-support]: https://github.com/rails/rails/blob/5-1-stable/activesupport/CHANGELOG.md
[active-job]:     https://github.com/rails/rails/blob/5-1-stable/activejob/CHANGELOG.md
