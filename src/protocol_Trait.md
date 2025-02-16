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
О создании собственных трейтов [сказано ниже](#Реализация-собственного-трейта).

> [!NOTE]
> Трейт в новой системе тестирования — есть протокол, подписанный на основной протокол Trait.

<!-- Вынести это все в Детальное знакомство c макросами ? -->
## Реализация собственного трейта

Каждый макрос `@Test` принимает ноль и более трейтов. Это возможно благодаря:
- экзестенциальному `any`
- вариативному (variadic) параметру (3 точки) `...`

<details>
  <summary>Справка о any и вариативном параметре</summary>
  
   1. Ключевым словом [any][info_any] обозначают любой тип данных, реализующий протокол N.
    
  
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

<!--
Убрать отсюда и перенести в Macros/Test или упомянуть в Macros/Test, что реализация доступна в главе про трейты ?

Думаю 2-ой вариант, в главах про Макрос показать сценарии использования и особенности, но ознакомить
с реализаций лучше в именно в этом файле.
-->

### Макросы @Test и @Suite более детально

Каждый макрос `@Test` принимает ноль и более трейтов `TestTrait`:

```swift
// A protocol describing traits that can be added to a test function.
public protocol TestTrait : Testing.Trait {}

// Макрос @Test
@attached(peer)
public macro Test(_ traits: any Testing.TestTrait...) = #externalMacro(module: "TestingMacros", type: "TestDeclarationMacro")
```

Каждый макрос `@Suite` принимает ноль и более трейтов `SuiteTrait`:

```swift
public protocol SuiteTrait : Testing.Trait {
    var isRecursive: Bool { get }
}
```

<!-- Перевод -->

```swift
/// Declare a test suite.
///
/// - Parameters:
///   - traits: Zero or more traits to apply to this test suite.
///
/// A test suite is a type that contains one or more test functions. Any
/// copyable type (that is, any type that is not marked `~Copyable`) may be a
/// test suite.
///
/// The use of the `@Suite` attribute is optional; types are recognized as test
/// suites even if they do not have the `@Suite` attribute applied to them.
///
/// When adding test functions to a type extension, do not use the `@Suite`
/// attribute. Only a type's primary declaration may have the `@Suite` attribute
/// applied to it.

@attached(member) @attached(peer)
@_documentation(visibility: private)
public macro Suite(_ traits: any SuiteTrait...) = #externalMacro(module: "TestingMacros", type: "SuiteDeclarationMacro")
```

Если ты не знаком с ключевми словами из кода выше, такими как `@attached(member)` и другие, то рекомендую вернуться в главу введения макросов и прочитать более подробно.


[info_any]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types/#Boxed-Protocol-Type
[info_variadic]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions/#Variadic-Parameters