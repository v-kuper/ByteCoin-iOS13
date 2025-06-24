//
//  CoinResponse.swift
//  ByteCoin
//
//  Created by Vitali Kupratsevich on 24.06.25.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let bitcoin: [String: Double]
}
