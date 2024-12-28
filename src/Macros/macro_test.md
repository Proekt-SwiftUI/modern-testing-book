# @Test(…)

### Изоляция на глобальном акторе

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

### Нет необходимости возвращать тип данных

// Disallow functions with return types. We could conceivably support
// arbitrary return types in the future, but we do not have a use case for
// them at this time.
if let returnType = function.signature.returnClause?.type, !returnType.isVoid {
    diagnostics.append(.returnTypeNotSupported(returnType, on: function, whenUsing: testAttribute))
}

### Неподдерживаемые ключевые слова

На момент выхода книги в типе данных [TestDeclarationMacro][test_declaration], который реализует макрос `@Test` существуют неподдерживаемые ключевые слова:

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


### Test только ключевого слова func


Или иными словам, ты можешь применить атрибут только для функций или методов.

```swift
// The @Test attribute is only supported on function declarations.
guard let function = declaration.as(FunctionDeclSyntax.self) else {
    diagnostics.append(.attributeNotSupported(testAttribute, on: declaration))
    return false
}
```

### 1 атрибут для 1 функции

```swift
// Only one @Test attribute is supported.
let suiteAttributes = function.attributes(named: "Test")
if suiteAttributes.count > 1 {
    diagnostics.append(.multipleAttributesNotSupported(suiteAttributes, on: declaration))
}
```

### Не приминим для Generics

/// Create a diagnostic message stating that the `@Test` or `@Suite` attribute
/// cannot be applied to a generic declaration.

```swift
static func genericDeclarationNotSupported(_ decl: some SyntaxProtocol, whenUsing attribute: AttributeSyntax, becauseOf genericClause: some SyntaxProtocol, on genericDecl: some SyntaxProtocol) -> Self {
if Syntax(decl) != Syntax(genericDecl), genericDecl.isProtocol((any DeclGroupSyntax).self) {
    return .containingNodeUnsupported(genericDecl, genericBecauseOf: Syntax(genericClause), whenUsing: attribute, on: decl)
} else {
    // Avoid using a syntax node from a lexical context (it won't have source
    // location information.)
    let syntax = (genericClause.root != decl.root) ? Syntax(decl) : Syntax(genericClause)
    return Self(
    syntax: syntax,
    message: "Attribute \(_macroName(attribute)) cannot be applied to a generic \(_kindString(for: decl))",
    severity: .error
    )
}
}
```