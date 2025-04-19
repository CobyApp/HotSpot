//
//  ShopRepository.swift
//  HotSpot
//
//  Created by Coby on 4/19/25.
//  Copyright © 2025 Coby. All rights reserved.
//

import Foundation

protocol ShopRepository {
    func searchShops(lat: Double, lng: Double, range: Int, count: Int) async throws -> [ShopModel]
}
