# Лучшие практики

Данная глава содержит примеры кода с коротким пояснением, которые ты встречал в книге.

### Информация о текущем тесте

Ты можешь получить доступ об информации к текущему тесту, только если он выполняется,
иначе `Test.current` всегда будет `nil`:

```swift
@Test("Информация о тесте")
func information() throws {
	let currentTest: Test = try #require(Test.current)
	let location = #_sourceLocation()

	#expect(currentTest.sourceLocation.fileName == location.fileName)
	#expect(currentTest.displayName == nil)
}
```

> ❌ Expectation failed:<br/>(currentTest.displayName → "Информация о тесте") == nil

### Аргументы вместо цикла for

Первое, что приходит в голову использовать цикл `for` (или функции высшего порядка: map, forEach и т.д.) при работе с перечислением:

```swift
enum Planet: CaseIterable {
	case mercury, venus, earth, gargantua, mars, jupiter, saturn, pluto, uranus, neptune, endurance
}

func isPlanetInSolarSystem(_ planet: Planet) -> Bool {
	switch planet {
		case .mercury, .venus, .earth, .mars, .jupiter, .saturn, .uranus, .neptune: true
		case .pluto, .gargantua, .endurance: false
	}
}

@Test("Планета находится в солнечной системе?")
func explorePlanets() {
	for planet in Planet.allCases {
		#expect(isPlanetInSolarSystem(planet))
	}
}
```

> Test "Планета находится в солнечной системе?" recorded an issue at ManyArguments.<br/>
❌ Expectation failed: isPlanetInSolarSystem(planet → .gargantua)<br/>
❌ Expectation failed: isPlanetInSolarSystem(planet → .pluto)<br/>
❌ Expectation failed: isPlanetInSolarSystem(planet → .endurance)<br/>

Более правильным вариантом будет использование аргументов в атрибуте `@Test` вместо цикла `for` :

```swift
@Test(
	"Планета находится в солнечной системе?",
	arguments: Planet.allCases
)
func matchPlanet(planet: Planet) {
	#expect(isPlanetInSolarSystem(planet))
}
```

![Аргументы теста](assets/test_arguments.png)

```bash
◇ Test "Планета находится в солнечной системе?" started.
◇ Passing 1 argument planet → .gargantua to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .mercury to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .venus to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .mars to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .earth to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .jupiter to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .saturn to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .pluto to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .neptune to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → .uranus to "Планета находится в солнечной системе?"
​​​​​​​​◇ Passing 1 argument planet → .endurance to "Планета находится в солнечной системе?"
✘ Test "Планета находится в солнечной системе?" recorded an issue with 1 argument planet → .gargantua at ManyArguments.swift:26:2: Expectation failed: isPlanetInSolarSystem(planet → .gargantua)
✘ Test "Планета находится в солнечной системе?" recorded an issue with 1 argument planet → .pluto at ManyArguments.swift:26:2: Expectation failed: isPlanetInSolarSystem(planet → .pluto)
​​✘ Test "Планета находится в солнечной системе?" recorded an issue with 1 argument planet → .endurance at ManyArguments.swift:26:2: Expectation failed: isPlanetInSolarSystem(planet → .endurance)
```

> ❌ Expectation failed: isPlanetInSolarSystem(planet → .gargantua)<br/>
❌ Expectation failed: isPlanetInSolarSystem(planet → .pluto)<br/>
❌ Expectation failed: isPlanetInSolarSystem(planet → .endurance)

И не забудь реализовать протокол `CustomTestStringConvertible` при работе с параметрами:

```swift
extension Planet: CustomTestStringConvertible {
	var testDescription: String {
		switch self {
			case .mercury: "Жаркое место"
			case .venus: "Экстримальное давление"
			case .earth: "Безопасная Земля"
			case .gargantua: "Черная Дыра"
			case .mars: "Красная планета"
			case .jupiter: "Газовый гигант"
			case .saturn: "Властелин колец"
			case .pluto: "Маленький, но гордый"
			case .uranus: "Ледяной гигант"
			case .neptune: "Синий гигант"
			case .endurance: "Корабль надежды"
		}
	}
}
```

Теперь вместо вывода кейса, ты увидишь описание, которые ты указал выше:

```bash
# ...
◇ Passing 1 argument planet → Экстримальное давление to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → Маленький, но гордый to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → Ледяной гигант to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → Синий гигант to "Планета находится в солнечной системе?"
◇ Passing 1 argument planet → Безопасная Земля to "Планета находится в солнечной системе?"
​​​​​◇ Passing 1 argument planet → Корабль надежды to "Планета находится в солнечной системе?"
​​​✘ Test "Планета находится в солнечной системе?" recorded an issue with 1 argument planet → Корабль надежды at ManyArguments.swift:83:2: Expectation failed: isPlanetInSolarSystem(planet → Корабль надежды)
✘ Test "Планета находится в солнечной системе?" recorded an issue with 1 argument planet → Черная Дыра at ManyArguments.swift:83:2: Expectation failed: isPlanetInSolarSystem(planet → Черная Дыра)
✘ Test "Планета находится в солнечной системе?" recorded an issue with 1 argument planet → Маленький, но гордый at ManyArguments.swift:83:2: Expectation failed: isPlanetInSolarSystem(planet → Маленький, но гордый)
```

