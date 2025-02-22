// BestCalculator.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import typealias Foundation.Collection

actor BestCalculator {
	let value: any Collection<Int>

	init(value: any Collection<Int>) {
		self.value = value
	}

	/// Возвращает сумму элементов в коллекции
	var total: Int {
		value.reduce(.zero, +)
	}

	func getFirstValue() -> Int {
		guard let value = value.first else {
			return .zero
		}

		return value
	}
}
