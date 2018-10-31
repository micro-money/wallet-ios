//
//  ApiManager.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

//import SwiftyJSON

class ApiManager {
    
    var requestId: Int = 0
    
    static let shared = ApiManager()
    private init() {}
    
    typealias ErrorCompletion = (ApiError?, String?) -> Void

    typealias SignInCompletion = (AuthModel?, ApiError?, String?) -> Void
    typealias SignUpCompletion = (AuthModel?, ApiError?, String?) -> Void
    typealias GetUserCompletion = (UserModel?, ApiError?) -> Void
    typealias GetWalletCompletion = (WalletModel?, ApiError?) -> Void
    typealias GetMnemonicCompletion = (MnemonicModel?, ApiError?) -> Void
    typealias GetAssetCompletion = (AssetModel?, ApiError?) -> Void
    typealias CreateAssetCompletion = (AssetModel?, ApiError?, String?) -> Void
    typealias GetAssetDetailCompletion = (AssetDetailModel?, ApiError?) -> Void
    typealias GetCurrencyRatesCompletion = ([CurrencyRateModel]?, ApiError?) -> Void
    typealias GetTransactionCompletion = (TransactionDetailModel?, ApiError?) -> Void
    typealias GetTransactionsCompletion = ([TransactionModel]?, ApiError?) -> Void
    typealias GetContactsCompletion = ([ContactModel]?, ApiError?) -> Void
    typealias GetContactCompletion = (ContactModel?, ApiError?) -> Void
    typealias GetContactAddressCompletion = (ContactAddressModel?, ApiError?) -> Void
    typealias GetContactDetailCompletion = (ContactDetailModel?, ApiError?) -> Void
    typealias GetTransactionCostCompletion = (SpeedPriceModel?, ApiError?) -> Void
    typealias GetSendMoneyCompletion = (TransactionModel?, ApiError?, String?) -> Void
    typealias GetConverterCompletion = (ConverterModel?, ApiError?) -> Void
    typealias GetExportKeyCompletion = ([ExportKeyModel]?, ApiError?, String?) -> Void
    typealias GetExportKeystoreCompletion = ([ExportKeystoreModel]?, ApiError?, String?) -> Void
    typealias GetStringCompletion = (String?, ApiError?) -> Void
    typealias GetTokenInfoCompletion = ([TokenInfoModel]?, ApiError?) -> Void

    var isDemoLogin = false

    func getServerUrl() -> String {
        if isDemoLogin {
            //TODO: need to test apple from approve
            //return WalletConstants.demoURL
        }

        return "https://" + Environment().configuration(PlistKey.ServerURL)
    }
    
