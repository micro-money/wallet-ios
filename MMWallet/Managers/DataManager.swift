//
//  DataManager.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
    private init() {
    }

    var isNeedReloadWallet = false
    var isNeedReloadAssets = false
    var isNeedReloadAddress = false
    var isNeedReloadContacts = false

    func signIn(email: String, password: String, complete:  ((AuthModel?, ApiError?, String?) -> ())?) {
        let params: [String: Any] = ["email" : email, "password" : password]
        ApiManager.shared.signIn(params: params) { (authModel, error, errorString) in
            if authModel != nil {

                StorageManager.shared.deleteAllUsers()
                StorageManager.shared.save(object: authModel!.user!, update: true)
                KeychainManager.shared.setSessionToken(value: authModel!.token!)

                complete?(authModel, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func signFacebook(token: String, complete:  ((AuthModel?, ApiError?, String?) -> ())?) {
        let params: [String: Any] = ["token" : token]
        ApiManager.shared.signFacebook(params: params) { (authModel, error, errorString) in
            if authModel != nil {

                StorageManager.shared.deleteAllUsers()
                StorageManager.shared.save(object: authModel!.user!, update: true)
                KeychainManager.shared.setSessionToken(value: authModel!.token!)

                complete?(authModel, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func signGoogle(token: String, complete:  ((AuthModel?, ApiError?, String?) -> ())?) {
        let params: [String: Any] = ["token" : token]
        ApiManager.shared.signGoogle(params: params) { (authModel, error, errorString) in
            if authModel != nil {

                StorageManager.shared.deleteAllUsers()
                StorageManager.shared.save(object: authModel!.user!, update: true)
                KeychainManager.shared.setSessionToken(value: authModel!.token!)

                complete?(authModel, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func signSocial(networkType: SocialNetworkType , token: String, userId: String?, complete:  ((AuthModel?, ApiError?, String?) -> ())?) {
        var params: [String: Any] = ["token" : token]
        if userId != nil {
            params["id"] = userId!
        }
        ApiManager.shared.signSocial(network: networkType.rawValue, params: params) { (authModel, error, errorString) in
            if authModel != nil {

                StorageManager.shared.deleteAllUsers()
                StorageManager.shared.save(object: authModel!.user!, update: true)
                KeychainManager.shared.setSessionToken(value: authModel!.token!)

                complete?(authModel, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func signUp(email: String, password: String, complete:  ((AuthModel?, ApiError?, String?) -> ())?) {
        let params: [String: Any] = ["email" : email, "password" : password]
        ApiManager.shared.signUp(params: params) { (authModel, error, errorString) in
            if authModel != nil {

                StorageManager.shared.deleteAllUsers()
                StorageManager.shared.save(object: authModel!.user!, update: true)
                KeychainManager.shared.setSessionToken(value: authModel!.token!)

                complete?(authModel, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func logout(complete: ((String?, ApiError?) -> ())?) {

        ApiManager.shared.logout() { (error, errorString) in
            if error == nil {
                StorageManager.shared.deleteAllUsers()

                complete?(nil, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func getUser(complete: ((UserModel?, _ error: ApiError?) -> ())?) {
        
        ApiManager.shared.getUser { (userModel, error) in
            if userModel != nil {
                
                StorageManager.shared.deleteAllUsers()
                StorageManager.shared.save(object: userModel!, update: true)
                
                //let userModelFromCache = StorageManager.shared.getUsers()
                //complete?(userModelFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }
        
        //let userModelFromCache = StorageManager.shared.getUsers()
        //complete?(userModelFromCache, nil)
        
    }

    func getWallet(isNeedFromCache: Bool, complete: ((WalletModel?, _ error: ApiError?) -> ())?) {

        ApiManager.shared.getWallet { (walletModel, error) in
            if walletModel != nil {

                StorageManager.shared.deleteWallet()

                StorageManager.shared.save(object: walletModel!, update: true)

                let walletFromCache = StorageManager.shared.getWallet()
                complete?(walletFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        if isNeedFromCache {
            let walletFromCache = StorageManager.shared.getWallet()
            complete?(walletFromCache, nil)
        }

    }

    func createWallet(password: String, complete: ((WalletModel?, _ error: ApiError?) -> ())?) {
        let params: [String: Any] = ["password" : password]

        ApiManager.shared.createWallet(params: params) { (walletModel, error) in
            if walletModel != nil {
                SessionManager.shared.start(words: password)
                StorageManager.shared.save(object: walletModel!, update: true)

                let walletFromCache = StorageManager.shared.getWallet()
                complete?(walletFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func getAsset(id: Int, complete: ((AssetDetailModel?, _ error: ApiError?) -> ())?) {

        ApiManager.shared.getAsset(id: id) { (assetModel, error) in
            if assetModel != nil {

                StorageManager.shared.save(object: assetModel!, update: true)

                let assetFromCache = StorageManager.shared.getAssetDetail(id: id)
                complete?(assetFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let assetFromCache = StorageManager.shared.getAssetDetail(id: id)
        complete?(assetFromCache, nil)

    }

    func createAsset(name:String, currency:String, password: String, complete: ((AssetModel?, _ error: ApiError?, String?) -> ())?) {
        let params: [String: Any] = ["name": name, "currency": currency, "password" : password]

        ApiManager.shared.createAsset(params: params) { (assetModel, error, errorString) in
            if assetModel != nil {
                SessionManager.shared.start(words: password)
                StorageManager.shared.save(object: assetModel!, update: true)

                let assetFromCache = StorageManager.shared.getAsset(id: assetModel!.id)
                complete?(assetFromCache, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func importTokenAsset(name:String, currency:String, password: String, key: String?, address: String?, complete: ((AssetModel?, _ error: ApiError?, String?) -> ())?) {
        var params: [String: Any] = ["name": name, "currency": currency, "password" : password]
        if key != nil {
            params["key"] = key
        }
        if address != nil {
            params["token"] = address
        }

        ApiManager.shared.importAsset(params: params) { (assetModel, error, errorString) in
            if assetModel != nil {
                SessionManager.shared.start(words: password)
                StorageManager.shared.save(object: assetModel!, update: true)

                let assetFromCache = StorageManager.shared.getAsset(id: assetModel!.id)
                complete?(assetFromCache, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func getCurrencyRates(complete: (([CurrencyRateModel]?, _ error: ApiError?) -> ())?) {

        let startDate = Date()
        let components = DateComponents(day: -7)
        let endDate = Calendar.current.date(byAdding: components, to: startDate)!

        let dateFromFormatter = DateFormatter()
        dateFromFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFromFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let startDateString = dateFromFormatter.string(from: startDate)
        let endDateString = dateFromFormatter.string(from: endDate)

        let params: [String: Any] = ["start" : endDateString, "end" : startDateString, "rates": "BTC,ETH"]
        
        ApiManager.shared.getCurrencyRates(params: params) { (currencyRateModels, error) in
            if currencyRateModels != nil {

                StorageManager.shared.save(objects: currencyRateModels!, update: true)

                let currencyRatesFromCache = StorageManager.shared.getCurrencyRates()
                complete?(currencyRatesFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let currencyRatesFromCache = StorageManager.shared.getCurrencyRates()
        complete?(currencyRatesFromCache, nil)

    }

    func getTransaction(id: Int, complete: ((TransactionDetailModel?, _ error: ApiError?) -> ())?) {

        ApiManager.shared.getTransaction(id: id) { (transactionDetailModel, error) in
            if transactionDetailModel != nil {

                StorageManager.shared.save(object: transactionDetailModel!, update: true)

                let assetFromCache = StorageManager.shared.getTransactionDetail(id: id)
                complete?(assetFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let assetFromCache = StorageManager.shared.getTransactionDetail(id: id)
        complete?(assetFromCache, nil)

    }

    func getTransactions(complete: (([TransactionModel]?, _ error: ApiError?) -> ())?) {

        ApiManager.shared.getTransactions { (transactionModels, error) in
            if transactionModels != nil {

                StorageManager.shared.save(objects: transactionModels!, update: true)

                let transactionsFromCache = StorageManager.shared.getTransactions()
                complete?(transactionsFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let transactionsFromCache = StorageManager.shared.getTransactions()
        complete?(transactionsFromCache, nil)

    }

    func getContactTransactions(contactId: Int, complete: (([TransactionModel]?, _ error: ApiError?) -> ())?) {

        ApiManager.shared.getContactTransactions(contactId: contactId) { (transactionModels, error) in
            if transactionModels != nil {

                StorageManager.shared.save(objects: transactionModels!, update: true)

                //let transactionsFromCache = StorageManager.shared.getTransactions()
                //complete?(transactionsFromCache, nil)
                complete?(transactionModels, nil)
            } else {
                complete?(nil, error)
            }
        }

        //let transactionsFromCache = StorageManager.shared.getTransactions()
        //complete?(transactionsFromCache, nil)

    }

    func deleteAsset(assetId: Int, complete: ((String?, ApiError?) -> ())?) {

        ApiManager.shared.deleteAsset(assetId: assetId) { (error, errorString) in
            if error == nil {
                StorageManager.shared.deleteAsset(assetId: assetId)

                complete?(nil, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func getTransactionCost(currency: String, complete: ((SpeedPriceModel?, _ error: ApiError?) -> ())?) {
        let params: [String: Any] = ["currency" : currency]

        ApiManager.shared.getTransactionCost(params:  params) { (speedPriceModel, error) in
            if speedPriceModel != nil {

                speedPriceModel!.id = currency
                speedPriceModel!.low?.id = currency + ":" + "low"
                speedPriceModel!.medium?.id = currency + ":" + "medium"
                speedPriceModel!.high?.id = currency + ":" + "high"

                StorageManager.shared.save(object: speedPriceModel!, update: true)

                let speedPriceFromCache = StorageManager.shared.getSpeedPrice(id: currency)
                complete?(speedPriceFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let speedPriceFromCache = StorageManager.shared.getSpeedPrice(id: currency)
        complete?(speedPriceFromCache, nil)
    }

    func getTransactionTokenCost(password: String, symbol: String, tokenAddress: String, toAddress: String, amount: Int, complete: ((SpeedPriceModel?, _ error: ApiError?) -> ())?) {
        let params: [String: Any] = ["password" : password, "token" : tokenAddress, "address" : toAddress, "amount" : amount]

        ApiManager.shared.getTransactionTokenCost(params:  params) { (speedPriceModel, error) in
            if error == nil {
                SessionManager.shared.start(words: password)
            }
            if speedPriceModel != nil {

                speedPriceModel!.id = symbol
                speedPriceModel!.low?.id = symbol + ":" + "low"
                speedPriceModel!.medium?.id = symbol + ":" + "medium"
                speedPriceModel!.high?.id = symbol + ":" + "high"

                StorageManager.shared.save(object: speedPriceModel!, update: true)

                let speedPriceFromCache = StorageManager.shared.getSpeedPrice(id: symbol)
                complete?(speedPriceFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let speedPriceFromCache = StorageManager.shared.getSpeedPrice(id: symbol)
        complete?(speedPriceFromCache, nil)
    }

    func sendMoney(assetId: Int, address: String, speed: String, password: String, value: String, complete: ((TransactionModel?, _ error: ApiError?, String?) -> ())?) {

        let params: [String: Any] = ["to": address, "value": value, "speed": speed, "password": password]

        ApiManager.shared.sendMoney(id:  assetId, params: params) { (transactionModel, error, errorString) in
            if transactionModel != nil {
                SessionManager.shared.start(words: password)
                StorageManager.shared.save(object: transactionModel!, update: true)

                let transactionFromCache = StorageManager.shared.getTransaction(id: transactionModel!.id)
                complete?(transactionFromCache, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func getConverter(from: String, to: String, amount: Double, complete: ((ConverterModel?, _ error: ApiError?) -> ())?) {

        var params: [String: Any] = [:]
        params["from"] = from
        params["to"] = to
        params["amount"] = amount

        let newId: String = from + ":" + to

        ApiManager.shared.getConverter(params: params) { (converterModel, error) in
            if converterModel != nil {

                converterModel!.id = newId
                converterModel!.from = from
                converterModel!.to = to

                StorageManager.shared.save(object: converterModel!, update: true)

                let converterModelFromCache = StorageManager.shared.getConverter(id: newId)
                complete?(converterModelFromCache, nil)
            } else {
                complete?(nil, error)
            }
        }

        let converterModelFromCache = StorageManager.shared.getConverter(id: newId)
        complete?(converterModelFromCache, nil)
    }

    func exportPrivateKey(assetId: Int, password: String, complete: (([ExportKeyModel]?, _ error: ApiError?, String?) -> ())?) {

        let params: [String: Any] = ["password": password, "type": "privateKey"]

        ApiManager.shared.exportPrivateKey(id:  assetId, params: params) { (exportKeyModels, error, errorString) in
            if exportKeyModels != nil {
                SessionManager.shared.start(words: password)

                //StorageManager.shared.save(object: exportKeyModel!, update: true)
                //let transactionFromCache = StorageManager.shared.getTransaction(id: transactionModel!.id)
                complete?(exportKeyModels, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func exportKeystore(assetId: Int, pass: String, password: String, complete: (([ExportKeystoreModel]?, _ error: ApiError?, String?) -> ())?) {

        let params: [String: Any] = ["password": password, "type": "keystore", "pass": pass]

        ApiManager.shared.exportKeystore(id:  assetId, params: params) { (exportKeystoreModels, error, errorString) in
            if exportKeystoreModels != nil {
                SessionManager.shared.start(words: password)

                complete?(exportKeystoreModels, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func importKeystore(name:String, currency:String, password: String, keystore: String, pass: String, complete: ((AssetModel?, _ error: ApiError?, String?) -> ())?) {
        let params: [String: Any] = ["name": name, "password": password, "currency": currency, "keystore" : keystore, "pass": pass]

        ApiManager.shared.importAsset(params: params) { (assetModel, error, errorString) in
            if assetModel != nil {
                SessionManager.shared.start(words: password)
                StorageManager.shared.save(object: assetModel!, update: true)

                let assetFromCache = StorageManager.shared.getAsset(id: assetModel!.id)
                complete?(assetFromCache, nil, nil)
            } else {
                complete?(nil, error, errorString)
            }
        }
    }

    func checkAddress(address: String, complete: ((String?, _ error: ApiError?) -> ())?) {

        let params: [String: Any] = ["address": address]

        ApiManager.shared.checkAddress(params: params) { (currencyString, error) in
            if currencyString != nil {

                complete?(currencyString, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func findTokenByAddress(address: String, complete: (([TokenInfoModel]?, _ error: ApiError?) -> ())?) {

        let params: [String: Any] = ["text": address]

        ApiManager.shared.findTokenByAddress(params: params) { (tokenInfoModels, error) in
            if tokenInfoModels != nil {

                StorageManager.shared.save(objects: tokenInfoModels!, update: true)

                complete?(tokenInfoModels, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func resendEmailToVerify(complete: ((UserModel?, _ error: ApiError?) -> ())?) {

        ApiManager.shared.resendEmailToVerify() { (userModel, error) in
            if userModel != nil {

                StorageManager.shared.save(object: userModel!, update: true)

                complete?(userModel, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func sendEmailToVerify(email:String, complete: ((UserModel?, _ error: ApiError?) -> ())?) {
        let params: [String: Any] = ["email": email]

        ApiManager.shared.sendEmailToVerify(params: params) { (userModel, error) in
            if userModel != nil {

                StorageManager.shared.save(object: userModel!, update: true)

                complete?(userModel, nil)
            } else {
                complete?(nil, error)
            }
        }
    }

    func getFirstAsset(currency: String) -> AssetModel? {
        return StorageManager.shared.getAssets(currency: currency)?.first
    }

    func testEmailConfirmation() {
        if let user = StorageManager.shared.getUsers()?.first {
            if user.confirmed == false {
                if user.email.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let verifyEmailView = R.nib.sendVerifyEmailView.firstView(owner: nil)
                        UIApplication.shared.keyWindow?.addSubview(verifyEmailView!)
                        verifyEmailView!.snp.makeConstraints { (make) -> Void in
                            make.top.equalTo(0)
                            make.left.equalTo(0)
                            make.width.equalTo(UIScreen.main.bounds.width)
                            make.height.equalTo(UIScreen.main.bounds.height)
                        }
                        verifyEmailView!.configureView(userId: user.id)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let verifyEmailView = R.nib.verifyEmailView.firstView(owner: nil)
                        UIApplication.shared.keyWindow?.addSubview(verifyEmailView!)
                        verifyEmailView!.snp.makeConstraints { (make) -> Void in
                            make.top.equalTo(0)
                            make.left.equalTo(0)
                            make.width.equalTo(UIScreen.main.bounds.width)
                            make.height.equalTo(UIScreen.main.bounds.height)
                        }
                        verifyEmailView!.configureView(userId: user.id)
                    }
                }
            }
        }
    }

    func testPasswordConfirmation() {
        if let user = StorageManager.shared.getUsers()?.first {
            if !user.secret.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let passwordView = R.nib.passwordView.firstView(owner: nil)
                    UIApplication.shared.keyWindow?.addSubview(passwordView!)
                    passwordView!.snp.makeConstraints { (make) -> Void in
                        make.top.equalTo(0)
                        make.left.equalTo(0)
                        make.width.equalTo(UIScreen.main.bounds.width)
                        make.height.equalTo(UIScreen.main.bounds.height)
                    }
                    passwordView!.configureView(password: user.secret)
                }
            }
        }
    }
}
