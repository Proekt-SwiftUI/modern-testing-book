# TimeLimitTrait.swift

**TimeLimitTrait** — тип данных, ограничивающий время выполнения теста:

```swift
@available(_clockAPI, *)
public struct TimeLimitTrait: TestTrait, SuiteTrait  {… }

@available(_clockAPI, *)
extension Trait where Self == TimeLimitTrait {
    @_spi(Experimental)
    public static func timeLimit(_ timeLimit: Duration) -> Self {
        return Self(timeLimit: timeLimit)
    }
}
```

Тайм-ауты тестов не поддерживают высокую точность и слишком короткие промежутки из-за вариативности в тестовой среде. Ограничение времени должно быть не менее 1 минуты и может быть выражено только в целых минутах.

Для применения этого кортежа вызовите метод `timeLimit` в макросе `@Test` или `@Suite`:

```swift
@Suite("Кортеж TimeLimit", .timeLimit(.minutes(0)))
struct TimeLimitExample {
	@Test
	func takeYourTime() {
		#expect(60.0 == 60.0)
	}
	
	@Test(.timeLimit(.minutes(1)))
	func anotherDay() {
		#expect(0.3 == 0.3)
	}
}
```

> ❌ Time limit was exceeded: 0.000 seconds

Наследование времени просходит от родительского `@Suite`.
Если макрос `@Test` или `@Suit` принимают более 2 кортежей с ограничением времени, то за максимальное время выполнения будет взято наменьшее значение.
В примере с `TimeLimitExample` наименьшее время выполнения 0 минут, поэтому тест завершается неудачей.

Попробуйте запустить тест ниже:

```swift
@Test(
	"Максимальное время timeLimit",
	.timeLimit(.minutes(1)),
	.timeLimit(.minutes(5))
)
func maxTimeLimit() async throws {
	try await Task.sleep(for: .seconds(120))
	#expect(true)
}
```

> ❌ Time limit was exceeded: 60.000 seconds

Когда тест или suite не успевают выполнится в установленное время, вызывается ошибка из кортежа `Issue`. В таком случае тест завершается неудачей.

> Issue.Kind.timeLimitExceeded(timeLimitComponents:)
