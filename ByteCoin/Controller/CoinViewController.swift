//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
        initialeCoinUpdate()
    }
    
    func initialeCoinUpdate() {
        Task {
            await coinManager.getCoinPrice(for: coinManager.currencyArray[0])
        }
    }
}

// MARK: - CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, price: Double, currency: String) {
        bitcoinLabel.text = String(format: "%.2f", price)
        currencyLabel.text = currency
    }

    func didFailWithError(error: Error) {
        print("❌ Ошибка: \(error.localizedDescription)")
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension CoinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        Task {
            await coinManager.getCoinPrice(for: selectedCurrency)
        }
    }
}
