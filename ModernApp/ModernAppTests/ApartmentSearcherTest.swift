//
//  ApartmentSearcher.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/13/25.
//
import Testing

@testable
import ModernApp

/*
 Максимально оптимизированный поиск по рынкам РФ и РБ.
 Без дополнительных фильтров.
*/
@Suite
struct FastApartmentSearcher {

	// Проверям предложения на рынке и ищем только 2-комнатную квартиру
	@Test()
	func availableApartment() async {
		let roomForOne = ApartmentSearcher(criteria: [.single, .studio])
		let result = await roomForOne.result()

		#expect(result.contains { $0.type == .twoBedroom })
	}
}
