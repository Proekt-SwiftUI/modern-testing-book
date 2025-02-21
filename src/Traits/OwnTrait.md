# Собственный трейт

/// The testing library defines a number of traits that can be added to test
/// functions and to test suites. Define your own traits by
/// creating types that conform to ``TestTrait`` or ``SuiteTrait``:
///
/// - term ``TestTrait``: Conform to this type in traits that you add to test
///   functions.
/// - term ``SuiteTrait``: Conform to this type in traits that you add to test
///   suites.
///

Ранее я упоминал, что ты не ограничен трейтами, которые предоставили инженеры Apple для тебя. Для реализации собственного трейта нужно понять сценарий использования:

1. Трейт будет использоваться только в атрибуте `@Test`
2. Трейт будет использоваться только в атрибуте `@Suite`
3. Трейт будет использоваться в обоих случаях: `@Test` и `@Suite`

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

Ты добавил несколько перечеслений и указал их в качестве констант в структуре `BacklogTrait`. Последнее, что остается сделать — сделать расширение для `Trait`
со статическим методом `backlog(...)`.


Использование:

```swift
@Test(
	"Беклог для 1.7.0",
	.backlog(app: .release(1.7), feature: .yes)
)
func backglogNewRelease() {}
```
