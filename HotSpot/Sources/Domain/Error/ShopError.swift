//
//  ShopError.swift
//  HotSpot
//
//  Created by Coby on 4/19/25.
//  Copyright © 2025 Coby. All rights reserved.
//

import Foundation

enum ShopError: Error, Equatable {
    case network
    case decoding
    case server(message: String)
    case unknown
}
