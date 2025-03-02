# Метаданные

Финальная глава книги содержит информацию об статусах теста и другие пояснения.

### Анализ результатов тестирования

После выполнения тестов, *Xcode* отображает иконку статуса для каждого теста.
Статус видно в Навигационном меню тестов, рядом с самой функцией, а так же в `.xctestplan` файле.

![Test states](assets/test_metadata.png)

> [!TIP]
> Swfit Testing предоставляет функционал, чтобы обозначить какой тест нужно пропустить, а какой завершится с ожидаемой ошибкой.<br>Подробнее о [известной ошибке][known_issue] и [пропуске в тесте][skip_test].

### Файл *.xctestplan*

https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results

[known_issue]: best_practice_short.md#Ожидаемая-ошибка-withknownissue
[skip_test]: Traits/ConditionTrait.md#Пропустить-выполнение
