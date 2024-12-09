//
//  PriceTextFielddDelegate.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 09.12.24.
//

import UIKit

@objc protocol PriceTextFielddDelegate: AnyObject {
    @objc optional func textFieldDidChangeSelection(_ textField: UITextField)
    @objc optional func textFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
}

//class PricesTextField: BaseTextField, UITextFieldDelegate {
//    weak var baseDelegate: PriceTextFielddDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        priceCommonnit()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        priceCommonnit()
//    }
//    
//    private func priceCommonnit() {
//        self.delegate = self
//        self.keyboardType = .decimalPad
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return false }
//        
//        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
//        let characterSet = CharacterSet(charactersIn: string)
//        
//        if !allowedCharacters.isSuperset(of: characterSet) {
//            return false
//        }
//
//        if (text.contains(".") || text.contains(",")) && (string == "." || string == ",") {
//            return false
//        }
//        
//        let newString = (text as NSString).replacingCharacters(in: range, with: string)
//        
//        textField.text = formatPrice(input: newString)
//        return false
//    }
//
//    func formatPrice(input: String) -> String {
//        let cleanedInput = input.replacingOccurrences(of: "[^0-9.,]", with: "", options: .regularExpression)
//        let normalizedInput = cleanedInput.replacingOccurrences(of: ",", with: ".")
//        
//        if normalizedInput.last == "." {
//            return normalizedInput
//        }
//        
//        let parts = normalizedInput.components(separatedBy: ".")
//        var integerPart = parts.first ?? ""
//        let decimalPart = parts.count > 1 ? parts.last! : ""
//        
//        if integerPart.count > 9 {
//            integerPart = String(integerPart.prefix(9))
//        }
//        
//        if let number = Double(integerPart) {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .decimal
//            formatter.maximumFractionDigits = 0
//            integerPart = formatter.string(from: NSNumber(value: number)) ?? integerPart
//        }
//        
//        let formattedPrice = decimalPart.isEmpty ? integerPart : "\(integerPart).\(decimalPart.prefix(2))"
//        
//        return formattedPrice
//    }
//
//    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        baseDelegate?.textFieldDidChangeSelection?(textField)
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        baseDelegate?.textFieldDidEndEditing?(textField)
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        baseDelegate?.textFieldDidBeginEditing?(textField)
//    }
//    
//    func isValidPrice() -> Bool {
//        guard let text = self.text else { return false }
//        
//        var cleanedText = text.replacingOccurrences(of: "$", with: "")
//        cleanedText = cleanedText.replacingOccurrences(of: ".", with: ",")
//        cleanedText = cleanedText.replacingOccurrences(of: " ", with: "")
//
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.maximumFractionDigits = 2
//        numberFormatter.minimumFractionDigits = 0
//        
//        if let _ = numberFormatter.number(from: cleanedText) {
//            let components = cleanedText.components(separatedBy: ".")
//            if components.count == 2 && components[1].count > 2 {
//                return false
//            }
//            return true
//        }
//        return false
//    }
//    
//    func formatNumber() -> Double? {
//        guard let text = self.text else { return nil }
//        
//        var cleanedText = text.replacingOccurrences(of: "$", with: "")
//        cleanedText = cleanedText.replacingOccurrences(of: ".", with: ",")
//        cleanedText = cleanedText.replacingOccurrences(of: " ", with: "")
//
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.maximumFractionDigits = 2
//        numberFormatter.minimumFractionDigits = 0
//        
//        if let price = numberFormatter.number(from: cleanedText) {
//            let components = cleanedText.components(separatedBy: ".")
//            if components.count == 2 && components[1].count > 2 {
//                return nil
//            }
//            return Double(truncating: price)
//        }
//        return nil
//    }
//}

class PricesTextField: BaseTextField, UITextFieldDelegate {
    weak var baseDelegate: PriceTextFielddDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        self.keyboardType = .decimalPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let currentText = textField.text ?? ""
           guard let stringRange = Range(range, in: currentText) else { return false }
           let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
           
           let numberSet = CharacterSet(charactersIn: "0123456789")
           let characterSet = CharacterSet(charactersIn: string)
           if !numberSet.isSuperset(of: characterSet) && string != "." {
               return false
           }
           
           let decimalCount = updatedText.components(separatedBy: ".").count - 1
           if decimalCount > 1 {
               return false
           }
           
           if let dotIndex = updatedText.firstIndex(of: ".") {
               let decimalPart = updatedText[updatedText.index(after: dotIndex)...]
               if decimalPart.count > 2 {
                   return false
               }
           }
           
           if let dotIndex = updatedText.firstIndex(of: ".") {
               let integerPart = updatedText[..<dotIndex]
               if integerPart.count > 9 {
                   return false
               }
           } else {
               if updatedText.count > 9 {
                   return false
               }
           }
           
           return true
       }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            baseDelegate?.textFieldDidChangeSelection?(textField)
        }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            baseDelegate?.textFieldDidEndEditing?(textField)
        }
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
            baseDelegate?.textFieldDidBeginEditing?(textField)
        }
}

