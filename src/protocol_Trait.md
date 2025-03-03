# protocol Trait

В переводе на русский, **trait — это Типаж**, но в книге я чаще употребляю простой вариант — **Трейт**.
Перед тем, как я расскажу для чего он нужен, попробуем переместиться в язык программирования Rust, который содержит ключевое слово `trait`. Trait необходим для объявления набора правил, которые будут реализованы. Данная концепция очень схожа с ключевым словом `protocol` в swift.

```swift
// Внутри новой системы тестирований находится основной трейт
// Он же swift-testing/Sources/Testing/Traits/Trait.swift
public protocol Trait : Sendable {...}
```

Данный протокол описывает, какие трейты могут быть добавлены к макросам @Test и @Suite. Помимо этого протокол `Trait` является корневым (главным).
Библиотека Swift Testing содержит готовые трейты, созданные инженерами Apple. Помимо этого, ты сам вправе добавить собственный трейт.
О создании собственных трейтов [сказано в этой главе](Traits/OwnTrait.md).

> [!NOTE]
> Трейт в новой системе тестирования — есть протокол, подписанный на основной протокол Trait.

### Встроенные трейты

Инженеры из Apple заранее подготовили определенное количество трейтов для использования.

![Трейты из коробки](assets/Swift%20Testing%20Screenshots/default_traits.png)

Далее в книге ты ознакомишься с каждым из них.

### Справка

Каждый макрос `@Test` принимает ноль и более трейтов. Это возможно благодаря:
- экзестенциальному `any`
- вариативному (variadic) параметру (3 точки) `...`

<details>
  <summary>Справка о any и вариативном параметре</summary>
  
   1. Ключевым словом [any обозначают][info_any] любой тип данных, реализующий протокол N.
    
  
  ```swift
  func showEachElement(for collection: any Collection) -> Void {
    collection.forEach {
        print($0)
    }
  }

  let data: String = "Swift Testing"
  let smallRange: ClosedRange = 0...5

  showEachElement(for: data)
  showEachElement(for: smallRange)
  ```

  2. [Вариативный параметр][info_variadic] — это параметр, который принимает 0 или множество значений конкретного типа данных.
  Обозначается с помощью 3 точек после типа данных:

  ```swift
    func quickMath(numbers: Int...) -> String {
        let sum = numbers.reduce(.zero, +)
        let cosValue = cos(Double(sum))
        let sinValue = sin(Double(sum))

        return """
    🎉 Добро пожаловать на сервер Тригонометрии! 🎉
    Сумма чисел: \(sum)
    Косинус числа: \(sum) = \(cosValue)
    Синус числа: \(sum) = \(sinValue)
    """
    }

    // Значения перечисляются через запятую
    quickMath(numbers: 30, 60, 90)
  ```
</details>


### Объявление макросов @Test и @Suite

Каждый макрос `@Test` принимает ноль и более трейтов `TestTrait`:

```swift
public protocol TestTrait: Testing.Trait {}
```

```swift
// Макрос @Test
@attached(peer)
public macro Test(_ traits: any Testing.TestTrait...) = #externalMacro(module: "TestingMacros", type: "TestDeclarationMacro")
```

Каждый макрос `@Suite` принимает ноль и более трейтов `SuiteTrait`:

```swift
public protocol SuiteTrait: Testing.Trait {
    var isRecursive: Bool { get }
}
```

```swift
// Макрос @Suite
@attached(member)
@attached(peer)
@_documentation(visibility: private)
public macro Suite(_ traits: any SuiteTrait...) = #externalMacro(module: "TestingMacros", type: "SuiteDeclarationMacro")
```

Если ты не знаком с ключевми словами из кода выше, такими как `@attached(member)` и другие, то рекомендую вернуться в главу [введения макросов](Macros/intro.md) и прочитать более подробно.


[info_any]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types/#Boxed-Protocol-Type
[info_variadic]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions/#Variadic-Parameters
