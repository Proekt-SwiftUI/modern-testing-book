# XCTest или Swift Testing

Возможно ты писал тесты с помощью XCTest и задумался о переходе на более современный подход. Swift Testing имеет как общие черты с XCTest, так и различия.

Данная глава включает в себя:

1. [Сранение функций и методов](#Сравнение-функций)
2. [Сравнение XCT* с макросами](#Сравнение-xct-с-макросами)
3. [Сравнение поддерживаемых типов данных](#Сравнение-поддерживаемых-типов-данных)
4. [Рекомендации по миграции из XCTest и недостатки Swift Testing](#Миграция-из-xctest)


### Сравнение функций

| Критерий | XCTest | Swift Testing |
| --- | --- | --- |
| Объявление | Имя теста начинается со слова `test`| Указываем атрибут `@Test` |
| Поддерживаемые типы данных | Методы инстанса | Методы инстанса, методы помеченные как static, глобальные функции |
| Поддержка трейтов | Нет | Да |
| Конкурентное выполнение | macOS или симулятор | Да |


Тесты в XCTest — это любой метод начинающийся со слова `test`. Напротив, в Swift Testing ты указываешь атрибут `@Test`,
исключая неоднозначность в намерениях. Библиотека тестирования поддерживает больше вариантов функций: ты можешь использовать
не только методы, которые принадлежат этому типу данных, но и глобальные методы, а так же методы помеченные ключевым словом `static`.
В отличии от `XCTest`, Swift Testing подерживает трейты, чтобы указать информацию или добавить определенное поведение к типу данных или отдельным функциям.

В конце концов Swift Testing использует другой подход для конкурентного выполнения тестов:
под капотом используется Structured Concurrency и поддерживают физические устройства как iPhone или Apple Watch.

### Сравнение XCT* с макросами

Взгляни на таблицу сравнения:

![Картинка сравнения](assets/Swift%20Testing%20Screenshots/compare_xct_and_macros.png)

Сравнение результатов очень различаются в старом и новом подходах.

**XCTest** использует концепт различных проверок начинающихся с префикса `XCAssert*`.<br>
**Swift Testing** имеет другой подход — существует только 2 основных макроса `#expect` и `#require`.

![Картинка сравнения 2](assets/Swift%20Testing%20Screenshots/compare_xct_2.png)

Вместо объявления множества различных проверок достаточно использовать операции сравнения языка Swift в этих макросах. Например, используйте 2 знака равно `==`
для проверки равенства или оператор больше чем `>` для сравнения 2 значений.

![Картинка сравнения 3](assets/Swift%20Testing%20Screenshots/compare_xct_3.png)

Кроме этого, ты можешь использовать оператор `!` (восклицательный знак) для противоположной проверки.

### Сравнение поддерживаемых типов данных

| Критерий | XCTest | Swift Testing |
| ----- | :-------- | :--------------------- |
| Типы данных | class | struct<br>actor<br>class |
| Объявление | Подкласс XCTestCase | @Suite |
| Настройка перед выполнением каждого теста | setUp()<br>setUpWithError() throws<br>setUp() async throws| init() async throws |
| После каждого теста | tearDown()<br>tearDown() async throws<br>tearDownWithError() throws | deinit |
| Вложенные типы | Не поддерживаются | Поддерживаются |


Говоря о типах данных, следует напомнить что `XCTest` поддерживает только классы,
которые наследуются от `XCTestCase`. В Swift Testing ты можешь использовать стуктуры, акторы и классы.
Старайтесь использовать структуры по умолчанию, посколько они соответствуют `value` семантики и позволяют
избегать ошибок с общим состоянием.

К каждому типу данных неявно применяется атрибут `@Suite`. Если ты хочешь задать
отображаемое имя или использовать трейт, то в таком случае ты можешь применить атрибут `@Suite`.

Для выполнения логики перед каждым запуском в `XCTest` используется метод `setUp(..)`.
Аналогичным способом в Swift Testing используются инициализаторы данных, которые могут
быть помечены ключевым словом `async` и/или `throws`. Для добавления логики после
выполнения ты можешь использовать деинициализатор `deinit {...}`.

> `deinit` можно использовать в акторах и классах. `~Copyable` структуры не поддерживаются Swift Testing,
хоть и имеет возможность вызвать `deinit`.

```swift
struct C: ~Copyable {
  deinit {}

  @Test("Ownership for sheep")
  func sheepOwner() async throws {
	  #expect(UnicodeScalar(0x1F411) == "\u{1F411}")
  }
}
```

> ❌ Ошибка — _Noncopyable_ структуры не поддерживаются в Swift Testing.


Finally, in Swift Testing, you can group tests into subgroups via nested types.

### Миграция из XCTest

XCTest and Swift Testing tests can co-exist in a single target, so if you choose to migrate, you can do so incrementally and you don’t need to create a new target first. When migrating multiple XCTest methods which have a similar structure, you can consolidate them into one parameterized test as we discussed earlier. For any XCTest classes with only one test method, consider migrating them to a global @Test function. And when naming tests, the word “test” is no longer necessary at the beginning.

Please continue using XCTest for any tests which use UI automation APIs like XCUIApplication or use performance testing APIs like XCTMetric as these are not supported in Swift Testing. You must also use XCTest for any tests which can only be written in Objective-C. You can use Swift Testing to write tests in Swift that validate code written in another language, however. Finally, avoid calling XCTest assertion functions from Swift Testing tests, or the opposite — the #expect macro from XCTests.

XCUIApplication не поддерживается (перевести коммент):

https://github.com/swiftlang/swift-testing/issues/516#issuecomment-2201208834
