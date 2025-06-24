//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

// MARK: - CoinManagerDelegate Protocol
@MainActor
protocol CoinManagerDelegate: AnyObject {
    func didUpdateCoin(_ coinManager: CoinManager, price: Double, currency: String)
    func didFailWithError(error: Error)
}

class CoinManager {
    
    let baseURL = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies="
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    weak var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) async {
        let urlString = baseURL + currency.lowercased()
        await performRequest(with: urlString, for: currency)
    }
    
    private func performRequest(with urlString: String, crypto: String = "bitcoin", for currency: String) async {
        let urlString = "\(baseURL)?ids=\(crypto)&vs_currencies=\(currency.lowercased())"
        
        guard let url = URL(string: urlString) else {
            await delegate?.didFailWithError(error: URLError(.badURL))
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let decoded = try JSONDecoder().decode(CoinData.self, from: data)
            
            if let price = decoded.bitcoin[currency.lowercased()] {
                await delegate?.didUpdateCoin(self, price: price, currency: currency)
            } else {
                throw NSError(domain: "PriceNotFound", code: 0)
            }
        } catch {
            await delegate?.didFailWithError(error: error)
        }
    }
}
