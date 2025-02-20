# Конкурентный и последовательный запуск тестов

**Serialized** — тип данных позволяющий контролировать конкурентное или последовательное выполнение тестов.

### По умолчанию

Тесты выполняются *конкурентно* (concurrency) по умолчанию. Это возможно благодаря использованию метода `withTaskGroup(of:returning:body:)` из раздела `Structured concurrency`<a href="#concurrency"><sup>[1]</sup></a>.
Количество одновременно запущенных тестов управляется в `runtime`.

### Последовательное выполнение

Для последовательного выполнения теста с множеством аргументов используйте трейт `.serialized`:

```swift
@Test(.serialized, arguments: Food.allCases)
func prepare(food: Food) {
    // ...
}
```

>  Функция `prepare(food:)` будет выполнять последовательно каждый из аргументов.

Атрибут `@Suite` принимает такой же трейт:

```swift
@Suite(.serialized)
struct FoodTruckTests {
  @Test(arguments: Condiment.allCases)
  func refill(condiment: Condiment) {
    // This function will be invoked serially, once per condiment, because the
    // containing suite has the .serialized trait.
  }


  @Test
  func startEngine() async throws {
    // This function will not run while refill(condiment:) is running. One test
    // must end before the other will start.
  }
}
```

Когда этот атрибут добавляется к параметризованной тестовой функции, он заставляет тест выполнять свои кейсы последовательно, а не параллельно. При применении к непараметризованной тестовой функции этот атрибут не имеет эффекта. Когда он применяется к тестовому набору (suite), это приводит к тому, что набор выполняет свои тестовые функции и поднаборы последовательно, а не параллельно.

> [!IMPORTANT]
> Трейт `.serialized` применяется рекурсивно. При применении к атрибуту @Suite, любая функция с атрибутом @Test будет выполнятья последовательно, включая вложенные типы данных.

Этот атрибут не влияет на выполнение теста относительно его "соседей" или несвязанных тестов. Он не имеет эффекта, если параллелизация тестов глобально отключена (например, путем передачи флага --no-parallel в команду swift test).

Обрати внимание, что применение трейта к одиночной глобальной функции не имеет никакого эффекта.

```swift
@Test(.serialized)
func abobus() {
	#expect("dda" == String(unicodeScalarLiteral: "dd"))
}
```

Ты получишь предупреждение, если функция не имеет параметров, а атрибут @Test без аргументов.

> ⚠️ Trait '.serialized' has no effect when used with a non-parameterized test function


https://developer.apple.com/documentation/testing/parallelization

---

<a name="rfc"><sup>[1]</sup>Познакомится с новым подходом можно в моей книге [Structured Concurrency не магия](https://proekt-swiftui.github.io/sc-book/intro.html).</a>
 