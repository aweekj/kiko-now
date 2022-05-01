## MVVM Architecture

다음 글은 Advanced iOS App Architecture 의 Chapter 5. Architecture: MVVM 을 공부하며 정리한 내용입니다.

책에선 MVVM Architecture 에 관하여 목적 및 각 Layer 의 역할을 기술하고, 후반부엔 전반부에 기술한 내용을 기반으로 실제 코드가 어떤식으로 짜여지게 되는지를 설명합니다.

이론적인 내용을 정리하여 전반부를 요약 및 정리하여 기술합니다.



layout: post
title: Architecture: MVVM
tags:

  - iOS
  - Architecture
  - MVVM



## MVVM

MVVM 이 있기 전 일반적으로 디자이너가 뷰 컴포넌트를 drag&drop 하여 배치하고 프로그래머가 각 뷰에 코드를 작성하였습니다. 이건 곧 view 로직과 business logic 간의 강한 결합도를 야기했습니다. 디자이너들은 work flow 에 제한에서 자유를 잃었고, 간단한 변경사항에도 거대한 코드를 다시써야 하는 일이 발생하곤 했습니다. 이러한 어려운점들에 의해 MS는 뷰와 비즈니스 로직을 분리 시킨 MVVM 을소개했습니다. 이 완화된 pain 포인트는 UI 를 바꾸고, 개발자로하여금 너무 많은 코드로 수정을 하지 않도록 해주었습니다.

모바일 개발, iOS 에 와서는 MS 가 지향했던 MVVM 의 모토와 조금은 다릅니다. iOS 에선 디자이너들이 직접 UI 를 생성하지 않습니다. 그들은 제플린과 같은 툴로 UI 를 넘기고 이를 기반으로 개발자들은 스토리보드나 Constraints 를 배치하면서 UI 를 직접 그립니다. 

MVVM의 처음 목적과 다르게 디자이너가 직접 Xcode로 하여금 뷰를 만들도록 하려는게 아닙니다. 오히려 Model 과 View 간의 관계를 분리하는것에 초점을 맞추고 있습니다. 물론 디자이너는 자유롭게 디자인을 할 수 있고 개발자도 많은 비즈니스 논리 로직을 변경할 필요가 없습니다.



## What is it?

그럼 MVVM 은 무엇일까. 

MVVM 을 대표하는 키워드는  'reactive' 입니다. MVVM 는 반응형 구조입니다. 그 말은 곧 view 는 viewModel 의 변화에 반응을 하게 되고 view Model 은 그것의 state를 model 로 부터 온 data에 의해 갱신한다는 의미입니다. 이런 Reactive 한 구조는 view 의 렌더링 로직고 비즈니스 로직을 완벽히 분리가 가능케 합니다. 또한 Presentation Layer(View) 와 Data Layer(Model) 간의 커뮤니케이션을 ViewModel 에 의존하게 함으로써 uni-directional 한 의존 방향을 갖도록합니다.

![What is it?](/images/CreamyCoup/Whatisit.png)



## MVVM 의 Three Layer

The model layer 는 로직의 유효성과 데이터를 포함하는 객체에 접근을 담당합니다. Model Layer 는 데이터를 어떻게 잃고 쓰는지 알고 있습니다.The view model layer 는 view의 상태와 user Interaction 에 대한 핸들링 로직을 포함합니다. Model 의 데이터를 읽고 쓰는 메소드를 호출합니다. 그리고 Model 데이터의 변화를 감지합니다. The View layer 는 스크린의 요소들을 디스플레이하고 스타일링합니다. View Layer는 viewModel 의 프로퍼티를 Visual Elements 들에 bind 합니다. 

이 구조를 통해서 View 와 Model Layer 는 decoupled 되고 View와 Model 은 오직 ViewModel 을 통해서만 통신이 가능하게 됩니다.



### Model Layer

* Model 의 책임은 생성하고 읽고 갱신하고 삭제하는 CRUD operations 에 있습니다
* Model Layer 를 디자인할 때 push-and-pull 과 observe-and push 디자인을 사용할 수 있습니다.
* push-and-pull
  * consumers 가 데이터를 요청하고 response 를 기다리는 구조이다.이걸 Pull 파트라고 합니다.
  * consumers 는 Model 데이터를 업데이트하고, 모델 계층에게 Send 하라고 요청한다. 이걸 Push 파트라고 합니다.
* Observe-and-push
  * Consumer가 Model 데이터의 변경을 관측합니다. 데이터를 직접 요청하는 것과는 다르다. 이 후 push-pull 처럼 Model 에게 데이터를 Send 하라고 요청합니다.

