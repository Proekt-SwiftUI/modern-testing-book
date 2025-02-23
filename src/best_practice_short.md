# Лучшие практики

Данная глава содержит короткие куски кода, которые ты встречал в книге. Только практические примеры кода с кратким описанием.

### Аргументы вместо for loop

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
> ❌ Expectation failed:<br>(greenTea → BestTea(id: 32B06194-BCD9-4A4D-AEAA-9ACB3C037D95, name: "Green", optimalTime: 2, color: nil)).color → nil → nil

### withKnownIssue

Если ты знаешь, что свойство или метод вызовут ошибку по какой-то причине,
то можешь использовать специальную функцию `withKnownIssue`:

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

https://developer.apple.com/documentation/testing/testing-asynchronous-code
