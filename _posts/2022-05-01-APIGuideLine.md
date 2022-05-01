---
layout: post
title: "Swift API Design Guidelines"
tags: [Swift API Design Guidelines, Swift]
comments: true
---

[이 글](https://www.swift.org/documentation/api-design-guidelines/)의 번역본입니다. 제가 개발하면서 중간중간 참고하려고 적은 글이라 문서 전체가 번역되어있지는 않습니다. 예제는 공식문서의 것도 있고, 개인적으로 틈틈히 찾아서 추가도 하고 있습니다.

## Fundamentals(기본 개념)
- **사용 시점에서의 명료성**은 가장 중요한 목표입니다.
- **명료성은 간결성보다 더 중요**합니다.
- 모든 선언문에 **문서화 주석을 작성**하세요.(개인별로 의견이 다를 수 있을 것 같네요.)


_**만약 당신이 당신의 API의 기능을 간단한 용어로 설명하지 못한다면, 당신은 잘못된 API 설계했을 수 있습니다.
**_
## Naming(네이밍)
### Promote Clear Usage(분명한 사용을 촉진하세요)
**1. 필요한 단어들을 모두 포함해주세요.**
> ⭕️ **_Good_**   
```swift
extension List {
  public mutating func remove(at position: Index) -> Element
}
employees.remove(at: x) // at이 있어서 employees라는 List의 x번째를 제거하라는 것이 명확함.
```
> ❌ **_Bad_**   
```swift
employees.remove(x) // 명확하지 않다. x를 제거하라는 건지.. x번째를 제거하라는 건지
```

**2. 불필요한 단어를 생략하세요.**

> ⭕️ **_Good_**   
```swift
allViews.remove(cancelButton) 
```
> ❌ **_Bad_**   
```swift
//allViews.removeElement(cancelButton) // bad, Element가 굳이 필요없다.
```

**3. 타입대신 역할에 따라 변수, 파라미터, 연관타입을 네이밍하세요.**
> ⭕️ **_Good_**   
```swift
var greeting = "Hello" //good, 인사라는 역할이 잘 드러난다.
```
> ❌ **_Bad_**   
```swift
var string = "Hello" //bad, string이 무엇을 뜻하는지 알 수 없다.
```

> ⭕️ **_Good_**   
```swift
class ProductionLine { 
// good
// ProductionLine라는 클래스에서 떨어진 제품을 다시 채워주는 restock이라는 메소드를 구현하려고 한다. 
// 단순히 WidgetFactory 이라는 타입명을 파라미터로 사용해면 얘가 무슨 역할을 하는지 잘 알 수 없다. 
// 그래서 supplier라는 파라미터를 네이밍해서 "아 얘가 위젯을 공급해주는 공급자구나"라고 명시적으로 표현한다.
  func restock(from supplier: WidgetFactory) {} 
}
```
> ❌ **_Bad_**   
```swift
  func restock(from widgetFactory: WidgetFactory) {} // bad, 의미 불분명 
```

> ⭕️ **_Good_**   
```swift
protocol ViewController {
  associatedtype ContentView: View //good, 역할이 분명하게 드러나는 것이 좋다.
}
```
> ❌ **_Bad_**   
```swift
protocol ViewController {
  associatedtype ViewType: View //bad, 연관값의 역할이 모호하다.
}
```

> ✅ **_Exception_**   
```swift
// good
// 만약 associated type이 해당 protocol 제약에 강하게 결합되어 있어서 protocol 이름 자체가 역할(role)을 표현하다면, 충돌을 피하기 위해서 protocol 이름의 마지막에 Protocol 을 붙여줄 수 있습니다.
protocol Sequence {
  associatedtype Iterator : IteratorProtocol
}
protocol IteratorProtocol { ... }
```


**4. 파라미터의 역할을 드러내기 위해 타입의 정보를 보충하세요.**
> ⭕️ **_Good_**   
```swift
final class MyNoti {
    private var observers: [String: Any] = [:]   
    //good
    func add(_ observer: Any, forKeyPath keyPath: String) {
        observers[keyPath] = observer
    }
}
// good,
// forKeyPath라는 아규먼트 레이블을 붙이는 것이 왜 더 좋은거냐면, observers가 [String: Any] 타입이라 그렇다.
// String이 key값이기 때문에, for라고만 표현해놓으면 뭘 넣으라는 건지 도통 읽기만 해서는 알기 어렵다.
// 특히 파라미터 타입이 NSObject, Any, AnyObject, 또는 기본 타입(Int 또는 String 같은 타입) 이라면, 타입 정보와 사용하는 시점의 문맥이 의도를 충분히 드러내지 못할 수 있다.
noti.add("?", forKeyPath: "아 키패스를 넣으라는 거구나") 
```
> ❌ **_Bad_**   
```swift
final class MyNoti {
    private var observers: [String: Any] = [:]   
    //good
    func add(_ observer: Any, for keyPath: String) {
        observers[keyPath] = observer
    }
}
noti.add("?", for: "for? 뭘 넣으라는거지") // bad, for만으로는 뭘 입력하라는 것인지 알 수가 없다. key값이 String 타입이기 때문에. 
```

### Strive for Fluent Usage(능숙한 사용을 위해 노력하세요)

**1. 메소드 및 함수이름을 영어 문법에 맞는 형태로 사용하는 것을 선호하세요.**
메소드 및 함수를 사용했을 때, 영어 문장처럼 사용되면 좋은 네이밍입니다. 
> ⭕️ **_Good_**   
```swift
x.insert(y, at: z)          “x, insert y at z”
x.subViews(havingColor: y)  “x's subviews having color y”
x.capitalizingNouns()       “x, capitalizing nouns”
```
> ❌ **_Bad_**   
```swift
x.insert(y, position: z) //영어 문장으로 잘 풀어지지 않는다. 
x.subViews(color: y) //상동
x.nounCapitalize() //상동
```
> ✅ **_Exception_**   
```swift
// Exception, 첫번째 또는 두번째 argument 이후에 주요 argument가 아닌 경우에는 유창함이 좀 떨어지는 것이 허용됩니다. 
// 예를들면, print의 separator, terminator처럼 옵션 같은 느낌의 default value가 있는 것들.
AudioUnit.instantiate(
  with: description, 
  options: [.inProcess], completionHandler: stopProgressBar)
```

**2. factory method의 시작은 "make"로 시작합니다.**
```swift 
//팀마다 create로 하는 경우도 있지만, Swift는 make를 추천합니다. 
[1,2,3].makeIterator()
````

**3. initalizer 및 factory method 호출에 대한 첫 번째 Argument는 영어 구절을 구성하지 마세요.**

> ⭕️ **_Good_**   
```swift
//1번에서 영어 문법에 맞는 형태로 네이밍을 하라고 했지만, 이니셜라이져와 팩토리 메소드 호출에 관해서는 예외입니다. 
//Color는 rgb를 이용해서 컬러값을 만드는 생성자로 아래의 havingRGBValuesRed처럼 구성하면 오히려 이해하기가 어렵다.
//또 팩토리 메소드인 makeWidget도 마찬가지이다. gears, spindles이 오히려 더 직관적이라 읽고 이해하기가 쉽다. 
let foreground = Color(red: 32, green: 64, blue: 128)
let newPart = factory.makeWidget(gears: 42, spindles: 14)
let ref = Link(target: destination)
```
> ❌ **_Bad_**   
```swift
let foreground = Color(havingRGBValuesRed: 32, green: 64, andBlue: 128)
let newPart = factory.makeWidget(havingGearCount: 42, andSpindleCount: 14)
let ref = Link(to: destination)
```

**4. side-effect를 고려해서 function과 method의 네이밍을 하세요.**
side-effect가 없는 것은 명사로, 있는 것은 동사로 읽혀야 합니다. 
mutating / nonmutating method 의 네이밍을 일관성있게 작성해야 합니다. 
operation이 동사로 설명되는 경우 mutation에는 동사의 명령형을, nonmutating에는 "ed", "ing"를 접미사로 붙여서 사용합니다. 

> x 내부의 값을 변경시킨다 -> `mutating` 
x 내부의 값을 변경시키지 않고 새로운 결과값을 반환한다 -> `nonmutating` 

|Mutating|NonMutating|
|:---:|:---:|
|x.sort()|z = x.sorted()|
|x.append(y)|z = x.appending(y)|

> ⭕️ **_Good_**   
```swift
var unsortedArray: [Int] = [5, 1, 3, 4]
// 원본 unsortedArray 값이 바뀌지 않고 새로운 값을 반환한다. -> side-effect가 있다.
unsortedArray.sorted()
unsortedArray
// 원본 unsortedArray 값이 변경된다. -> side-effect가 있다.
unsortedArray.sort()
unsortedArray
// 즉, 접미사 "ed", "ing" 만으로 mutating/nonmutating 을 의미하는지 추측할 수 있습니다.
// 접미사가 "ed"인데 mutating 메소드를 구현하면 안되겠죠? API의 일관성을 유지해주어야 합니다.
// e.g
3.distance(to: 3) // return Int, 리턴 값이 있으므로 nonmutating, 명사형 단어 distance
unsortedArray.append(3) // return Void, 리턴 값이 없으므로 mutating, 동사형 단어 append
unsortedArray.appending(100) // 지원되지 않는 함수지만 구현한다면 명사형으로 리턴값이 있게 구현해야 할 것.
//print 함수 또한 출력하면 콘솔에 내용이 출력되므로 side-effect가 있다고 판단합니다.
//그래서 동사형 단어 print가 사용되었습니다.
print("hello")
```

**5. nunmutating인 Bool타입 메소드&속성은 receiver에 대한 주장으로 읽혀야 합니다.**
> ⭕️ **_Good_**   
```swift
// 일단 얘네들은 x, line1을 변경하지 않는 nonmutating의 bool 타입 속성, 메소드이다. 
// 그렇다면, 얘네들은 receiver(여기서는 x와 line1)에 대한 주장과 같은 느낌으로 읽히면 된다. 
x.isEmpty //x는 비어있는가?
line1.intersects(line2) //line1은 line2에 교차하는가? 
```

**6. 능력을 설명하는 프로토콜은 -able, -ible, -ing 를 사용한 접미사로 네이밍 되어야 합니다.**
> ⭕️ **_Good_**   
```swift
Hashable 해시로 생성할 수 있는 유형을 정의하는 프로토콜 
Equatable "=="과 같은 연산자를 쓸 수 있게하는 프로토콜
CaseIterable enum을 배열처럼 순회할 수 있게 하는 프로토콜.
RawRepresentable struct에서도 rawValue 사용가능
ProgressReporting // 없는거 
DBAccessable // 없는거
...
```

**7. 나머지 types, properties, variables, constants는 명사로 읽혀야 합니다.**
1~6 번에 포함되지 않는 애들은 명사로 읽혀야 합니다. 

### Use Terminology Well(전문용어를 잘 사용하세요)

        
_**Term of Art** : 명사, 특정 분야 또는 직업 내에서 정확하고 전문화된 의미를 갖는 단어 또는 구._

_만약 더 일반적인 단어인 "피부skin"가 의미를 더 잘 전달한다면. "표피epidermis"를 사용하지 마세요._

_전문용어를 사용한다면 명확히 확립된 의미를 사용하세요._
- _일반적인 단어보다 전문 용어를 사용하는 유일한 이유는 모호하거나 불분명한 것을 정확하게 표현하기 때문입니다._
- _**전문가를 놀라게 하지 마세요 :** 우리가 전문 용어에 새로운 의미를 부여하면 그 용어에 익숙한 전문가들은 놀랄 수 있습니다._
- _**초보자를 혼란스럽게 하지 마세요 :** 그 전문 용어를 배우려는 사람은 아마 웹서치를 할 것입니다. 그 전문 용어를 웹서치했을 때 전통적인 의미와 사용된 전문 용어의 의미가 다르다면 초보자는 혼란스러울 수 있습니다._

_**약어(줄임말, abbreviations)을 피하세요.** 정형화 되어 있지 않은 약어를 이해하려면, 다시 풀어서 해석해야하기 때문에 전문 용어(terms of art, 아는 사람만 아는 것)라고 볼 수 있다._

> _사용하는 약어에 의도된 의미는 웹 사이트에서 쉽게 찾을 수 있습니다._

_- **관례를 받아들이세요.** 초보자를 위해 기존 문화와 다른 언어를 사용하면서까지 배려하지 마세요._ 
> _연속된 데이터 구조를 표현할 때, 비록 초심자가 List 를 쉽게 이해한다고 해도 List보다 Array로 용어를 사용하는게 낫습니다. Array는 현대 컴퓨팅의 기초기 때문에 모든 프로그래머들이 알고 있거나 곧 알게될 것입니다. 대부분의 프로그래머가 친숙한 용어를 사용하세요. 그러면 그들이 웹 검색이나 질문을 할 때 답변을 찾을 수 있을 것 입니다._

> _수학같은 특정 프로그래밍 도메인에서, `sin(x)` 같이 광범위하게 사용되는 용어는 그대로 사용하는 것이 `verticalPositionOnUnitCircleAtOriginOfEndOfRadiusWithAngle(x)` 같은 네이밍보다 낫습니다. 이 경우 약어를 피하는 것 보다 관례를 따르는 것에 더 가중치가 있다는 것에 주목하세요. 비록 온전한 단어는 sine이지만 `sin(x)`는 프로그래머들에게 수십년간, 수학자들에게는 수세기 동안 보편적으로 사용되어 왔습니다._
        
## Conventions(관례)
### General Conventions(일반적인 관례)

**1. 연산 프로퍼티의 복잡도가 O(1)이 아니라면 복잡도를 주석으로 남겨주세요.**
> ⭕️ **_Good_**   
```swift
class Company {
    // 보통 어떤 프로퍼티에 접근할 때, 큰 계산이 있을거라고 생각하지 않습니다.
    // 따라서 복잡도가 O(1)이 아니라면 아래와 같이 주석을 남겨주세요.
    //
    // Time Complexity: O(n^2)
    var numberOfEmployees: Int {
        var result: Int = 10
        (0...result).forEach {
            (0...result).forEach {
                (0...result).forEach {
                    result += 1
                }
            }
        }
        return result
    }
}
```

**2. global function 대신에 method와 property를 사용하세요. **
> ⭕️ **_Good_**   
```swift 
// global function은 특별한 경우에만 사용됩니다.
min(1, 3) //1. 명확한 self가 없는 경우
max(4, 5)
print("hello") //2. 함수가 Generic으로 제약 조건이 걸려있지 않는 경우
sin(3.0) //3. 함수 구문이 해당 도메인의 표기법인 경우 
```

**3. UpperCamelCase, lowerCamelCase를 따르세요.**

_**type, protocol**의 이름은 **UpperCamelCase**, 나머지는 **lowerCamelCase**를 따릅니다._

> ✅ **_Exception_**   
```swift 
// 미국 영어에서 보통 all upper case로 사용되는 Acronyms and initialisms(단어의 첫글자들로 말을 형성하는 것)은 
// 대소문자 컨벤션에 따라 통일성있게 사용되어야 합니다.
// UTF8, URL, HTTP 와 같이 all upper case로 사용되는 단어들이 있습니다.
// 다만, 제일 첫번째 단어로 나오면 소문자로시작. 그러나 두번째 단어로 나오면 all upper case로 사용한다.
var utf8Bytes: [UTF8] = []
var wewbsiteURL: URL?
var urlString: String?
```

**4. 기본 뜻이 같거나 구별되는 서로 구별되는 도메인에서 작동하는 method는 base name을 동일하게 사용할 수 있습니다.**

> ⭕️ **_Good_**   
```swift
// good
// 입력되는 파라미터는 다르지만 포함되어있다는 그런 결과를 도출하는 것은 똑같기 때문에 이런 경우에는 이름을 똑같이 해도 된다.
extension Shape {
  /// Returns `true` iff `other` is within the area of `self`.
  func contains(_ other: Point) -> Bool { true }
  /// Returns `true` iff `other` is entirely within the area of `self`.
  func contains(_ other: Shape) -> Bool { true }
  /// Returns `true` iff `other` is within the area of `self`.
  func contains(_ other: LineSegment) -> Bool { true }
}
```
> ⭕️ **_Good_**   
```swift
// good
// 이것도 마찬가지다. 위에녀석과 구별되는 도메인이기때문에 같은 이름을 써도 된다.
extension Collection where Element : Equatable {
  /// Returns `true` iff `self` contains an element equal to
  /// `sought`.
  func contains(_ sought: Element) -> Bool { return true }
}
```

> ❌ **_Bad_**   
```swift
// bad
// 엄연히 동작이 다른데 이름이 같아서 안된다.
// 위에는 데이터베이스의 검색 인덱스 다시 작성
// 아래는 주어진 테이블에서 n 번째 row 반환
struct Database {}
extension Database {
  /// Rebuilds the database's search index
  func index() {  }
  /// Returns the `n`th row in the given table.
  func index(_ n: Int, inTable: String) -> Int { 0 }
}
```
> ❌ **_Bad_**   
```swift
// bad
// 메소드 이름은 value로 같은데 리턴타입이 다르다. 좋지 않다.
// 타입캐스팅을 해서 사용해야 되니 불편하기도 하고 타입추론을 해줘도 되지만, 너무 모호하다. 
struct Box {
    private let rawValue: Int
    init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
    func value() -> Int? {
        rawValue
    }
    func value() -> String? {
        "\(rawValue)"
    }
}
let myBox = Box(100)
myBox.value() as Int?
myBox.value() as String?
let intBoxValue: Int? = myBox.value()
```

### Parameters(매개변수)


**1. 주석을 읽기 쉽게 만들어주는 매개변수 이름을 선택하세요.**
> ⭕️ **_Good_**   
```swift
// good
// 파라미터(함수내에서 사용되는 애)는 사용할 땐 보이지않지만(사용할 때 보이는건 아규먼트) 펑션이나 메소드를 설명해주는 역할을 한다.
// 잘 보면, 주석의 파라미터와 실제 파라미터가 같다.
// 또, 문법적으로 읽기도 쉽다. Array, predicate, self 처럼.
// 근데 Bad 예제를 보면 "includedInResult" 라고 읽기 문법적으로 어렵게 되어있기도 하고, 
// 또 심지어 r과 같이 되어있는 경우도 있다. 이건 좋지않다. 
//
/// Return an `Array` containing the elements of `self`
/// that satisfy `predicate`.
func filter(_ predicate: (Int) -> Bool) -> [Int] { [] }
/// Replace the given `subRange` of elements with `newElements`.
mutating func replaceRange(_ subRange: NSRange, with newElements: [Int]) { }
```
> ❌ **_Bad_**   
```swift
/// Return an `Array` containing the elements of `self`
/// that satisfy `includedInResult`.
func filter(_ includedInResult: (Int) -> Bool) -> [Int] { [] }
/// Replace the range of elements indicated by `r` with
/// the contents of `with`.
mutating func replaceRange(_ r: NSRange, with: [Int]) { }
```

**2. 일반적인 사용을 단순화 할 때, defaulted parameter를 사용하세요.**
> ⭕️ **_Good_**   
```swift
// good
// swift는 defaulted parameter 기능을 지원하기 때문에, 상대적으로 잘 사용되지 않는 매개변수에 
// 기본값이 있다면 간결하게 사용할 수 있다.
lastName.compare(royalFamilyName)
```
> ❌ **_Bad_**   
```swift
// bad, 길다.
lastName.compare(royalFamilyName, options: [], range: nil, locale: nil)
```

**3. defaulted parameters는 매개변수 리스트의 끝부분에 두는 것이 좋습니다.**
> ⭕️ **_Good_**   
```swift
// good 
// 필수파라미터 other가 앞에, 나머지 defaulted parameters들은 뒤에 있는 경우 
// 필요에 따라서 defaulted parameters들에 값을 주더라도 호출이 일괄된 패턴을 보인다. 
public func compare(_ other: String, options: CompareOptions = [], range: Range? = nil, locale: Locale? = nil) { }
compare("A")
compare("B", locale: nil)
compare("B", options: [], locale: nil)
compare("B", options: [], range: nil, locale: nil)
```
> ❌ **_Bad_**   
```swift
// bad
// 호출이 일관되지 않아 상대적으로 읽고 이해하기 힘들다. 
public func compare(options: CompareOptions = [], range: Range? = nil, locale: Locale? = nil,_ other: String, ) { }
compare("A")
compare(locale: nil, "B")
compare(options: [], locale: nil, "B")
compare(options: [], range: nil, locale: nil, "B")
```


### Argument Labels(인자 레이블)

**1. Argument Label을 사용했음에도 유용하게 구분되지 않는다면, 모든 Argument Labels을 생략하세요.**
> ⭕️ **_Good_**   
```swift
min(number1, number2)
zip(sequence1, sequence2)
```

**2. 값을 유지하면서 타입 변환을 해주는 initializer에서, 첫 번째 Argument Label을 생략하세요.**
- _첫번째 argument는 항상 **source of convesion(변환의 근원)**이어야 합니다._

> ⭕️ **_Good_**
```swift
// 이게 무슨말이냐면,
extension String {
  // Convert `x` into its textual representation in the given radix
  init(_ x: BigInt, radix: Int = 10)
    //← Note the initial underscore
}
// 이런거다. Int -> String 할건데 그거의 첫번쨰 파라미터는 항시 값이 바뀌는 그 근원인 Int여야된다. 그말이다.
text += String(veryLargeNumber) // veryLargeNumber -> Int
```

- _값의 범위가 좁혀지는 타입 변환의 경우, label을 붙여서 설명하는 것을 추천합니다._

> ⭕️ **_Good_**
```swift
extension UInt32 {
  init(_ value: Int16) // 이건 범위가 넓어지는 거니까 아규먼트 생략가능
  init(truncating source: UInt64) // 근데 이건 좁아지는거라 안돼.
}
// good
UInt32(Int16()) // 생략가능
UInt32(truncating: UInt64()) // 생략불가
```

**3. 첫 번째 Argument label은 일반적으로 전치사구로 시작합니다.**
> ⭕️ **_Good_**
```swift
x.removeBoxes(havingLength: 12)
```
> ✅ **_Exception_**   
```swift
// 아래 예시를 보면 x,y는 동일한 추상화 레벨에 있다.
a.move(toX: b, y: c)
// 마찬가지로 red, green, blue도 동일한 추상화 레벨에 있다.
a.fade(fromRed: b, green: c, blue: d)
// 
// 그렇다면, 예외적으로 이런 경우에는 함수이름에 전치사(to, from)를 포함시켜버리고
// 아규먼트 레이블을 동일한 형식으로 맞춰줍니다. 추상화 레벨을 동일하게 일치시켜 추상화를 명확히 해주는 겁니다.
a.moveTo(x: b, y: c)
a.fadeFrom(red: b, green: c, blue: d)
```

**4. 만약 첫번째 Argument가 문법적 구절을 만든다면 Argument label은 제거하고, 함수 이름에 base name을 추가합니다.**

> ⭕️ **_Good_**   
```swift
// 말이 좀 꼬여있는데 직역해보면 그런 뜻이다.
// 문법적으로 말이 된다면? 아규먼트를 제거하고 메소드 이름에 붙이고, 그렇지 않으면 아규먼트를 붙여라는 말이다.
// good
// x에 add를 할건데 subview를 할거야. 그럼 말이 된다. 그럼 그냥 메소드 이름으로 붙여버린다.
x.addSubview(y)
```
> ⭕️ **_Good_**   
```swift
// good
// view를 dismiss할거야. 더 이상 뭘 넣기가 어렵다. 이런 것은 Argument label을 그대로 둔다.
view.dismiss(animated: false) 
// 마찬가지로 words를 split할거야. 문법적으로 뭘 더 어떻게 해볼 수 없다. 그대로 둔다.
let text = words.split(maxSplits: 12) 
let studentsByName = students.sorted(isOrderedBefore: Student.namePrecedes)
```
> ❌ **_Bad_**   
```swift
// bad 
// 뷰를 dismiss하는데 animate를 false한다는 건지, 아니면 bool값을 dismiss한다는건지, 
// 아니면 Dismiss를 하지 말라는 (false니까) 건지 알 수가 없다. 
// 이런 경우엔 모호하므로 명확하게 animated라는 Argument label를 넣어주어야 한다.
view.dismiss(false)   
words.split(12) // 12를 스플릿하라는건지, 맥스스플릿이 12라는 건지, 12번째 위치로 스플릿하라는건지 뭔지 모른다. 이럴땐 아규먼트 레이블을 넣어야한다.
```
> ❌ **_Bad_**   
```swift
// bad 
// 마찬가지다. 
// 12를 스플릿하라는건지, 맥스스플릿이 12라는 건지, 12번째 위치로 스플릿하라는건지 뭔지 모른다. 
// 이럴땐 아규먼트 레이블을 넣어야한다.
words.split(12) 
```

**5. 그 외의 모든 경우에, Argument Label을 붙여야 합니다.**

> _**default value를 가진 argument는 생략**될 수 있으며, 이 경우 문법 구문의 일부를 형성하지 않으므로 **항상 레이블이 있어야 합니다.**_




## Special Instructions(특별 지침)

**1. tuple members와 closure parameters에 label을 지정하세요.**
> ⭕️ **_Good_**  
```swift
// 이게 튜플에서 좋은건 뭐냐면, 일단 이해하기쉽다.
// 또 주석에서 `reallocated` 과 같은식으로 설명하기도 좋다.
// 또 expressive access를 제공하는데 이건 이 뜻이다.
struct Storage {
    func doSomething() -> (reallocated: Bool, capacityChanged: Bool) {
        return (true, false)
    }
}
let storage = Storage()
let result = storage.doSomething()
// 이렇게 쓸 때. 파라미터를 안적었으면, 0,1로 써야된다.
result.0
result.1
// 근데 적어서 이게 된다.
result.reallocated
result.capacityChanged
// 근데 아쉽게도. 클로저는 지원을 안한다. 무슨말이냐면,
// 아래 클로저에 byteCount 라는 파라미터가 있는데
func ensureUniqueStorage(minimumCapacity requestedCapacity: Int, allocate: (_ byteCount: Int) -> Int) 
-> (reallocated: Bool, capacityChanged: Bool) {
return (true, true)
}
// 여기서 사용할땐 그게 자동으로 나오지 않는다는 말이다.
// 파라미터로 클로저에서 allocate: (_ byteCount: Int) -> Int 와 같이 byteCount라는 것을 
// 네이밍 해주고 있는데, 밑에 allocate: { num in num + 1 } 부분에 byteCount가 제공되지 않는다.
// 그래서 임의로 num 이라는 변수를 적어준거다. 튜플은 되지만 클로저는 지원하지 않는다. 
let bb = ensureUniqueStorage(minimumCapacity: 1, allocate: { num in num + 1 })
bb.capacityChanged
bb.reallocated
```

**2. overload set에서의 모호함을 피하기 위해, 제약 없는 다형성에 각별히 주의하세요.**
> ⭕️ **_Good_**   
```swift
struct Array {
    public mutating func append(_ newElement: Element)
    public mutating func append(contentsOf newElements: S) where S.Generator.Element == Element
}
// 위와 같은 overload set이 있다
// 문제는 Any, AnyObject, and unconstrained generic parameters 과 같은 타입에서 발생한다. 
var values: [Any] = [1, "a"]
values.append([2, 3, 4]) // [1, "a", [2, 3, 4]] or [1, "a", 2, 3, 4]?
// 위와 같은 상황에서 만약 Argument Label "contentsOf"가 생략되었다면, 모호하다. 
// [Any]이기 때문에 1도 [1, "a"]도 다 똑같이 받아들이기 때문이다.
// 따라서 이런 상황을 피하기 위해 명시적으로 이런 경우라면 꼭 주의해야 한다. 
```