    func signIn(params: [String: Any], completion: @escaping SignInCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.signIn(params))
            .validate(statusCode: 200..<300)
            .responseObject() {[weak self] (response: DataResponse<AuthModel>) in
                self?.hideNetworkActivity()
                if let item = response.result.value {
                    response.logResponse(requestId: currentRequestId)
                    completion(item, nil, nil)
                } else {
                    self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                    let apiError = ApiError.from(statusCode: response.response?.statusCode)
                    completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                }
        }
    }

    static func getSignErrorString(responseErrorDictionary: [String: Any]?) -> String? {

        if responseErrorDictionary != nil {
            if let errorInfoArray = responseErrorDictionary!["errors"] as? [Any] {
                if let errorInfo = errorInfoArray[0] as? [String: Any] {
                    if let msg = errorInfo["msg"] as? String, let param = errorInfo["param"] as? String {
                        return param + " : " + msg
                    }
                }
            }
        }

        return nil
    }

    func signFacebook(params: [String: Any], completion: @escaping SignInCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.signFacebook(params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<AuthModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        let apiError = ApiError.from(statusCode: response.response?.statusCode)
                        completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                    }
                }
    }

    func signGoogle(params: [String: Any], completion: @escaping SignInCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.signGoogle(params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<AuthModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        let apiError = ApiError.from(statusCode: response.response?.statusCode)
                        completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                    }
                }
    }

    func signSocial(network: String, params: [String: Any], completion: @escaping SignInCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.signSocial(network, params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<AuthModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        let apiError = ApiError.from(statusCode: response.response?.statusCode)
                        completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                    }
                }
    }

    func signUp(params: [String: Any], completion: @escaping SignUpCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.signUp(params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<AuthModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        let apiError = ApiError.from(statusCode: response.response?.statusCode)
                        completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                    }
                }
    }

    func logout(completion: @escaping ErrorCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.logout())
                .validate(statusCode: 200..<300)
                .responseJSON { [weak self] response in
                    self?.hideNetworkActivity()
                    if let _ = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        let apiError = ApiError.from(statusCode: response.response?.statusCode)
                        completion(apiError, nil)
                    }
                }
    }

    func getUser(completion: @escaping GetUserCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getUser())
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "user") {[weak self] (response: DataResponse<UserModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        let apiError = ApiError.from(statusCode: response.response?.statusCode)
                        completion(nil, apiError)
                    }
                }
    }

    func getWallet(completion: @escaping GetWalletCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getWallet())
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "wallet") {[weak self] (response: DataResponse<WalletModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func getMnemonic(completion: @escaping GetMnemonicCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getMnemonic())
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<MnemonicModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func createWallet(params: [String: Any], completion: @escaping GetWalletCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.createWallet(params))
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "wallet") {[weak self] (response: DataResponse<WalletModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func getAsset(id: Int, completion: @escaping GetAssetDetailCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getAsset(id))
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "asset") {[weak self] (response: DataResponse<AssetDetailModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func createAsset(params: [String: Any], completion: @escaping CreateAssetCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.createAsset(params))
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "asset") {[weak self] (response: DataResponse<AssetModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                        }
                    }
                }
    }

    func importAsset(params: [String: Any], completion: @escaping CreateAssetCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.importAsset(params))
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "asset") {[weak self] (response: DataResponse<AssetModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                        }
                    }
                }
    }

    func getCurrencyRates(params: [String: Any], completion: @escaping GetCurrencyRatesCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getCurrencyRate(params))
                .validate(statusCode: 200..<300)
                .responseArray(keyPath: "rateList") {[weak self] (response: DataResponse<[CurrencyRateModel]>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func getTransaction(id: Int, completion: @escaping GetTransactionCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getTransaction(id))
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "transaction") {[weak self] (response: DataResponse<TransactionDetailModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }
    func getTransactions(completion: @escaping GetTransactionsCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getTransactions())
                .validate(statusCode: 200..<300)
                .responseArray(keyPath: "transactionList") {[weak self] (response: DataResponse<[TransactionModel]>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }
    func getContactTransactions(contactId: Int, completion: @escaping GetTransactionsCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getContactTransactions(contactId))
                .validate(statusCode: 200..<300)
                .responseArray(keyPath: "transactionList") {[weak self] (response: DataResponse<[TransactionModel]>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func deleteAsset(assetId: Int, completion: @escaping ErrorCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.deleteAsset(assetId))
                .validate(statusCode: 200..<300)
                .responseString { [weak self] response in
                    self?.hideNetworkActivity()
                    if let _ = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(apiError, nil)
                        }
                    }
                }
    }

    func getTransactionCost(params: [String: Any], completion: @escaping GetTransactionCostCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getTransactionCost(params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<SpeedPriceModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func getTransactionTokenCost(params: [String: Any], completion: @escaping GetTransactionCostCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getTransactionTokenCost(params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<SpeedPriceModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func sendMoney(id: Int, params: [String: Any], completion: @escaping GetSendMoneyCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.sendMoney(id, params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<TransactionModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                        }
                    }
                }
    }

    func getConverter(params: [String: Any], completion: @escaping GetConverterCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.getConverter(params))
                .validate(statusCode: 200..<300)
                .responseObject() {[weak self] (response: DataResponse<ConverterModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func exportPrivateKey(id: Int, params: [String: Any], completion: @escaping GetExportKeyCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.exportPrivateKey(id, params))
                .validate(statusCode: 200..<300)
                .responseArray(keyPath: "addressList") {[weak self] (response: DataResponse<[ExportKeyModel]>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                        }
                    }
                }
    }

    func exportKeystore(id: Int, params: [String: Any], completion: @escaping GetExportKeystoreCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.exportPrivateData(id, params))
                .validate(statusCode: 200..<300)
                .responseArray(keyPath: "addressList") {[weak self] (response: DataResponse<[ExportKeystoreModel]>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError, ApiManager.getSignErrorString(responseErrorDictionary: response.getErrorString()))
                        }
                    }
                }
    }

    func checkAddress(params: [String: Any], completion: @escaping GetStringCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.checkAddress(params))
                .validate(statusCode: 200..<300)
                .responseJSON {[weak self] response in
                    self?.hideNetworkActivity()
                    if let data = response.result.value {
                        response.logResponse(requestId: currentRequestId)

                        let data = data as! [String: Any]
                        let currencyString = data["currency"] as? String
                        completion(currencyString, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func findTokenByAddress(params: [String: Any], completion: @escaping GetTokenInfoCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.findTokenByAddress(params))
                .validate(statusCode: 200..<300)
                .responseArray(keyPath: "addressList") {[weak self] (response: DataResponse<[TokenInfoModel]>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func resendEmailToVerify(completion: @escaping GetUserCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.resendEmailToVerify())
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "user") {[weak self] (response: DataResponse<UserModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }

    func sendEmailToVerify(params: [String: Any], completion: @escaping GetUserCompletion) {
        showNetworkActivity()
        let currentRequestId = requestId.increment()
        Alamofire.request(Router.sendEmailToVerify(params))
                .validate(statusCode: 200..<300)
                .responseObject(keyPath: "user") {[weak self] (response: DataResponse<UserModel>) in
                    self?.hideNetworkActivity()
                    if let item = response.result.value {
                        response.logResponse(requestId: currentRequestId)
                        completion(item, nil)
                    } else {
                        self?.log(requestId: currentRequestId, error: response.result.error, statusCode: response.response?.statusCode, errorString: response.getErrorString(), data: response.data)
                        if self?.testErrorAuthenticationResponse(statusCode: response.response?.statusCode) ?? false {
                            let apiError = ApiError.from(statusCode: response.response?.statusCode)
                            completion(nil, apiError)
                        }
                    }
                }
    }
    //

    private func testErrorAuthenticationResponse(statusCode: Int?) -> Bool {
        if statusCode == nil {
            return true
        }

        if statusCode! == 401 {
            BaseViewController.resetToRootController()
            return false
        }
        if statusCode! == 409 {
            //DataManager.shared.testEmailConfirmation()
            //return false
        }
        return true
    }
    
    private var requestCount = 0
    
    private func showNetworkActivity() {
        requestCount += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func hideNetworkActivity() {
        requestCount -= 1
        if requestCount < 0 {
            requestCount = 0
        }
        if requestCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func log(statusCode: Int?, headers: [AnyHashable : Any]?, bodyString: String) {
        
        let result = """
        [0] Response (\(String(describing: statusCode)))
        {
        Headers = {
        \(String(describing: headers))
        };
        Body = {
        \(String(describing: bodyString))
        };
        }
        """
        
        print(result)
    }
    
    private func log(requestId: Int?, error: Error?, statusCode: Int?, errorString: [String: Any]?, data: Data?) {
        print("[\(requestId!)] Error network request: \(error?.localizedDescription ?? ""), statusCode: \(statusCode ?? 0)\nResponse: \(errorString ?? [:])")
        if data != nil {
#if DEBUG
            print("--------------------")
            print(String(data: data!, encoding: .ascii)!)
            print("--------------------")
#endif
        }
    }
    
}
