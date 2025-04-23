# Конкурентный и последовательный запуск тестов

**Serialized** — тип данных позволяющий контролировать конкурентное или последовательное выполнение тестов.

### По умолчанию

Тесты выполняются *конкурентно* (concurrency) по умолчанию. Это возможно благодаря использованию метода `withTaskGroup(of:returning:body:)` из раздела `Structured concurrency`<a href="#concurrency"><sup>[1]</sup></a>.
Количество одновременно запущенных тестов управляется в `runtime`.

![Сохранили много времени](<../assets/Swift Testing Screenshots/saved_test_time.png>)

### Последовательное выполнение

Для последовательного выполнения теста с множеством аргументов используй трейт `.serialized`:

```swift
@Test(.serialized, arguments: Food.allCases)
func prepare(food: Food) {
    // ...
}
```

![Последовательный запуск](<../assets/Swift Testing Screenshots/serial_execution.png>)

>  Функция `prepare(food:)` будет выполнять последовательно каждый из аргументов.

Атрибут `@Suite` принимает такой же трейт:

```swift
@Suite(.serialized)
struct IsolationConfirmation {
  @Test(arguments: IsolatedData.allCases)
	func executeWith(data: IsolatedData) async throws {
		// Выполнение этой функции будет последовательным,
        // аргумент за аргументом.
	}

  @Test
  func uniqlyExecute() async throws {
    // Данная функция не будет запущена до тех пор,
    // пока executeWith(data:) выполняется. Прежде
    // чем начать выполнение необходимо дождаться
    // завершение предыдущей.
  }
}

extension IsolationConfirmation {
	@Suite
	struct NonIsolatedData {
		// Все функции в этом типе данных будут
        // выполняться последовательно
	}
}
```

В примере выше ты применил трейт `.serialized` и все функции с атрибутом `@Test`, включая вложенные типы данных, будут выполняться *последовательно*.


> [!IMPORTANT]
> Трейт `.serialized` применяется рекурсивно. При применении к атрибуту @Suite, любая функция с атрибутом @Test будет выполнятья последовательно, включая вложенные типы данных.

Применение трейта не влияет на выполнение других типов данных и тестов в других файлах. Эффект будет только на там, где указан `.serialized`.

Другим примером, когда применение трейта не имеет эффекта, послужит пример ниже:

```swift
@Test
func findPalindrome() {
	let word: String = "Madam"
	let result = word.filter(\.isLetter).lowercased().reversed()

	#expect(word.lowercased() == String(result))
}
```

Применение трейта к одиночной глобальной функции не имеет никакого эффекта.
Ты получишь предупреждение, если функция не имеет параметров, а атрибут `@Test` не имеет аргументов.

> ⚠️ Trait '.serialized' has no effect when used with a non-parameterized test function

Если ты передал флаг `--no-parallel` в команду `swift test`, то применение трейта не будет иметь эффекта, посколько ты глобально отключил конкурентное выполнение.

> [!NOTE]
> На момент выхода книги не существует *обратного* трейта, который выполняет тесты *конкурентно*.

---

<a name="concurrency"><sup>[1]</sup>Познакомится с новым подходом можно в моей книге [Structured Concurrency не магия](https://proekt-swiftui.github.io/sc-book/intro.html).</a>
