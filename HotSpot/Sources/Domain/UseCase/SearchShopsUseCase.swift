//
//  SearchShopsUseCase.swift
//  HotSpot
//
//  Created by Coby on 4/19/25.
//  Copyright © 2025 Coby. All rights reserved.
//

import Foundation

struct SearchShopsUseCase {
    private let repository: ShopRepository

    init(repository: ShopRepository) {
        self.repository = repository
    }

    func execute(lat: Double, lng: Double, range: Int = 3, count: Int = 30) async throws -> [ShopModel] {
        try await repository.searchShops(lat: lat, lng: lng, range: range, count: count)
    }
}
