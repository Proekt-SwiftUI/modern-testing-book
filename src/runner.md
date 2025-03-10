# Кто управляет тестами?

Возможно ты задавал себе вопрос: «Кто-то же запускает написанные мной тесты, но кто именно» ?
В этой главе я дам более точный ответ на заданный вопрос.

Глава про управление тестами разделена на 3 сценария:

1. [Введение в типы данных](#Введение-в-типы-данных)
2. [Запуск теста](#Запуск-теста)
3. [Завершение теста и выход](#Завершение-теста-и-выход)

### Введение в типы данных

**Runner** — тип данных отвечающий за выполнение тестов в соответствии с заданой конфигурацией и планом.
Основная задача — организовать и запустить массив тестов, управлять выполнением и обрабатывать результаты выполнения тестов.

Каждый запуск теста состоит из плана, массива тестов и конфигурации. Об этом ты прочитаешь ниже, но в начале рассмотрим все свойства и инициализаторы:

```swift
public struct Runner: Sendable {
  public var plan: Plan
  public var tests: [Test] { plan.steps.map(\.test) }
  public var configuration: Configuration


  // 1-ый инит
  public init(testing tests: [Test], configuration: Configuration = .init()) async {
    let plan = await Plan(tests: tests, configuration: configuration)
    self.init(plan: plan, configuration: configuration)
  }
  
  // 2-ой инит
  public init(plan: Plan, configuration: Configuration = .init()) {
    self.plan = plan
    self.configuration = configuration
  }

  // 3-ий инит
  public init(configuration: Configuration = .init()) async {
    let plan = await Plan(configuration: configuration)
    self.init(plan: plan, configuration: configuration)
  }
}
```

**Runner** представляет собой структуру данных c 3 свойствами:

1. Свойство `plan` отвечает за план действий при запуске тестов.
2. Свойство `tests` хранящее массив тестов, которые будут выполнены.
3. Свойство `configuration` отвечающее за настройку для подготовки и запуска тестов.

Помимо этого существует 3 инициализатора, каждый из которых не обходится без обязательной конфигурации и плана.<br/>Во всех случаях используется конфигурация по умолчанию: `Configuration = .init()`.

> [!IMPORTANT]
> Ты не можешь создавать собственный план или конфигурацию для передачи в Runner.

### План

**Plan** — тип данных описывающий план для `Runner`, а именно какие тесты будут запущены, в каком порядке и с каким действием (`Action`):

```swift
extension Runner {
  public struct Plan: Sendable {
    public enum Action: Sendable {
      public struct RunOptions: Sendable, Codable {
        // ...
      }
      // ...
    }
    // ...

    public struct Step: Sendable {
      public var test: Test
      public var action: Action
    }
  }
}
```

Структура `Plan` представляет собой:

1. `Step`: представляет собой шаг в ходе выполнения. Каждый шаг состоит из самого теста, который должен быть выполнен и действия, которое должно быть выполнено для этого теста.
2. `Graph`: создает иерархию шагов (Step)
3. Другие вспомогательные методы, например: метод отвечающий за рекурсивное применение действий (`Action`).


Тип данных `Plan` структурирует тесты в виде графа:

```swift
var stepGraph: Graph<String, Step?>

public var steps: [Step] {
    stepGraph
    .compactMap(\.value)
    .sorted { $0.test.sourceLocation < $1.test.sourceLocation }
}
```

И как я ранее сказал, в каждом плане есть действие, которое требуется сделать с тестом:

```swift
enum Action: Sendable {
    case run(options: RunOptions)
    indirect case skip(_ skipInfo: SkipInfo)
    indirect case recordIssue(_ issue: Issue)
}
```

- `Run`: тест будет выполнен.
- `Skip`: тест будет пропущен по причине `SkipInfo`.
- `RecordIssue`: запись проблемы по которой тест не был выполнен.

### Конфигурация

**Configuration** — отвечает за настройку и управление поведением тестов.
Данная структура отвечает за конкурентное или последовательное выполнение тестов, устанавливает ограничение по времени для выполнения тестов, отвечает за политику повторого повторения и другое:

```swift
public struct Configuration: Sendable {
  public init() {}

  public var isParallelizationEnabled: Bool = true
  public var repetitionPolicy: RepetitionPolicy = .once
  public var defaultSynchronousIsolationContext: (any Actor)? = nil
  public var maximumTestTimeLimit: Duration? { /* ... */ }
  public var exitTestHandler: ExitTest.Handler = { exitTest in
    // ...
  }
  // ...
```

Инициализатор пустой, т.е. не содержит свойств для начальной настройки.
Вручную у тебя нет возможности создать собственную конфигурация для тестов, как я написал ранее.

### Запуск теста

Наконец-то ты добрался до секции запуска.
Как ты знаешь, в любых язык программирования существует `EntryPoint`.
Запуск любой программы начинается с точки входа. Это касается и Swift Testing, поскольку
это тоже программа.

> Точка входа (EntryPoint) — адрес в оперативной памяти, с которого начинается
выполнение программы.

После того, как ты написал свой первый тест и запустил его, происходит следующее:


1. Создается конфигурация по умолчанию в методе `configurationForEntryPoint(from:)`
2. Запускается `Runner` с указанной конфигурацией
3. Значение `runner.tests` присвается константе `tests`
4. Происходит запуск тестов с помощью метода `await runner.run()`

```swift
public func configurationForEntryPoint(from args: __CommandLineArguments_v0) throws -> Configuration {
  var configuration = Configuration()
  configuration.isParallelizationEnabled = args.parallel ?? true
  // ...
}

func entryPoint(passing args: __CommandLineArguments_v0?, eventHandler: Event.Handler?) async -> CInt {
  // ...
  let tests: [Test]

  var configuration = try configurationForEntryPoint(from: args)
  let runner = await Runner(configuration: configuration)
  tests = runner.tests
  await runner.run()
}

public func __swiftPMEntryPoint(passing args: __CommandLineArguments_v0? = nil) async -> CInt {
  #if !SWT_NO_FILE_IO
  // Ensure that stdout is line- rather than block-buffered. Swift Package
  // Manager reroutes standard I/O through pipes, so we tend to end up with
  // block-buffered streams.
    FileHandle.stdout.withUnsafeCFILEHandle { stdout in
      _ = setvbuf(stdout, nil, _IOLBF, Int(BUFSIZ))
    }
  #endif

  return await entryPoint(passing: args, eventHandler: nil)
}

await Testing.__swiftPMEntryPoint() as Never
```

Конечно, на деле запуск тестов не такой простой, как я описал.
Помимо этого происходят различные проверки и глава о запуске превратится в главу о проверках перед запуском.
Именно поэтому я намеренно упростил объяснение запуска тестов с помощью `EntryPoint`.

> [!NOTE]
> Если есть желание ознакомится более подробно, ты всегда можешь прочитать исходный код Swift Testing.

С первым шагом справились и тесты запущены, но возникает следующий вопрос:
«Как завершить тест упехом или неудачей»?

### Завершение теста и выход

После того, как ты запустил тест, было бы славно его завершить. Для такого случая,
существует специальный тип данных.

**ExitTest** — тип данных отвечающий за завершение теста.

```swift
public typealias ExitTest = __ExitTest

public struct __ExitTest: Sendable, ~Copyable {
  // ...
  static func handlerForEntryPoint() -> Handler {
    // ...
  }
}
```

В методе конфигурация вызывает метод для выхода из тестов: `handlerForEntryPoint()`

```swift
configuration.exitTestHandler = ExitTest.handlerForEntryPoint()
```

Таким образом, **каждый из тестов завершается** каким-то результатом.
И сразу следует спросить, а какой из результатов завершения существует?

Для ответа на этот вопрос посмотри на перечисление `ExitCondition`:

```swift
public enum ExitCondition: Sendable {
  public static var success: Self {
    .exitCode(EXIT_SUCCESS)
  }

  case failure
  case exitCode(_ exitCode: CInt)
  case signal(_ signal: CInt)
}
```

В самых простых вариантах тест завершается успехом `.success` или неудачей `.failure`.
Существуют другие варианты выхода из теста один из которых выход с помощью кода выхода, а другой с помощью сигнала.

> Код выхода (возврата) — целое число, возвращаемое программой после ее завершения.

Статическое свойство `.success` завершает тест с помощью кода выхода `.exitCode(EXIT_SUCCESS)`.
В свою очередь `EXIT_SUCCESS` равен нулю:

```c
#define	EXIT_FAILURE	1
#define	EXIT_SUCCESS	0

#expect(EXIT_SUCCESS == .zero)
```
