//
//  String.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

extension String {
    public func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
    public func isNumeric() -> Bool {
        return (self as NSString).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted).location == NSNotFound
    }
    
    public func debugTrim() -> String {
        var res: String = self
        res = res.replacingOccurrences(of: "\n", with: "")
        res = res.replacingOccurrences(of: "\r", with: "")
        res = res.replacingOccurrences(of: "  ", with: " ")
        res = res.replacingOccurrences(of: "  ", with: " ")
        res = res.replacingOccurrences(of: "{ ", with: "{")
        res = res.replacingOccurrences(of: "\" : \"", with: ":")
        return res
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
}

// MARK: - Validation

/*
extension String {
    var isValidEmail: Bool {
        get {
            let stricterFilterString: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
            return predicate.evaluate(with: self)
        }
    }

    /*
    var isValidPhone: Bool {
        get {
            let phoneNumberKit = PhoneNumberKit()
            do {
                _ = try phoneNumberKit.parse(self)
                return true
            } catch {
                return false
            }
        }
    }
    */
    
    func isValid(for regex: String) -> Bool {
        return !matches(for: regex).isEmpty
    }
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            //logError("Invalid regular expression: \(error.localizedDescription)")
            return []
        }
    }

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
 */

extension String {
    var hex: String {
        let data = self.data(using: .utf8)!
        return data.map { String(format: "%02x", $0) }.joined()
    }
    
    var hexEncoded: String {
        let data = self.data(using: .utf8)!
        return data.hexEncoded
    }
    
    var isHexEncoded: Bool {
        guard starts(with: "0x") else {
            return false
        }
        let regex = try! NSRegularExpression(pattern: "^0x[0-9A-Fa-f]*$")
        if regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).isEmpty {
            return false
        }
        return true
    }

    func isValidBitcoinAddress() -> Bool {
        let fullAddress = self.components(separatedBy: ":")
        if fullAddress.count == 2 && fullAddress[0] == "bitcoin" {
            let pattern = "^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$"
            let r = fullAddress[1].startIndex..<fullAddress[1].endIndex
            let r2 = fullAddress[1].range(of: pattern, options: .regularExpression)
            return r == r2
        } else {
            return false
        }
    }
    
    var doubleValue: Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = "."
        if let result = formatter.number(from: self) {
            return result.doubleValue
        } else {
            formatter.decimalSeparator = ","
            if let result = formatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

// MARK: - Localiztion

extension NSAttributedString {
    
    var isLocalizableKey: Bool { return string.isLocalizableKey }
    
    func localized() -> NSAttributedString {
        return NSAttributedString(string: string.localized(), attributes: attributes(at: 0, effectiveRange: nil))
    }
}

extension String {
    
    var isLocalizableKey: Bool { return hasPrefix("#") }
    
    func localized(pluralCount: Double? = nil) -> String {
        
        let key = hasPrefix("#") ? String(self.dropFirst()) : self
        let languageCode = LanguageManager.appLocalizationCode
        
        let localizationBundle = Bundle(path: Bundle(for: WalletConstants.self).path(forResource: languageCode, ofType: "lproj")!)!
        
        if let count = pluralCount,
            let pluralRule = localizedPluralRuleFor(languageCode: languageCode, count: count) {
            
            let pluralKey = "\(key){\(pluralRule.rawValue)}"
            let string = localizationBundle.localizedString(forKey: pluralKey, value: "", table: nil)
            let pluralString = String(format: string, count)
            
            return pluralString
        } else {
            
            let string = localizationBundle.localizedString(forKey: key, value: "", table: nil)
            
            return string
        }
    }
}

// MARK: - Pluralization

extension String {
    private enum LanguageCode: String {
        case en, es, ru
    }
    
    enum PluralRule: String {
        case zero, one, two, few, many, other
    }
    
    func localizedPluralRuleFor(languageCode: String, count: Double) -> PluralRule? {
        
        let count = fabs(count)
        
        // http://www.unicode.org/cldr/charts/33/supplemental/language_plural_rules.html
        guard let code: LanguageCode = LanguageCode(rawValue: languageCode) else { return nil }
        
        switch code{
        case .en:
            return enPluralRuleForCount(count)
        case .es:
            return esPluralRuleForCount(count)
        case .ru:
            return ruPluralRuleForCount(count)
        }
    }
    
    private func ruPluralRuleForCount(_ count: Double) -> PluralRule {
        let count = Int(count)
        
        let mod10: Int = count % 10
        let mod100: Int = count % 100
        
        switch mod100 {
        case 11, 12, 13, 14:
            break
        default:
            switch mod10 {
            case 1:
                return .one
            case 2, 3, 4:
                return .few
            default:
                break
            }
        }
        return .many
    }
    
    private func enPluralRuleForCount(_ count: Double) -> PluralRule {
        switch count {
        case 1:
            return .one
        default:
            return .other
        }
    }
    
    private func esPluralRuleForCount(_ count: Double) -> PluralRule {
        switch count {
        case 1:
            return .one
        default:
            return .other
        }
    }
    
}

extension String {
    var toDouble: Double {
        return Double(self) ?? 0.0
    }
}

extension String {
    var fourBitHash: Int {
        return self.utf8.reduce(0) { $0 + Int($1) } % 16
    }
    var twoBitHash: Int {
        return self.utf8.reduce(0) { $0 + Int($1) } % 8
    }
    func intRangeHash(maxInt: Int) -> Int {
        return self.utf8.reduce(0) { $0 + Int($1) } % maxInt
    }
}

extension String {
    var isValidEmail: Bool {
        get {
            let stricterFilterString: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
            return predicate.evaluate(with: self)
        }
    }

}
