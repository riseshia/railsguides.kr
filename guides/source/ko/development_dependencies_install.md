개발 의존성 설치하기
================================

이 가이드는 Ruby on Rails 개발을 위한 환겨을 설치하는 방법을 설명합니다.

이 가이드에서 다루는 내용:

* Rails 개발 환경 설정하기
* Rails 테스트에서 특정 그룹의 유닛 테스트를 실행하기
* Rails 테스트의 Active Record의 일부를 실행하기

--------------------------------------------------------------------------------

쉬운 방법
------------

개발 환경을 설정하는 가장 쉬운 방법은 [Rails development box](https://github.com/rails/rails-dev-box)를 사용하는 것입니다.

어려운 방법
------------

Rails development box를 사용할 수 없는 경우라면, 아래에서 Ruby on Rails 개발 환경을 직접 만드는 방법을 확인하세요.

### Git 설치하기

Ruby on Rails는 소스 코드 관리를 위해서 Git을 사용하고 있습니다. [Git 홈페이지](http://git-scm.com/)에서 설치하는 방법을 확인하세요. 인터넷 상에는 Git에 익숙해지는데 도움을 줄 수 있는 다양한 자료가 있습니다.

* [Try Git 코스](http://try.github.io/)는 기초적인 사용법을 인터랙티브하게 알려줍니다.
* [공식 문서](http://git-scm.com/documentation)는 포괄적이며 Git의 기초를 설명하는 몇몇 동영상을 포함하고 있습니다.
* [Everyday Git](http://schacon.github.io/git/everyday.html)는 Git을 사용하기에 충분한 내용을 가르쳐줍니다.
* [GitHub](http://help.github.com)는 다양한 Git 자로에 대한 링크 목록을 제공합니다.
* [Pro Git](http://git-scm.com/book)는 Creative Commons license로 Git에 대한 책 전체를 제공합니다.

### Ruby on Rails 저장소 복제하기

Ruby on Rails 소스 코드를 저장하고 싶은 폴더로 이동하세요(그 폴더에 `rails`라는 폴더를 생성할 것입니다). 그리고 다음을 실행하세요.

```bash
$ git clone git://github.com/rails/rails.git
$ cd rails
```

### 설정과 테스트 실행하기

모든 제출된 코드는 테스트를 통과해야 합니다. 새 패치를 추가하든, 다른 사람의 코드를 평가하든, 테스트를 실행할 수 있어야 합니다.

우선 SQLite3과 `sqlite3` 젬을 위한 개발용 파일을 설치하세요. Max OS X 사용자라면 다음을 실행하세요.

```bash
$ brew install sqlite3
```

Ubuntu 사용자라면 apt-get을 사용하세요.

```bash
$ sudo apt-get install sqlite3 libsqlite3-dev
```

Fedora나 CentOS 사용자라면 yum을 사용하세요.

```bash
$ sudo yum install sqlite3 sqlite3-devel
```

Arch Linux 사용자라면 다음을 실행하세요.

```bash
$ sudo pacman -S sqlite
```

FreeBSD 사용자라면 다음을 실행하세요.

```bash
# pkg install sqlite3
```

또는 `databases/sqlite3` 포트를 컴파일하세요.

[Bundler](http://bundler.io/)의 최신 버전을 설치하세요.

```bash
$ gem install bundler
$ gem update bundler
```

그리고 다음을 실행하세요.

```bash
$ bundle install --without db
```

이 명령을 통해서 MySQL과 PostgreSQL 드라이버를 제외한 모든 의존성을 설치합니다.

NOTE: memcached를 사용하는 테스트를 실행하고 싶다면 미리 이를 설치해야 합니다.

OS X 사용자는 [Homebrew](http://brew.sh/)를 사용하여 memcached를 설치할 수 있습니다.

```bash
$ brew install memcached
```

Ubuntu 사용자라면 apt-get을 사용하세요.

```bash
$ sudo apt-get install memcached
```

Fadora나 CentOS라면 yum을 사용하세요.

```bash
$ sudo yum install memcached
```

Arch Linux 사용자라면 다음을 실행하세요.

```bash
$ sudo pacman -S memcached
```

FreeBSD 사용자라면 다음을 실행하세요.

```bash
# pkg install memcached
```

또는 `databases/memcached` 포트를 컴파일하세요.

이제 의존성을 모두 설치하였으니 다음의 명령으로 테스트를 실행할 수 있습니다.

```bash
$ bundle exec rake test
```

Action Pack과 같은 특정 컴포넌트의 테스트만을 실행할 수도 있습니다. 해당 폴더로 이동하여 같은 명령을 실행하세요.

```bash
$ cd actionpack
$ bundle exec rake test
```

`TEST_DIR` 환경 변수를 사용하여 특정 폴더에 있는 테스트만을 실행하고 싶을 수도 있습니다. 예를 들어 다음 명령은 `railties/test/generators` 폴더에 있는 테스트만을 실행합니다.

```bash
$ cd railties
$ TEST_DIR=generators bundle exec rake test
```

다음처럼 특정 파일만을 실행할 수도 있습니다.

```bash
$ cd actionpack
$ bundle exec ruby -Itest test/template/form_helper_test.rb
```

또는 특정 파일의 한 테스트만을 실행할 수도 있습니다.

```bash
$ cd actionpack
$ bundle exec ruby -Itest path/to/test.rb -n test_name
```

### Active Record 설정하기

Active Record의 테스트는 3번 동작합니다. 한 번은 SQLite3으로, 또 한 번은 MySQL로, 나머지 한번은 PostgreSQL로 말이죠. 이들을 위한 환경을 구성하는 방법에 대해서 알아보겠습니다.

WARNING: 만약 Active Record 코드 상에서 작업을 하고 있다면 _반드시_ 적어도 MySQL, PostgreSQL, SQLite3 환경에서 테스트가 성공해야 합니다. 다양한 어댑터간의 사소한 차이가 MySQL에서만 테스트되었던 많은 패치들이 거절된 이유입니다.

#### 데이터베이스 설정하기

Active Record 테스트는 커스텀 설정 파일(`activerecord/test/config.yml`)을 요구합니다. `activerecord/test/config.example.yml`에 샘플이 제공되고 있으므로 환경에 맞게 변경하여 사용하세요.

#### MySQL과 PostgreSQL

MySQL과 PostgreSQL에서 테스트를 실행하려면 필요한 젬을 설치해야 합니다. 서버와 클라이언트 라이브러리, 그리고 개발용 파일들을 설치하세요.

OS X 사용자는 다음을 실행하세요.

```bash
$ brew install mysql
$ brew install postgresql
```

그리고 Homebrew가 제공하는 설명을 따라가세요.

Ubuntu 사용자라면 다음을 실행하세요.

```bash
$ sudo apt-get install mysql-server libmysqlclient-dev
$ sudo apt-get install postgresql postgresql-client postgresql-contrib libpq-dev
```

Fedora나 CentOS 사용자라면 다음을 실행하세요.

```bash
$ sudo yum install mysql-server mysql-devel
$ sudo yum install postgresql-server postgresql-devel
```

만약 Arch Linux 사용자라면 MySQL이 더 이상 지원되지 않으며, MariaDB를 사용해야한다는 점을 알려드립니다([이 공지](https://www.archlinux.org/news/mariadb-replaces-mysql-in-repositories/)를 참고하세요).

```bash
$ sudo pacman -S mariadb libmariadbclient mariadb-clients
$ sudo pacman -S postgresql postgresql-libs
```

FreeBSD 사용자라면 다음을 실행하세요.

```bash
# pkg install mysql56-client mysql56-server
# pkg install postgresql94-client postgresql94-server
```

그리고 다음을 실행하세요.

```bash
$ rm .bundle/config
$ bundle install
```

우선 Bundler가 "db" 그룹을 설치하지 않았다는 사실을 기억하고 있기 때문에 `.bundle/config`를 지웁니다(또는 변경해도 좋습니다).

MySQL에 대한 테스트를 실행하려면 `rails`라는 사용자를 만들고 테스트 데이터베이스에 접근할 수 있는 권한을 부여해야 합니다.

```bash
$ mysql -uroot -p

mysql> CREATE USER 'rails'@'localhost';
mysql> GRANT ALL PRIVILEGES ON activerecord_unittest.*
       to 'rails'@'localhost';
mysql> GRANT ALL PRIVILEGES ON activerecord_unittest2.*
       to 'rails'@'localhost';
mysql> GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.*
       to 'rails'@'localhost';
```

그리고 테스트 데이터베이스를 생성합니다.

```bash
$ cd activerecord
$ bundle exec rake db:mysql:build
```

PostgreSQL의 인증은 조금 다르게 동작합니다. Linux나 BSD일 경우에 개발용 계정과 개발용 환경을 설정하려면 다음을 실행하세요.

```bash
$ sudo -u postgres createuser --superuser $USER
```

OS X 사용자는 다음을 실행하세요.

```bash
$ createuser --superuser $USER
```

그리고 테스트 데이터베이스를 생성하세요.

```bash
$ cd activerecord
$ bundle exec rake db:postgresql:build
```

그러면 이제 PostgreSQL과 MySQL에서 데이터베이스를 구성할 수 있습니다.

```bash
$ cd activerecord
$ bundle exec rake db:create
```

다음을 통해서 데이터베이스를 제거할 수도 있습니다.

```bash
$ cd activerecord
$ bundle exec rake db:drop
```

NOTE: rake 명령을 사용하여 테스트 데이터베이스를 만들면, 올바른 문자 형식과 collation으로 생성할 수 있습니다.

NOTE: PostgreSQL 9.1.x 이하에서 HStore 익스텐션을 활성화하는 도중에 "WARNING: => is deprecated as an operator"와 같은 경고를 볼 수 있습니다.

만약 다른 데이터베이스를 사용하고 있다면 `activerecord/test/config.yml`나 `activerecord/test/config.example.yml`를 확인하고 기본 연결 설정에 대해서 확인하세요. 필요하다면 컴퓨터에 있는 별도의 자격 인증을 `activerecord/test/config.yml`에 추가해도 좋습니다. 하지만 이러한 변경사항들을 Rails에 커밋해서는 안됩니다.

### Action Cable 설정하기

Action Cable은 Redis를 기본 구독 어댑터([더 읽기](action_cable_overview.html#브로드캐스트))로 사용합니다. 그러므로 Action Cable 테스트를 위해서는 Redis를 설치하고 실행중인 상태이어야 합니다.

#### Redis를 소스로부터 설치하기

Redis 문서에서는 버전이 자주 갱신되기 때문에 패키지 매니저를 통한 설치를 권장하지 않습니다. 소스로부터 설치하고 이를 서버에 적용하는 방법에 대해서는 [Redis 설치하기 문서](http://redis.io/download#installation)에 잘 기술되어 있습니다.

#### Redis를 패키지 매니저를 통해 설치하기

OS X 사용자라면 다음을 실행하세요.

```bash
$ brew install redis
```

그리고 Homebrew가 제공하는 지시를 따르세요.

Ubuntu 사용자라면 다음을 실행하세요.

```bash
$ sudo apt-get install redis-server
```

Fedora나 CentOS(EPEL이 활성화되어 있어야 합니다) 사용자는 다음을 실행하세요.

```bash
$ sudo yum install redis
```

Arch Linux 사용자라면 다음을 실행하세요.

```bash
$ sudo pacman -S redis
$ sudo systemctl start redis
```

FreeBSD 사용자라면 다음을 실행하세요.

```bash
# portmaster databases/redis
```
