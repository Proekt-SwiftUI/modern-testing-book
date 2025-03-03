// Tags+Extension.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import Testing

extension Tag {
	/// Все, что связано с калькулятором
	@Tag
	static var calculator: Self

	/// Тесты относящиеся к путям профиля
	@Tag
	static var profilePath: Self

	@Tag
	static var cityFinder: Self

	@Tag
	static var weather: Self

	@Tag
	static var fileSize: Self
}
