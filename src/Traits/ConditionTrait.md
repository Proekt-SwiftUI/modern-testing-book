# Условие

**ConditionTrait** — тип данных отвечающий за условие, при котором тест будет или не будет выполнен.

Перед тобой может возникнуть ситуация, когда тест должнен выполниться при определенных условиях.
Например, тест должен выполняться только на определенной версии ОС или на определенной локали устройства.
С помощью этого типа данных ты можешь пропустить выполнение теста, если имеются такие условия.


> [!NOTE]
> Используется в обоих атрибутах @Suite и @Test

### Выполнить при условии

Частым сценарием использование служит определенное условие:

```swift
@Test(.enabled(if: WeatherService.shared.userGrantPermission))
func weatherPermission() {
    // ...
}
```

В этом случае тест будет выполнен, если пользователь дал разрешение на текущую геопозицию.
Иначе, тест будет пропущен.

Ты можешь применять трейт `.enabled(if:)` в конкретных условиях для всего типа данных:

```swift
let count = 5

@Suite(.enabled(if: count >= 1))
struct WeatherGroup {
    @Test(.enabled(if: count == 3))
    func nextSevenDays() async throws {
        // ...
    }

    @Test
    func today() async throws {
        // ...
    }

    @Test(.enabled(if: count > 10))
    func findSunnyDays() async throws {
        // ...
    }
}
```

Трейт применяется ко всем методам структуры, даже там, где это явно не указано.
В этом случае тест `nextSevenDays()` и `findSunnyDays()` будут пропущены, поскольку
не соответствуют условию.

> ❌ Test nextSevenDays() skipped.<br>❌ Test findSunnyDays() skipped.

### Пропустить выполнение

Если ты хочешь пропустить выполнение теста без каких-либо условий, используй трейт `.disabled()`:

```swift
@Test(.disabled("Отключили из-за проблем с производительностью"))
func asyncSequencePhotos() async {
    // ...
}
```

Более сложным примером случит пропуск теста с определенными условиями:

```swift
func shuttleReachedAtmosphere(layer: AtmosphereLayer) -> Bool {
    // ...
}

@Test(
  "Корабль преодолел уровень стратосферы?",
  .disabled(if: SpaceShuttle.shared.liftOff),
  .disabled(if: shuttleReachedAtmosphere(layer: .thermosphere))
)
func shuttleAboveStratosphere() throws {
    // ...
}
```

Ты можешь написать вспомогательную функцию для более сложного случая, как в примере выше.

### Комбинирование

Можешь использовать сразу несколько трейтов:

```swift
let isEnabledForSomeReason: Bool = true

@Test(
  .enabled(if: isEnabledForSomeReason),
  .disabled("Отключили до фикса бага #243"),
  .bug("243")
)
func showFastPath() throws {
    // ...
}
```



https://github.com/swiftlang/swift-testing/blob/main/Sources/Testing/Traits/ConditionTrait.swift
