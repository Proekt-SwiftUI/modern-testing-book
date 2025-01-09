# @Test(…)

Глава про макрос @Test разделена на 4 сценария:

- [Условие](#Условие-или-runtime-condition)
- [Общие характеристики или тэги](#Общие-характеристики-или-тэги)
- [Запуск с различными аргументами](#Аргументы)
- [Тонкости успользования](#Тонкости)

Здесь ты столкнешься с распространенными проблемами в тестировании и узнаешь как их решить.
Помимо этого, я расскажу о тонкостях работы макроса.

### Условие или runtime condition

Во-первых, тесты с условием.
Некоторые тесты должны выполняться только при определённых обстоятельствах — например, на конкретных устройствах или в определённом окружении (environments).

Для этого, ты можешь применить кортеж условия (`ConditionTrait`) `.enabled(if: ...)`:

```swift
@Test(.enabled(if: Backport.isRemoteVersion))
func backportVersion() async {
	// ...
}
```

Ты передаешь _некоторое_ условие, которое будет оцениваться перед запуском теста и если условие ложно, тест помечается как пропущенный и не выполняется.

> → Test 'backportVersion()' skipped

В других случаях необходимо полностью отключить выполнение теста (чтобы тест никогда не выполнялся). Для этого используй кортеж `.disabled(...)`:

```swift
@Test(.disabled("Известный баг, отключаем до фикса #PR-3781"))
func fetchFeatureFlag() async {
  // ...
}
```

> → Test 'fetchFeatureFlag()' skipped: Известный баг, отключаем до фикса #PR-3781

Использование кортежа `.disabled(...)` является предпочтительнее комментирования тела функции, поскольку в закомментированном состоянии — тело функции компилируется:
<!-- TODO: Добавить этот кейс в лучшие практики!!! -->
```swift
// Избегайте такого способа отключения теста
@Test("Закомментирую на время фикса #PR-3781")
func fetchAnotherFlag() {
// try await Task(priority: .background) {
//	...
// }
}
```

Тебе может показаться, что одного комментария недостаточно и по-хорошему нужно указать **причину** отключения: баг, ожидание PR (пулл реквеста) или иное условие. Что ж, в дополнение к комментарию ты можешь использовать кортеж `.bug(...)`, чтобы явно указать на проблему:

```swift
@Test(
	"Проверка валидности поля именя",
	.disabled("Бекендер исправляет модель"),
	.bug("https://github.com/issue/7329", "Сломанная валидация имени и модель #7329")
)
func validateNameProperty() async throws {
	// ...
}
```

Данный баг будет отображаться в отчете и вы сможете перейти по ссылке, которая ассоциируется с ним:

![Отчет в Xcode 16][validate_name_property_report]

Когда необходимо запустить тест только на конкретной версии ОС (операционной системы), можешь использовать [атрибут @available(...)][api_availability], чтобы указать на какой версии доступен тест.
Атрибут `@available(...)` позволяет понимать, что у теста есть условие, связанное с версией операционной системы и точнее отражать это в результатах.

```swift
@Test
@available(macOS 15, *)
func usesNewAPIs() {
  // ...
}
```

Избегайте использования проверки доступности с помощью макросов `#available` и `#unavailable`:

```swift
// ❌ Избегайте использования проверки доступности в рантайме с помощью #available и #unavailable
@Test
func hasRuntimeVersionCheck() {
  guard #available(macOS 15, *) else { return }
  // ...
}

<!-- TODO: Пример с unavailable -->

// ✅ Используйте атрибут @available для функции или метода
@Test
@available(macOS 15, *)
func usesNewAPIs() {
  // ...
}
```

<!-- Проверить для типа данных: @available struct NewAPI {...} -->

![Available attribute](../assets/available.png)

> @available(...) используется для обозначения доступности типа данных или функции, а #available используется когда необходимо выполнить часть кода только в определенной версии ОС.

### Общие характеристики или тэги

Давай обсудим, как ты можешь объединять тесты, которые имеют общие свойства, даже если они находятся в разных типах данных или файлах.
Swift Testing поддерживает создание пользовательских тэгов для тестов.

<!-- TODO: Дать определение что такое теги и в контексте тестирования -->

> [!NOTE]
> Тег (или тэг) — это ключевое слово для обозначения общих свойств в тестах.

В моём проект я уже использовал теги. Найти их можно в навигационном меню Xcode, а именно в Test Navigator снизу.

<!-- TODO: скриншот тегов -->

Чтобы увидеть тесты, к которым применены теги, ты можешь переключиться в новый режим группировки — по тегам.

<!-- TODO: скрин: группировка по тегам -->

Давайте применим тег к одному из тестов, которые мы писали ранее. Для этого мы добавим кортеж `.tags(...)` в атрибут @Test:

```swift
// пример кода 
```

Этот тест проверяет логику форматирования данных. В этом проекте уже есть другой тест, связанный с форматированием, 
поэтому давайте добавим тэг `formattingData` и к этому тесту.

После применения, тэг отобразится в Test Navigator под соответствующим тэгом.
Я написал еще один тест, который также проверяет форматирование данных, и добавлю его сюда.
Поскольку оба теста связаны с форматированием информации о видео, давайте сгруппируем их в поднабор.

Теперь мы можем переместить тег formattingData на уровень @Suite, чтобы тэг применялся ко всем тестам в этом @Suite. Далее можно удалить теги из каждого отдельного метода с атрибутом @Test, так как он (кто они?) наследуются.

Вы можете ассоциировать теги с тестами, которые имеют общие черты. Например, вы можете применить общий тег ко всем тестам, которые проверяют определенную функцию или подсистему. Это позволяет запускать все тесты с конкретным тегом, фильтровать их в Test Report и даже видеть аналитические данные, например, когда несколько тестов с одним и тем же тегом начинают падать.

Теги могут применяться к тестам в разных файлах, типам данных, макросу @Suite и даже использоваться в нескольких проектах.

При использовании Swift Testing предпочтительнее использовать теги вместо имен тестов для их включения или исключения из тестового плана. Чтобы добиться наилучших результатов, всегда выбирайте наиболее подходящий тип свойства для каждой ситуации. Не все сценарии должны использовать теги. Например, если вы хотите выразить условие выполнения во время выполнения, используйте .enabled(if ...), как мы обсуждали ранее.

<!-- TODO Скриншот: Recommended practies -->

В главе про @Test я не буду рассказывать о том как создать собсвенный тэг и в целом об этом кортеже, только совместное использование.
Узнать о макросе @Tag можно здесь.

### Аргументы

The last workflow I’d like to show is my favorite. Repeating tests with different arguments each time. 
Here's an example of why that can be useful.
In this project there are several tests which check the number of continents that various videos mention.
Each of them follows a similar pattern: it creates a fresh videoLibrary, looks up a video by name, and then uses the #expect macro to check how many continents it mentions.

### Тонкости

```swift
@Test("Как определить, функция для теста изолирована на глобальном акторе ?")
@MainActor
func determineGlobalActor() async {
	await MainActor.run {}
}
```

// How do we call a function if we don't know whether it's `async` or
// `throws`? Yes, we know if the keywords are on the function, but it could
// be actor-isolated or otherwise declared in a way that requires the use of
// `await` without us knowing. Abstract away the need to know by invoking
// the function along with an expression that always needs `try` and one
// that always needs `await`, then discard the results of those expressions.
//
// We may also need to call init() (although only for instance methods.)
// Since we can't see the actual init() declaration (and it may be
// synthesized), we can't know if it's noasync, so we assume it's not.
//
// If the function is noasync, we will need to call it from a synchronous
// context. Although `async` is out of the picture, we still don't know if
// `try` is needed, so we do the same tuple dance within the closure.
// Calling the closure requires `try`, hence why we have two `try` keywords.
//
// If the function is noasync *and* main-actor-isolated, we'll call through
// MainActor.run to invoke it. We do not have a general mechanism for
// detecting isolation to other global actors.

```swift
lazy var isMainActorIsolated = !functionDecl.attributes(named: "MainActor", inModuleNamed: "_Concurrency").isEmpty
var forwardCall: (ExprSyntax) -> ExprSyntax = {
  "try await Testing.__requiringTry(Testing.__requiringAwait(\($0)))"
}

let forwardInit = forwardCall

if functionDecl.noasyncAttribute != nil {
  if isMainActorIsolated {
    forwardCall = {
      "try await MainActor.run { try Testing.__requiringTry(\($0)) }"
    }
  } else {
    forwardCall = {
      "try { try Testing.__requiringTry(\($0)) }()"
    }
  }
}
```

#### Нет необходимости возвращать тип данных

Если ты внимательно читал код, то обратил внимание что ни одна функция не возвращает конкретный тип данных.
Указание возвращаемого типа данных не является ошибкой, проверка с помощью макросов выполняется, но в этом случае ты получишь предупреждение:

```swift
@Test
func checkReturnType() -> any Collection {
  let collection = Array(1...10)
  #expect(collection.contains(10))

  return collection
}
```

> ⚠️ The result of this function will be discarded during testing

Возможно в будущем, инженеры Apple добавят такую возможность, но на данный момент они не нашли подходящего сценария, когда необходимо возвращать тип данных.
Такая проверка возможна с помощью сравнения сигнатуры возвращаемого типа:

```swift
if let returnType = function.signature.returnClause?.type, !returnType.isVoid {
    diagnostics.append(.returnTypeNotSupported(returnType, on: function, whenUsing: testAttribute))
}
```

#### Неподдерживаемые ключевые слова

На момент выхода книги, в структуре данных [TestDeclarationMacro][test_declaration], которая реализует макрос `@Test`, существуют неподдерживаемые ключевые слова:

```swift
struct TestDeclarationMacro: PeerMacro, Sendable {
    // ...
    // We don't support inout, isolated, or _const parameters on test functions.
    for parameter in parameterList {
        let invalidSpecifierKeywords: [TokenKind] = [.keyword(.inout), .keyword(.isolated), .keyword(._const),]
        // ...
    }
}
```

Это легко проверить, создав тест с одним из этих ключевых слов:

```swift
@Test("Проверка не поддерживаемых слов")
func parameterCanBeSupported(value: isolated (any Actor)? = #isolation) {}
```

> ❌ Attribute `Test` cannot be applied to a function with a parameter marked `isolated`

[test_declaration]: https://github.com/swiftlang/swift-testing/blob/main/Sources/TestingMacros/TestDeclarationMacro.swift#L84


#### Test только для func


Или иными словам, ты можешь применить атрибут только для функций или методов.

```swift
// The @Test attribute is only supported on function declarations.
guard let function = declaration.as(FunctionDeclSyntax.self) else {
    diagnostics.append(.attributeNotSupported(testAttribute, on: declaration))
    return false
}
```

#### 1 атрибут для 1 функции

```swift
// Only one @Test attribute is supported.
let suiteAttributes = function.attributes(named: "Test")
if suiteAttributes.count > 1 {
    diagnostics.append(.multipleAttributesNotSupported(suiteAttributes, on: declaration))
}
```

#### Не приминим для Generics

/// Create a diagnostic message stating that the `@Test` or `@Suite` attribute
/// cannot be applied to a generic declaration.

```swift
static func genericDeclarationNotSupported(_ decl: some SyntaxProtocol, whenUsing attribute: AttributeSyntax, becauseOf genericClause: some SyntaxProtocol, on genericDecl: some SyntaxProtocol) -> Self {
  if Syntax(decl) != Syntax(genericDecl), genericDecl.isProtocol((any DeclGroupSyntax).self) {
      return .containingNodeUnsupported(genericDecl, genericBecauseOf: Syntax(genericClause), whenUsing: attribute, on: decl)
  } else {
      // Avoid using a syntax node from a lexical context (it won't have source location information.)
      let syntax = (genericClause.root != decl.root) ? Syntax(decl) : Syntax(genericClause)
      return Self(
      syntax: syntax,
      message: "Attribute \(_macroName(attribute)) cannot be applied to a generic \(_kindString(for: decl))",
      severity: .error
      )
  }
}
```

[validate_name_property_report]: ../assets/validateNameProperty_link.png
[api_availability]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow#Checking-API-Availability