### Repository Pattern

* Repository(저장소)들은 서버에게 호출하거나 디스크로부터 읽어오는 Data Access Objects 들을 포함합니다.
* Repository 는 네트워킹, 지속성 및 인메모리 캐싱을 위한 파사드를 제공합니다.
* Repository는 consumers 가 어떻게 데이터를 검색하고 저장하는지를 외부에 표출하지 않습니다.
* ViewModel 은 이 repository 를 사용하여 자체 메소드에서 실행하는 것을 대체하고 model Data로 부터 전달 받은 데이터를 view 에 display 를 위한 데이터로 가공합니다.
* 이 패턴의 장점은 개발에 유연성을 제공한다는 것이다. ViewModel 은 View를 위한 데이터를 가공처리 하는 것 외에 역할을 축소한다면 해당 API 를 사용하는 다른 프로젝트에서도 이 Repository 는 얼마든지 재사용이 가능합니다.

![Repository](/images/CreamyCoup/repositorypattern.png)

### ViewModel Structure

* ViewModel 의 View와의 One-way 통신을 가능케합니다. ViewModel 프로퍼티를 View 가 바인드하고, 버튼과 같은 View의 interaction 로직을 ViewModel 의 메소드로 수행을 합니다.
* 이런 ViewModel 은 Massive 한 VC 문제와 같은 현상을 방지합니다. ViewModel 은 MVVM에서 가장 중요한 요소가 되며 조금 더 깊게 구조를 파악해 봅니다.

#### View State

ViewModel 은 View 의 State 를 관리합니다. View 의 인터렉션이나 기타 반응등을 통해 State 가 변경되면 이에 따른 로직을 실행합니다.

* 예제코드에선 Combine 을 사용합니다. Combine 을 사용하는 ViewModel 에선 @published 프로퍼티를 사용합니다. viewModel 이 생성될 때 UI는 published 된 프로퍼티를 subscribe 합니다.

* Task Methods - UI 의 인터렉션에 반응하는 메소드입니다 .API 를 호출하는 것과 같은 작업을 하고나면 ViewModel의 state 를 업데이트 합니다.  Task Method 는 target-action pair 를 사용하기 때문에 @objc 를 주로 붙여서 사용합니다. 물론 이게 강제될 필요는 없는걸로 보입니다.

* Dependencies - 이제 이 ViewModel 을 생성할때 의존성 주입을 진행합니다. ViewModel 은 repository 와 같은 하위 시스템을 사용하고 기본 구현에 대한 지식은 없습니다. 일종의 컨테이너로 이용하는 것으로 보입니다.

  

## Communicating amongst view Models

ViewModel 은 State 가 변경될 때 이를 앱의 나머지 부분에 신호를 보내야 하는 순간이 생깁니다. 하나의 Task 가 반드시 하나의 View 에 종속된다는 보장이 없기 때문입니다.

ViewModel 이 외부에 전달하는 것은 무엇을 해야할지보다 일어난 일을 전달하고, 이를 통해서 유연성을 강화합니다.

ViewModel 은 다음의 세가지 방법으로 다른 부분들과 collaborating 합니다.
* Closures - 외부로 신호를 보내기 위해 생성자에 Closure 를 argu 로 받습니다. event 가 발생할때 해당 closure 를 호출합니다.
* Protocols - 하나의 메소드 프로토콜과 함께 각 output 신호들을 모델링합니다.
* Publishers - viewModel 은 publisher를 외부로 공개합니다. 이 publisher는 값을 업데이트하여 다른 뷰모델이 수정할 수 있도록 상태를 제공합니다.

관련된 예가 있을까 하고 고민해보았을때 ViewModel 간의 통신이 필요한 예는 Cell 에서 찾을 수 있었습니다. Cell 내에서의 인터렉션에 따라 Cell의 ViewModel 이 움직이게 되고, Cell을 의존하고 있는 외부 View의  ViewModel 에 Cell의 인터렉션을 알려야하는 상황이 종종 있습니다. 이럴 경우 Cell을 의존하는 View의 ViewModel 이 Cell 에 의존성을 주입해줘야 합니다.



## Navigating

MVC에서 Navigating은 단순했슨비다. 버튼을 누르면 navigation Stack을 쌓으면서 push 하면 됐습니다. 하지만 하나의 VC가 다양한 화면으로 이동이 필요할 경우 많은 수의 클래스를 의존해야 하는 상황이 발생합니다. 또한 VC는 곧 View 가 되는 UIKit 에서 이는 렌더링 이외의 로직으로 풀이가 됩니다.따라서 MVVM에선 이 로직 역시 viewModel 의 메소드 호출로 이루어져야 합니다.