В навигационном меню тестов ты тоже увидишь имена, заданные раннее:

![CustomTestStringConvertible](assets/with_CustomTestStringConvertible.png)

Помимо перечислений и массивов, аргемунт принимает `ClosedRange`:

```swift
@Test(
	"Исследование планеты за время",
	arguments: 90...110
)
func explorePlanets(duration: Int) async {
	let spaceStation = SpaceStation(studying: .gargantua)
	#expect(await spaceStation.explore(.gargantua, duration: duration))
}
```

> Для исследования Гаргантюа требуется минимум 100 дней

### Проверка доступности @available

Избегайте использования проверки доступности с помощью макросов `#available` и `#unavailable`:

```swift
// ❌ Избегайте использования проверки доступности в рантайме
//  с помощью #available и #unavailable
@Test
func hasRuntimeVersionCheck() {
  guard #available(macOS 15, *) else { return }
  // ...
}

@Test
func anotherExample() {
  if #unavailable(iOS 15) { }
}

// ✅ Используй атрибут @available для функции или метода
@Test
@available(macOS 15, *)
func usesNewAPIs() {
  // ...
}
```

### Проверка условия с помощью guard

Из-за оператора `return` в теле `guard` осуществился ранний выход из метода,
поэтому макрос `#expect` не сравнил цвет и результат теста оказался неверным.

```swift
@Test
func brewTea() {
	let greenTea = BestTea(name: "Green", optimalTime: 2, color: nil)
	guard let color = greenTea.color else {
		print("Color is nil!")
		return
	}
	#expect(color == .green)
}
```

> ❌ **Плохая практика**<br/>
> Макрос `#expect` не сравнил цвет, поведение теста неверное!

На замену `guard` используем макрос `#require`, для распаковки опционального значения.
В случае, если значение `color` равно `nil`, осуществляется ранний выход и
тест не проходит проверку, вернув ошибку.

```swift
@Test
func brewTeaCorrect() throws {
	let greenTea = BestTea(name: "Green", optimalTime: 2, color: nil)
	let color = try #require(greenTea.color)
	#expect(color == .green)
}
```

> ✅ **Хорошая практика**<br/>
> Expectation failed:<br/>(greenTea → BestTea(id: 32B06194-BCD9-4A4D-AEAA-9ACB3C037D95, name: "Green", optimalTime: 2, color: nil)).color → nil → nil

### Ожидаемая ошибка *withKnownIssue*

Если ты знаешь, что свойство или метод вызовут ошибку по какой-то причине,
то можешь использовать специальную функцию `withKnownIssue`, чтобы тест был пройден:

```swift
@Test
func matchAvailableCharger() {
	withKnownIssue("Порт зарядки сломан") {
		try Supercharger.shared.openChargingPort()
	}
}
```

> ❌ Test matchAvailableCharger() passed after 0.001 seconds with 1 known issue

### Confirmation

При написании тестов возникают ситуации, когда ты хочешь подтвердить выполнение кода, комплишн хендлера или когда ты хочешь проверить вызов делегата.

При вызове `await confirmation(...)` ты передаешь замыкание соответсвующее типу `Confirmation`:

```swift
@Test("Вызов метода расчета размера после загрузки")
func cleanupAfterDownload() async {
	let downloader = CoreMLDownloader()

	await confirmation() { confirmation in
		downloader.onCompleteDownload = { _ in confirmation() }
		_ = await downloader.size(for: CoreMLModel(.fastViT))
	}
}
```

Для подтверждения события, которое не будет выполнено, передай ноль:

```swift
await confirmation(expectedCount: 0) { confirmation in
	// ...
}
```

> [!NOTE]
> Используй `await confirmation()` когда хочешь вызвать `callback`.

А теперь к другой ситуации. Часть твоего кода была написана уважаем человеком,
любящим использовать коллбеки и теперь при переходе на **SC** ты должен оборачивать
каждый метод с помощью `continuation`:

```swift
@Test
func launchRocket() async throws {
    let rocket = await Rocket.prepareForLaunch()

    try await withCheckedThrowingContinuation { continuation in
        rocket.launch(with: .systemCheck) { result, error in
            if let result {
                continuation.resume(returning: result)
            } else if let error {
                continuation.resume(throwing: error)
            }
        }
    }
}
```

Swift Testing **автоматически оборачивает синхронный код с коллбеком**, поэтому нет необходимости использовать `withCheckedThrowingContinuation` в тестах.

> [!IMPORTANT]
> Не используй механизм синхронизации `CheckedContinuation` между синхронным и асинхронным кодом в тестировании!

### Отключай тест, а не комментируй

По привычке ты захочешь закомментировать тело теста, чтобы ничего не выполнялось:

```swift
@Test("Закомментирую на время фикса #PR-3781")
func fetchAnotherFlag() {
// try await Task(priority: .background) {
//	...
// }
}
```

Однако в библиотеке тестирования закоментированный код будет скомпилирован.
Поэтому лучшей практикой будет пропуск теста, вместо комментария тела:

```swift
@Test("Закомментирую на время фикса #PR-3781", .disabled())
func fetchAnotherFlag() {
	// ...
}
```

> [!NOTE]
> Вместо комментария тела функции используй трейт `.disabled()`