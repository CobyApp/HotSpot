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

    func execute(request: ShopSearchRequestDTO) async throws -> [ShopModel] {
        try await repository.searchShops(request: request)
    }
}
