//
//  ShopModel.swift
//  HotSpot
//
//  Created by Coby on 4/19/25.
//  Copyright © 2025 Coby. All rights reserved.
//

import Foundation

struct ShopModel: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String
    let access: String
    let openingHours: String?
}
