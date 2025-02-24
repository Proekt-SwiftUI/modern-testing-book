# Скрытый макрос

Ты наверняка знаешь о *скрытом* функционале компилятора: свойства, методы, атрибуты и прочие выражения, доступ к которым можно получить с помощью <u>нижнего подчеркивания</u>:

```swift
var number: Int {
    @inline(__always) get {
        return number
    }
}

// или другой пример
func makeSomething(@_implicitSelfCapture fn: @escaping () -> Void) { 
    fn()
}

// или еще один
_canBeClass(MainActor.self)
```

Так вот, библиотека Swift Testing включает макрос, доступ к которому можно получить
таким же способом — через нижнее подчеркивание:

```swift
@Test
func matchFileSourceLocation() {
	let fileLine: Int = 33
	let locationOfThisTest = #_sourceLocation()
	#expect(fileLine == locationOfThisTest.line)
}
```

> ❌ Expectation failed: (fileLine → 33) == (locationOfThisTest.line → 39)

### Макрос `#_sourceLocation()`

Независимый макрос указывающий на местоположение в исходном коде.
Сценарии использования могут быть разными, например для улучшения читаемости сообщений об ошибках в тестах, указании на конкретный модуль или имя исходного файла.

Информация о модуле, имени файла и других свойствах собирается на этапе компиляции.

```swift
func getTestLocation(testName: String = #function) {
	let location = #_sourceLocation()
	print("Запущен тест \(testName) в файле \(location.fileName)\nМодуль: \(location.moduleName)")
}

@Test
func followTheWhiteRabbit() {
	getTestLocation()
	
	let movie = Movie(name: "The Matrix")
	#expect(movie.mainCharacter == "Keanu Beeves")
}
```

> ◇ Test followTheWhiteRabbit() started.<br><br>
Запущен тест followTheWhiteRabbit() в файле IssueExample.swift<br>
Модуль: ModernAppTests<br><br>
> ❌ Expectation failed: "Keanu Beeves" == "Keanu Reeves"

### Реализация

За реализацию макрос отвечает тип данных `SourceLocation`.
Ниже я перечислил все доступные свойства на момент выхода книги:

```swift
struct SourceLocation: Sendable {
	var fileID: String {...}
	var fileName: String {...}
	var moduleName: String {...}
	var line: Int {...}
	var column: Int {...}
}
```

- `fileID` уникальный идентификатор исходного файла.
- `fileName` имя исходного файла.
- `moduleName` имя модуля, в котором находится данный исходный файл.
- `line` строка по счету в исходном файле.
- `column` столбец по счету в исходном файле.

> [!NOTE]
> `SourceLocation` используется в реализации макроса @Test и других трейтах.

Если интересно, почему в имени макроса присутствует нижнее подчеркивание, то взгляни на объявление:

```swift
@freestanding(expression)
public macro _sourceLocation() -> SourceLocation = #externalMacro(module: "TestingMacros", type: "SourceLocationMacro")
```

Ранее ты изучил информацию о атрибуте `@freestanding(...)` и знаешь, что это обозначает. Если это не так, ничего страшного, просто вернись назад и [освежи знания](intro.md#Немного-о-макросах-и-ключевых-словах).

---

Доступ к макросу *развязывает пальцы* и ты можешь сделать интеграцию с каким-либо мессенджером.
Вместо вызова функции `print()` можно будет отправлять запросы в группу телеграма и видеть ход выполнения тестов.
Другой вопрос, насколько это целесообразно — решай сам.

<!-- https://developer.apple.com/documentation/testing/sourcelocation -->
