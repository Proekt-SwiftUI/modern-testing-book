# Баг 🐞

**Баг** — тип данных предоставляющий отчёт об баге.

Тесты позволяют разработчикам доказать, что написанный ими код работает так, как и ожидается. Если код работает неправильно, то используются системы учёта ошибок (баг-трекеры). Устоявшейся практикой считается *прикрепить* ошибку к конкретному тесту, чтобы проверить и/или уточнить статус — баг исправлен или нет.

>[!NOTE]
> Стоит различать баги от ошибок (Issue). Дополнить здесь мысль

https://developer.apple.com/documentation/testing/associatingbugs

### Использование

Для указания на конкретный баг, используй трейт `.bug(...)` в атрибуте @Test:

```swift
@Test(.bug("https://example.com/bug/125"))
func 
```

В самом простом варианте, ты передаешь ссылку на баг-трекинг. Помимо этого, трейт `.bug(...)` может принимать айди бага помимо ссылки:

```swift

```

Например, Apple используют внутреннюю систему баг-трекинга, называемой **Radar**:

```swift
@Test(.bug("rdar://"))
```

Вместо отдельных URL ссылок на баг-трекинг систему, лучшей идей будет использовать централизорованную систему. Посмотри на пример:

```swift
enum ProfileBugs {
    case createNewOne
    case updateWithInvalidData
    case deleteConfirmation
    case pictureUploadFileSize
    case updateTimeout
    // ...

    var url: String {
        switch self {
            case .createNewOne: "https://"
            case .updateWithInvalidData: "https://"
            // ...
        }
    }
}
```

```swift
@Test(.bug(ProfileBugs.createNewOne.url))
func createNewProfile() async {
    // ...
}
```

### Interpreting bug identifiers

https://developer.apple.com/documentation/testing/bugidentifiers

Библиотека тестирования предоставляет 2 способа идентификации бага:

1. Ссылка (URL) предоставляющая больше информации о баге
2. Уникальный идентификатор связанный с баг-трекинг системами


> _const

Значения, известные на этапе компиляции (compile-time constant values), — это значения, которые могут быть известны или вычислены во время компиляции и гарантированно не изменяются после её завершения. Использование таких значений может служить различным целям: от обеспечения правил и гарантий безопасности до предоставления пользователям возможности создавать сложные алгоритмы, выполняемые на этапе компиляции.

https://github.com/swiftlang/swift-evolution/blob/main/proposals/0359-build-time-constant-values.md
