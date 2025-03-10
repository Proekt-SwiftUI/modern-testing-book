# Расширяем стандартные возможности трейтов

Теперь, когда ты ознакомился со всеми трейтами, настало время для расширений (`extension`).
В каждой команде или проекте используется свой свод правил и эти правила применимы для трейтов. Например, вместо трейта `.disabled(...)` ты хочешь использовать похожий трейт, но со своими условиями и другим названием.

### Расширяем условие

```swift
extension Trait where Self == ConditionTrait {
	static func skipWhenEmptyProducts(_ comment: Comment? = nil) -> Self {
		.disabled(if: Products.catalog.isEmpty, comment)
	}

	static func skip(
		_ comment: Comment? = nil,
		condition: @escaping @Sendable () async throws -> Bool
	) -> Self {
		.disabled(comment) {
			try await condition()
		}
	}
}
```

### Локальный баг-трекер

Предположим, что ты работаешь в бигтехе и весь айти отдел использует проприетарный баг-трекер *YouTrack*. Одно из правил твоей команды использовать трейт `.youTrack(...)` в котором указывают ссылку на баг, ответственного за его исправление, а так же простой статус — исправлен или нет.

```swift
struct YouTrackPerson {
    let trackerLogin: String
    let telegram: URL
}

extension YouTrackPerson {
    static let rossik = Self(trackerLogin: "", telegram: .)
}

enum BugStatus {
    case open, case inProgress, case fixed
}

extension Trait where Self == Bug {
	static func youTrack(
		assigned: YouTrackPerson,
		status: BugStatus = .open,
		_ link: _const String,
		title: Comment? = nil
	) -> Self {
		.bug(link, title)
	}

	static func youTrack(
		assigned: YouTrackPerson,
		status: BugStatus = .open,
		link: _const String? = nil,
		id: some Numeric,
		title: Comment? = nil
	) -> Self {
		.bug(link, id: id, title)
	}
}
```

Использование:

```swift
@Test(.youTrack(assigned: .rossik, status: .fixed, "https://aboba"))
func logoutCleanUp() async throws {
    // ...
}
```

Пример выше не является полноценной заменой баг-трекерам, поскольку  *Xcode* не предоставляет возможность изменить `.xctestplan` и интерфейс соответветственно, но это может быть полезным для локального отслеживания.

### Последовательное выполнение при условии

```swift
extension Trait where Self == ParallelizationTrait {
    func serialized(if condition: @autoclosure () throws -> Bool) {
        if condition { .serialized }
    }
}
```

Более подробно про [последовательное выполнение тестов](Traits/ParallelizationTrait.md).
