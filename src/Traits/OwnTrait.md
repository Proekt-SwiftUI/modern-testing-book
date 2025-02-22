# Собственный трейт

Ранее я упоминал, что ты не ограничен трейтами, которые предоставили инженеры Apple для тебя. Для реализации собственного трейта нужно понять сценарий использования:

1. Трейт будет использоваться [только в атрибуте `@Test`](#Трейт-для-атрибута-Test)
2. Трейт будет использоваться [только в атрибуте `@Suite`](#Трейт-для-атрибута-Suite)
3. Трейт будет использоваться [в обоих случаях: `@Test` и `@Suite`](#трейт-для-обоих-случаев)

Предлагаю пойти по порядку и рассмотреть каждый из возможных вариантов.

### Трейт для атрибута @Test

На каждом проект тебе помогают различные коллеги: дизайнеры, бэкендеры, андроид разработчики, тестировщики и менеджер проекта.
Представь, что **ПМ** (project manager) очень часто создает задачи в беклог, а ты как настоящий любитель решать интересные задачи, хочешь добиться синхронизации между беклогом и тестами.

Что ж, надеюсь задача понятна, но кратко повторю: хочу сделать трейт `.backlog` с какими-то параметрами.

Как упомяналось в книге, для реализации собственно трейта необходимо соответствовать протоколу `TestTrait` поскольку макрос `@Test` принимает `any TestTrait...`
В самом простом варианте необходимо реализовать структуру и сделать расширение к Trait:

```swift
import Testing

struct BacklogTrait: TestTrait {}

extension Trait where Self == BacklogTrait {
	static var backlog: Self { .init() }
}

// Применять как обычно
@Test(.backlog)
func onboardingUpdate() async throws {
	// ...
}
```

> Главное условие — удовлетрворить требование протокола `Sendable`.

Но твой **ПМ** парень не простой и указывает в бэклоге версию приложения и фича флаг.
Поэтому давай добавим необходимый функционал всего за несколько строк:

```swift
enum FeatureFlag {
	case yes
	case no
}

enum AppVersion {
	case release(any FloatingPoint)
	case stage
}

struct BacklogTrait: TestTrait {
	let app: AppVersion
	let feature: FeatureFlag?
}

extension Trait where Self == BacklogTrait {
	static func backlog(app: AppVersion, feature: FeatureFlag? = nil) -> Self {
		Self(app: app, feature: feature)
	}
}
```

Ты добавил несколько перечеслений и указал их в качестве констант в структуре `BacklogTrait`. Последнее, что остается сделать — изменить расширение для `Trait`
заменив свойство на статический метод `backlog(...)`.

Использование:

```swift
@Test(
	"Беклог для 1.7.0",
	.backlog(app: .release(1.7), feature: .yes)
)
func backglogNewRelease() {}
```

### Трейт для атрибута @Suite

Ты решил, что будет полезным применять атрибут `@Suite` для конкретного типа данных,
соответсвующим протоколу `@Observation`, чтобы коллеги видели тип данных и быстрее понимали о чем речь.

По аналогии с трейтом для тестов, ты создаешь тип данных соотвестующий `SuiteTrait`:

```swift
@testable
import class ModernApp.ProfileData

struct ForDataSuite: SuiteTrait {
	let observableType: Observable.Type
}

extension SuiteTrait where Self == ForDataSuite {
	static func forData(_ data: Observable.Type) -> Self {
		Self(observableType: data)
	}
}
```

Использование:

```swift
@Suite(.forData(ProfileData.self))
struct WholeProfile {
	// ...
}
```

### Трейт для обоих случаев

В Github существует возможность установить владельца кода (code owner) с помощью файла `CODEOWNERS` отвечающего за код в репозитории.

Предлагаю сделать `GithubOwnerTrait` для обоих случаев: `@Suite` и `@Test`.

```swift
struct GithubOwnerTrait: TestTrait, SuiteTrait {
	var name: String?
	var githubUserURL: URL
}

extension Trait where Self == GithubOwnerTrait {
	static func githubOwner(_ name: String? = nil, userURL: URL) -> Self {
		Self(name: name, githubUserURL: userURL)
	}
}

extension URL {
	init(link: String) {
		self.init(string: link)!
	}
}
```

Реализация не отличается от первых 2 случаев за тем исключением, что ты подписываешь тип данных на 2 протокола `TestTrait` и `SuiteTrait`.

Использование:

```swift
@Suite(.githubOwner(userURL: URL(link: "github.com/wmorgue")))
struct SpeedMetrics {
	@Test(.githubOwner(userURL: URL(link: "github.com/hborla")))
	func anotherThing() {
		let duration = Duration.seconds(120)
		#expect(duration == .seconds(60 * 2))
	}

	// ...
}
```
