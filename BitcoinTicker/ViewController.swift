//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let cryptoCurrencyArray = ["BCH", "BTC", "ETH", "LTC", "XMR", "XRP", "ZEC"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BCHAUD"
    var currencySelected = ""
    
    var cryptoRow = 0
    var currencyRow = 0
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        getTrackerData(url: finalURL)
        currencySelected = currencySymbolArray[currencyRow]
  
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    //To determine the number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //To determine the number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cryptoCurrencyArray.count
        }
        else {
            return currencyArray.count
        }
    }

    //To determine the row titles for the picker View
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cryptoCurrencyArray[row]
        }
        else {
            return currencyArray[row]
        }
    }
    
    
    //What to do when the user selects a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            finalURL = baseURL + cryptoCurrencyArray[row] + currencyArray[currencyRow]
            cryptoRow = row
            getTrackerData(url: finalURL)
            currencySelected = currencySymbolArray[currencyRow]
        }
        else {
            
            finalURL = baseURL + cryptoCurrencyArray[cryptoRow] + currencyArray[row]
            currencyRow = row
            getTrackerData(url: finalURL)
            currencySelected = currencySymbolArray[currencyRow]
        }
//        finalURL = baseURL + cryptoCurrencyArray[row] + currencyArray[row]
//        getTrackerData(url: finalURL)
//       currencySelected = currencySymbolArray[row]
    }
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getTrackerData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the tracker data")
                    let trackerJSON : JSON = JSON(response.result.value!)

                    self.updateTrackerData(json: trackerJSON)
                    self.updateHigh(json: trackerJSON)
                    self.updateLow(json: trackerJSON)
                    self.updateOpen(json: trackerJSON)
                    self.updateDay(json: trackerJSON)
                    self.updateHour(json: trackerJSON)
                    self.updateWeek(json: trackerJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
//
//    
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    
    func updateTrackerData(json : JSON) {
        
        if let trackResult = json["last"].double {
            bitcoinPriceLabel.text = "\(currencySelected)\(trackResult)"
        
        }
            
        else {
         
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    
    func updateHigh(json : JSON) {
        
        if let highResult = json["high"].double {
            
            highLabel.text = "\(currencySelected)\(highResult)"
        }
        
        else {
            
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    
    func updateLow(json : JSON) {
        
        if let lowResult = json["low"].double {
            lowLabel.text = "\(currencySelected)\(lowResult)"
        }
            
        else {
            
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    
    func updateOpen(json: JSON) {
        if let openResult = json["open"]["day"].double {
            openLabel.text = "\(currencySelected)\(openResult)"
        }
        
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }
    
    func updateHour(json: JSON) {
        if let hourResult = json["changes"]["price"]["hour"].double {
            hourLabel.text = "\(currencySelected)\(hourResult)"
        }
            
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }
    
    func updateDay(json: JSON) {
        if let dayResult = json["changes"]["price"]["day"].double {
            dayLabel.text = "\(currencySelected)\(dayResult)"
        }
            
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }
    
    func updateWeek(json: JSON) {
        if let weekResult = json["changes"]["price"]["week"].double {
            weekLabel.text = "\(currencySelected)\(weekResult)"
        }
            
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }
//




}

