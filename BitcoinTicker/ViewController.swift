//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Sako Hovaguimian on 16/05/2018.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bit data")
                    
                    let bitJSON : JSON = JSON(response.result.value!)
                    // GCD Notes
                    DispatchQueue.main.async {
                        self.updateBitData(json: bitJSON)
                    }

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    
                    DispatchQueue.main.async {
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
                    
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitData(json : JSON) {
        
        if let BitResult = json["ask"].double {
            self.bitcoinPriceLabel.text = "\(BitResult)"
        }
        else {
            self.bitcoinPriceLabel.text = "Bit Unavailable"
    }
    
    }
    func setUpView() {
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }

}


extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        getBitData(url: finalURL)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = currencyArray[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [
            .font: UIFont(name: "Georgia", size: 15.0)!,
            .foregroundColor:UIColor.orange
        ])
        
        return myTitle
        
    }

}
