//
//  AssetModel.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 15.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import RealmSwift
import ObjectMapper
import Kingfisher

class AssetModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var currency = ""
    @objc dynamic var balanceString = ""
    @objc dynamic var balance = 0.0

    @objc dynamic var address = ""
    
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var updatedAt: Date? = nil

    @objc dynamic var rate: RateModel?

    @objc dynamic var typeString = "" //token cryptocurrency
    @objc dynamic var symbol = ""

    var owner = List<TokenOwnerModel>()

    @objc dynamic var isNetworkAvailable = true

    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        currency <- map["currency"]
        address <- map["address"]
        balance <- map["balance"]
        balanceString <- map["balance"]

        var testBalance: Double?
        testBalance <- map["balance"]
        if testBalance == nil {
            isNetworkAvailable = false
        }

        createdAt <- (map["createdAt"], DateIntTransform())
        updatedAt <- (map["updatedAt"], DateIntTransform())
        rate <- map["rate"]
        rate?.id = "asset:\(id)"
        typeString <- map["type"]
        symbol <- map["symbol"]
    }

    func isToken() -> Bool {
        switch self.typeString {
        case AssetType.crypto.rawValue:
            return false
        case AssetType.token.rawValue:
            return true
        default:
            break
        }
        return false
    }

    func setIconTo(imageView: UIImageView, isSmall: Bool = false) {
        switch self.typeString {
        case AssetType.crypto.rawValue:
            switch self.currency {
            case AssetCryptoType.btc.rawValue:
                if isSmall {
                    imageView.image = R.image.bitcoinSmallIcon()
                } else {
                    imageView.image = R.image.bitcoinIcon()
                }
            case AssetCryptoType.eth.rawValue:
                if isSmall {
                    imageView.image = R.image.ethereumSmallIcon()
                } else {
                    imageView.image = R.image.ethereumIcon()
                }
            default:
                break
            }
        case AssetType.token.rawValue:
            let urlString = WalletConstants.tokenImageURL + address + ".png"
            if let url = URL(string: urlString) {
                imageView.kf.setImage(with: url, placeholder: getSymbolFakeImage())
            }
        default:
            break
        }
    }

    func getSymbolFakeImage() -> UIImage? {
        switch symbol.intRangeHash(maxInt: 3) {
            case 0:
                return R.image.token_icon_line()
            case 1:
                return R.image.token_icon_square()
            case 2:
                return R.image.token_icon_triangle()
            default:
                break
        }
        return nil
    }


    func getCurrencySmallString() -> String {

        switch self.typeString {
        case AssetType.crypto.rawValue:
            return currency
        case AssetType.token.rawValue:
            return symbol
        default:
            return "-"
        }
    }

    func getCurrencyString() -> String {

        switch self.typeString {
        case AssetType.crypto.rawValue:
            switch self.currency {
            case AssetCryptoType.btc.rawValue:
                return "Bitcoin"
            case AssetCryptoType.eth.rawValue:
                return "Ethereum"
            default:
                return "-"
            }
        case AssetType.token.rawValue:
            return symbol
        default:
            return "-"
        }
    }

    func getCurrencyColor() -> UIColor {

        switch self.typeString {
        case AssetType.crypto.rawValue:
            switch self.currency {
            case AssetCryptoType.btc.rawValue:
                return UIColor(componentType: .cryptoBitcoin)
            case AssetCryptoType.eth.rawValue:
                return UIColor(componentType: .cryptoEthereum)
            default:
                return UIColor(componentType: .viewBackground)
            }
        case AssetType.token.rawValue:
            return UIColor(componentType: .cryptoEthereum)
        default:
            return UIColor(componentType: .viewBackground)
        }
    }

    func getCryptoBalanceString(isShort: Bool = false) -> String {

        switch self.typeString {
        case AssetType.crypto.rawValue:
            if balanceString.isEmpty {
                if isShort {
                    return "\(balance.cleanValue) \(currency)"
                }
                return "\(balance.cleanValue6) \(currency)"
            } else {
                return balanceString + " \(currency)"
            }
        case AssetType.token.rawValue:
            if balanceString.isEmpty {
                if isShort {
                    return "\(balance.cleanValue) \(symbol)"
                }
                return "\(balance.cleanValue6) \(symbol)"
            } else {
                return balanceString + " \(symbol)"
            }
        default:
            return "-"
        }
    }
}
