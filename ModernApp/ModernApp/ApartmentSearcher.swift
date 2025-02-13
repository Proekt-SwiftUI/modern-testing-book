//
//  ApartmentSearcher.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/13/25.
//
import Foundation

enum ApartmentCriteria {
	case single
	case studio
	case twoBedroom
	case threeBedroom
	case balcony
	case parking
}

struct Apartment: Identifiable {
	let id: Int
	let type: ApartmentCriteria
	let hasBalcony: Bool
	let hasParking: Bool
	var isAvailable: Bool
}

actor ApartmentSearcher {
	let criteria: [ApartmentCriteria]
	private var apartments: [Apartment]

	init(criteria: [ApartmentCriteria]) {
		self.criteria = criteria
		self.apartments = [
			Apartment(
				id: 1,
				type: .single,
				hasBalcony: false,
				hasParking: false,
				isAvailable: true
			),
			Apartment(
				id: 2,
				type: .studio,
				hasBalcony: true,
				hasParking: true,
				isAvailable: true
			),
			Apartment(
				id: 3,
				type: .twoBedroom,
				hasBalcony: false,
				hasParking: true,
				isAvailable: false
			),
			Apartment(
				id: 4,
				type: .threeBedroom,
				hasBalcony: true,
				hasParking: false,
				isAvailable: true
			)
		]
	}
}

extension ApartmentSearcher {
	func result() async -> [Apartment] {
		return apartments.filter { apartment in
			criteria.contains(apartment.type) && apartment.isAvailable
		}
	}
}
