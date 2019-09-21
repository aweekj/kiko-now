# Kiko Now

*Read this in other languages: [English](README.md), [한국어](README.ko.md).*

**Jekyll** 은 GitHub Pages 로 호스팅하는 블로그를 만드는 최적의 정적 사이트 생성기입니다. ([Jekyll Repository](https://github.com/jekyll/jekyll))

**Kiko Now** 는 **[Jekyll Now](https://github.com/barryclark/jekyll-now)** 를 기반으로 만들어진 Jekyll 블로그 테마로, 간단한 기본 설정만으로도 블로그를 쉽게 만들 수 있도록 하는 **Jekyll Now** 의 철학을 따르고 있습니다.

![Kiko Now Theme Screenshot](/images/kiko-now-theme-screenshot.png "Kiko Now Theme Screenshot")

## 간단히 시작해볼까요

### Step 1) 이 repository 를 본인의 repository 에 Fork 하세요.

이 repository 를 Fork 하고, repository 이름을 `yourgithubusername.github.io` 로 변경하세요. 그러고 나면 <https://yourgithubusername.github.io> 에서 당신의 Jekyll 블로그를 볼 수 있습니다. (만약 즉시 보이지 않는다면 조금 기다리거나 Step 2 에서 강제로 적용하는 방법이 있습니다.)

*NOTE:* `yourgithubusername` 부분에는 본인의 GitHub 아이디를 입력해야 동작합니다.

### Step 2) 기본 설정을 본인의 것으로 커스터마이징 하세요.

`_config.yml` 파일에서 블로그의 이름, 설명, 아바타 등 다양한 옵션을 수정할 수 있습니다. 구글 애널리틱스, Discus 댓글 시스템, SNS 아이콘 설정도 이곳에서 할 수 있습니다.

`_config.yml` 파일 (또는 repository에 포함된 다른 파일) 을 수정하면 GitHub Pages 에서 자동으로 블로그를 새로고침 합니다. 수정된 블로그는 몇 초 후에 <https://yourgithubusername.github.io> 에서 확인 할 수 있습니다. 만약 바로 나타나지 않으면 GitHub 에서 가이드한 대로 10분 정도 기다려보면 나타날 것입니다.

블로그의 파일을 수정하는 방법은 대략 3가지가 있습니다.
1. 브라우저에서 본인의 repository 를 직접 수정하는 방법(아래 이미지 참고)
2. [Prose](http://prose.io)와 같은 에디터를 사용해서 수정하는 방법(Prose를 사용하면 Jekyll 블로그의 마크다운 수정, 초고 작성, 이미지 업로드 등을 쉽게 할 수 있습니다.)
3. repository를 로컬에 Clone 하고, 로컬에서 수정한 뒤 GitHub 에 Push 하는 방법

![_config.yml](/images/config.png "_config.yml")

### Step 3) 블로그에 첫번째 글을 작성해보세요.

`/_posts/2017-10-08-hello-world.md` 파일을 수정하여 첫번째 글을 작성해보세요. `/_posts/2016-08-14-style-test-ko.md`의 스타일 적용법과 [적용 결과]((https://aweekj.github.io/kiko-now/style-test-ko/))를 참고하면 다양한 스타일을 적용할 수 있습니다.

![First Post](/images/post-screenshot.png "First Post")

브라우저에서 새로운 글을 생성하여 작성할 수도 있습니다.`/_posts/`에서 + 아이콘을 눌러보세요. 두 가지만 주의하면 됩니다. 파일 이름을 `연도-월-일-제목.md` 로 만들고, 파일 상단의 Frontmatter 형식을 지켜주세요.
```

#### Frontmatter
---
layout: post
title: "글 제목"
tags: [태그1, 태그2, 태그3]
comments: true
---
```

## 로컬에서 블로그를 띄워보실 분들을 위하여..

1. Jekyll과 플러그인을 한 번에 설치하는 방법이 있습니다. 성공적으로 설치된다면 GitHub Pages 에서 사용되는 Jekyll, Sass 등이 한 번에 설치됩니다. `gem install github-pages`
2. 본인의 repository 를 로컬에 Clone 합니다. `git clone https://github.com/yourusername/yourusername.github.io.git`
3. 서버를 띄웁니다. `jekyll serve`
4. http://127.0.0.1:4000/ 에서 확인합니다.
5. 변경을 Commit 하고 본인의 repository 에 Push 합니다. 그러면 GitHub Pages 가 자동으로 블로그를 재생성 합니다.

## 질문이 있다면?

[새로운 이슈](https://github.com/aweekj/kiko-now/issues/new)를 등록해주세요.
