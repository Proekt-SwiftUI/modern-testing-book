# Лучшие практики

Данная глава содержит короткие куски кода, которые ты встречал в книге. Только практические примеры кода с кратким описанием.

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

> ❌ Expectation failed:<br>(currentTest.displayName → "Информация о тесте") == nil

### Аргументы вместо цикла for



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

> ✘ Test "Планета находится в солнечной системе?" recorded an issue at ManyArguments.<br>Expectation failed: isPlanetInSolarSystem(planet → .gargantua)<br>
Expectation failed: isPlanetInSolarSystem(planet → .pluto)<br>
Expectation failed: isPlanetInSolarSystem(planet → .endurance)<br>

```swift
@Test(
	"Планета находится в солнечной системе?",
	arguments: Planet.allCases
)
func matchPlanet(planet: Planet) {
	#expect(isPlanetInSolarSystem(planet))
}
```

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
​✘ Test "Планета находится в солнечной системе?"
```

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

// ✅ Используйте атрибут @available для функции или метода
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

> ❌ **Плохая практика**<br>
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

> ✅ **Хорошая практика**<br>
> Expectation failed:<br>(greenTea → BestTea(id: 32B06194-BCD9-4A4D-AEAA-9ACB3C037D95, name: "Green", optimalTime: 2, color: nil)).color → nil → nil

### withKnownIssue

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

Вызов функции `await confirmation(...)` нужно использовать в сценариях, когда некоторое событие происходит во время выполнения теста. `Confirmation` полезно, когда ожидаемое событие происходит:

- В контексте когда ты не можешь приостановить выполнение метода с помощью `await`, например: обработка события или вызов делегата
- В качестве длительного выполнения `callback`

При вызове `await confirmation(...)` ты передаешь замыкание соответсвующее типу `Confirmation`:

```swift

```

https://developer.apple.com/documentation/testing/testing-asynchronous-code
