---
layout: post
title: "Bottom Alert View (1)"
tags: [alert]
comments: true
---

#### Write By
![민경준]([jxxnnee (민경준) - velog](https://velog.io/@jxxnnee))

### Tool Info
Xcode 13.3
Swift 5.6
SnapKit 5.0.1
RxSwift 6.0.0
RxCocoa 6.0.0

*
## Declaration
앱에서 커스텀한 `BottomAlertView`를 제작한 과정을 적어 봤습니다.
해당 `View`를 통해 여러가지의 `Alert`를 띄울 수 있도록 모듈화 시킨 `View` 입니다.

View 안에는 tableView가 들어갈 수 있고, 아니면 버튼 두개의 Alert가 들어갈 수도 있습니다.
자유롭게 어떤 구성이든 넣을 수 있는 것들이 모듈화 된 view의 장점이라 생각합니다.

동작의 원리는 간단합니다. 우선 먼저 만들어 둔 `contentView`를 `viewController`에서 `viewWillAppear`하는 순간에 애니메이션을 통해 오프셋을 변경하여 올라오는 모습을 보여주도록 하면 됩니다.<br_><br_>

## Initialize
*아래 코드들은 모두 `BottomAlertViewController` 내부에 들어가는 코드입니다.*

초기에 세팅은 반드시 `override` 해야 할 변수들과 `viewWillAppear` 했을 때 사용할 함수 정도로 했습니다.
```swift
final class AlertView: UIView {

}

open var contentView: AlertView {
	get {
    	return nil
    }
}
open var alertHeight: CGFloat {
    get {
        return 0.0
    }
}
open var backgrounColor: UIColor {
    get {
        return .clear
    }
}

fileprivate var topConstraint: Constraint?
fileprivate var backgroundView = UIView()

fileprivate func retain(animated: Bool = true) {

}
```

<br/>

하지만 여기서 시행착오가 발생합니다. `contentView`를 `override` 하여 만들게 될 경우에 해당 변수를 호출하여 `get`을 하게 될 때마다 새로운 객체를 생성하기 때문에 기존의 객체는 사라지고 새로운 객체가 만들어지게 됩니다.

```swift
override var contentView: AlertView {
	get {
    	let contentView = AlertView()
        contentView.backgroundColor = .black
        contentView.addSubview(self.tableView)
        
        return contentView
    }
}
```

<br/>

이렇게 될 경우 아래의 그림과 같이 기존 `contentView-1`에 `addSubview` 해둔 `UITableView`가 새롭게 만든 객체 `contentView-2`로 소유권이 이동하게 되면서 기존의 `contentView-1`이 `tableView`를 잃게 됩니다. 그렇게 되면 실제로 화면에서도 사라지게 되어 깔끔한 처리가 불가능하게 됩니다.

![](https://velog.velcdn.com/images/jxxnnee/post/f659f228-3217-4a12-be5e-4042686996cd/image.png)

<br/>
그리하여 contentView는 override 하지 못하고, 대신 override할 함수를 만들어 retain() 함수가 동작할 때 같이 한번만 동작하도록 만들었습니다. 해당 함수에서는 contentView의 constraint에 관한 내용이 들어가 있어야 합니다.

```swift
public var contentView: AlertView = AlertView()
open func setConstraint() { 

}

fileprivate func retain(animated: Bool = true) {
	self.setConstraint()
}
```
<br/>
다음으로는 `retain(animated:)`함수 안에 `contentView`를 띄우기 위한 코드를 작성하도록 합니다.

```swift
filepriate func retain(animated: Bool = true) {
	self.backgroundView.backgroundColor = self.backgroundColor
    self.view.addSubview(self.backgroundView)
    self.backgroundView.snp.makeConstraints({
        $0.top.bottom.left.right.equalTo(self.view)
    })
    
    let size = CGSize(width: 414.0, height: self.alertHeight)
    self.view.addSubview(self.contentView)
    self.contentView.backgroundColor = .white
    self.contentView.isUserInteractionEnabled = true
    
    /// ContentView가 아래에서 위로 올라오는 효과를 주기 위해
    /// y축의 좌표를 화면의 가장 아래에 위치하도록 설정해준다.
    self.contentView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
    self.contentView.frame.size = size
    
    self.contetView.snp.makeConstraint { make in
    	/// 마찬가지로 아래에서 위로 올라오는 효과를 위해 
        /// 화면의 bottom에서 부터 alertSize의 height 만큼의 높이로
        /// contentView의 top constraint를 고정시켜준다.
    	self.topConstraint = 
        	make.top.equalTo(self.view.snp.bottom).inset(size.height).constraint
        make.size.equalTo(size)
        make.centerX.equalTo(self.view)
    }
    
    self.topConstraint?.activate()
    
    /// contentView의 상단만 둥근 모양을 내기 위하여 
    /// topLeft, topRight만 radius값을 설정한다.
    self.contentView.roundCorners(corners: [.topLeft, .topRight], radius: 14 - Size.ratioH)
    self.contentView.layoutIfNeeded()
    
    /// animation 효과를 줄지 여부에 따라 
    /// animated 함수를 사용한다.
    if animated {
    	UIView.animated(withDuration: 0.5, animations: { [weak self] in
        	self?.view.layoutIfNeeded()
        })
    } else {
    	self.view.layoutIFNeeded()
    }
}
```


<br/>

자, 이제 준비는 모두 마쳤습니다. 이제 `viewWillAppear(_:)` 함수에서 `retain(animated:)` 함수를 호출하여 실제로 `alertView`가 올라오는지 확인만 하면 됩니다.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
    self.retain(animated: true)
}
```

<br/>

테스트를 위해 `AlertTestViewController`를 만들고 `BottomAlertViewController`를 부모 클래스로 상속합니다. 그리고 사용할 `ViewController`에서 `AlertViewController`를 생성하여 `present` 해봅니다.

```swift
class AlertTestViewController: BottomAlertViewController {
    override var alertHeight: CGFloat {
        get {
            return 400.0
        }
    }
    override var backgrounColor: UIColor {
        get {
            return .clear
        }
    }
    override func setConstraint() {
        super.setConstraint()
        
        let label = UILabel()
        label.text = "ALERT TEST VIEW CONTROLLER"
        label.textColor = .black
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
    }
}

class ViewController: UIViewController {
	override func viewDidLoad() {
    	super.viewDidLoad()
     	
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
        /// present 함수는 view의 hierarchy가 정상적으로 구조화 되어 있어야 하기 때문에
        /// hierarchy가 구조화 되어있지 않은 lifeCycle인 viewDidLoad 보단 
        /// viewWillAppear 이후에 view hierarachy가 완성 되므로
        /// viewDidAppear에서 실행하는것이 맞다.
        let alertTestViewController = AlertTestViewController()
        alertTestViewController.view.backgroundColor = .black
        alertTestViewController.modalPresentationStyle = .overFullScreen
        self.present(alertTestViewController, animated: false)
    }
}
```

<br/>

## Result

![](https://velog.velcdn.com/images/jxxnnee/post/a11acce7-7d2c-4183-adfd-d94e2a4135fa/image.gif)



<br/>

*

### Reference
https://soulpark.wordpress.com/2012/06/15/why-presentmodalviewcontroller-not-work-in-viewdidload/

### Review
viewDidLoad에서 present를 하면 동작하지 않는다는 사실을 처음 알았다... 역시 아직 공부가 아주 많이 많이 필요하다는걸 느꼈습니다... 😭

다음 편에는 올라온 BottomAlert를 어떻게 해제 시키는지와 키보드가 올라왔을 때 대처에 대해서 적어 보도록 하겠습니다. 🤗 
