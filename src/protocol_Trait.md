# protocol Trait

1671 Line:
`public protocol Trait : Sendable {}`

A protocol describing traits that can be added to a test function or to a test suite.

The testing library defines a number of traits that can be added to test functions and to test suites. Developers can define their own traits by creating types that conform to `TestTrait` and/or `SuiteTrait`.

When creating a custom trait type, the type should conform to ``TestTrait`` if it can be added to test functions, ``SuiteTrait`` if it can be added to test suites, and both ``TestTrait`` and ``SuiteTrait`` if it can be added to both test functions _and_ test suites.

В переводе на русский, trait — это Кортёж.
Перед тем, как я расскажу для чего он нужен, попробуем переместиться в язык программирования Rust, который содержит ключевое слово `trait`. Trait необходим для объявления набора правил, которые будут реализованы. Данная концепция очень схожа с ключевым словом `protocol` в swift.

Причина, по которой я рассказал о кортежах тривиальна — макросы `@Test` и `@Suite` принимают кортежи, которые представляют собой протокол:

TestTrait.Comment и перечислить их.

> [!NOTE]
> Кортёж в новой системе тестирования — это протокол

```swift
// Внутри новой системы тестирований находится основной кортеж
// Он же Testing.Trait
public protocol Trait : Sendable {}
```

### Реализация собственного кортежа

Каждый макрос `@Test` принимает 0 и более `TestTrait`. Это возможно благодаря экзестенциальному `any` и вариадичному параметру (3 точки) `...`

<!-- Убрать отсюда и перенести в Macros/Test ? -->

```swift
public protocol TestTrait : Testing.Trait {}


// Макрос @Test
@attached(peer)
public macro Test(_ traits: any Testing.TestTrait...) = #externalMacro(module: "TestingMacros", type: "TestDeclarationMacro")
```

Каждый макрос `@Suite` принимает 0 и более `SuiteTrait`:

```swift
public protocol SuiteTrait : Testing.Trait {
    var isRecursive: Bool { get }
}

// Макрос @SuiteTrait
@attached(member)
@attached(peer)
public macro Suite(_ traits: any Testing.SuiteTrait...) = #externalMacro(module: "TestingMacros", type: "SuiteDeclarationMacro")
```