#### Model driven navigation

* Model 지향적인 navigation 방식에선 viewModel 이 View가 네비게이팅 가능한 상태 enum 을 묘사합니다. 시스템은 값이 변경될 때의 네비게이팅을 하기 위해 해당 값을 관측합니다.
* ContainerView 는 그들의 자식 뷰들의 상태를 관측하고 있다가 변경이 되면 top level 의 네비게이션을 사용합니다.

#### System-driven navigation

* 쉽게 말해 System의 제스쳐 시그널을 사용하는 방식입니다.(Ex: Swipe-Back)
* ViewModel 은 제스쳐를 핸들링 하는 메소드를 override 하여 동작합니다. 대부분의 시스템에선 과잉 스펙이 됩니다.

#### Combination

* 두 방식의 장점만을 흡수하여 사용하는 방식입니다.
* 예를 들어 앞으로 이동할때엔 Model driven navigation 을 사용하고, 뒤로 갈때엔 System-driven navigation 을 사용한다.
* 로그인 화면을 예로 들고 해당 화면엔 welcome, sign-up, sign-in State 가 있다고 가정합니다. 버튼등의 액션으로 해당 state(Welcome, sign-up, sign-in) 가 변경됨을 감지하면 화면을 이동합니다. 그 외에 Back 버튼이나 Swipe 등의 제스쳐를 감지하면 뒤로가기를 동작하게 합니다.



## Pros of MVVM

MVVM 의 장점에 관해서 정리합니다.

1. VM은 UI 코드의 테스트 독립성을 쉽게 하기 위해 나왔다. UI 를 전혀 포함하고 있지 않습니다. - 비즈니스와 검증 로직만을 포함합니다.
2. View와 Model 완벽하게 디커플링 됩니다.
3. MVVM 프로그래머간 병렬적인 프로그래밍을 가능케 합니다. 생상성 향상
4. 컨테이너 뷰와 자식 뷰를 통해 모듈식 UI 를 구성할 수 있습니다. (MVVM 이 모듈화되진 않지만 모듈화를 하는데에 걸림돌이 되지 않습니다.)
5. UIKit에 종속되지 않기 때문에 VM은 Apple Platform 사이에서 공유가 가능합니다. 개인적으로 가장 큰 장점이지 않을까 생각됩니다.



## Cons of MVVM

MVVM 의 단점에 관해서 정리합니다.

1. Combine 에 대한 러닝 커브가 있습니다. 예제는 Combine 을 사용했지만 기타 반응형 프로그래밍 프레임워크(RxSwift) 등을 사용해도 무방합니다. 물론 이에 따른 러닝 커브는 여전히 존재합니다.
2. 일반적인 구현은 협업하기 위해 ViewModel 필요합니다. 협업 보기 모델을 사용할 때 앱에서 메모리를 관리하고 상태를 동기화하는 것이 더 어렵습니다.
3. 비즈니스 로직은 ViewModel 에 특정 뷰 로직이 포함되기 때문에 다른 뷰들간의 재사용이 안됩니다. 
4. UI 업데이트는 메소드 호출 대신에 바인딩으로 이루어짐으로 디버깅하기가 어렶습니다.
5. VM 은 UI 의 상태와 의존성을 동시에 보유합니다. 이것은 VM 의 가독성을 떨어뜨립니다. 왜냐하면 State 관리는 사이드 이펙트와 의존성들이 혼합되어지기 때문입니다.



## Key Points

* Model 층은 disk의 데이터를 읽고 쓰고 데이터가 변경되었을 시 viewModel 에 알려주는 역할을 합니다.
* VM Layer 는 View Layer 의 상태와 user의 인터렉션을 핸들링합니다. VM은 Model 층의 변경을 주시하고 VM의 상태를 업데이트 합니다.
* 뷰 레이어는 뷰 모델 상태가 바뀔 때 반응하고 사용자가 구성 요소와 상호 작용할 때 뷰 모델을 알려줍니다.
* Respository 는 Networking 과 유지(로컬 DB) 를 하기위한 Facde가 됩니다. VM은 작업 자체를 수행하는 대신 repository 를 통해 데이터를 접근합니다.

* view, model 계층은 완벽하게 디커플링 되어있습니다. 오직 VM 을 통해서만 통신이 가능합니다.



