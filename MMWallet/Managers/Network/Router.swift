//
//  Router.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    case signIn([String: Any])
    case signUp([String: Any])
    case getUser()
    case logout()
    case signFacebook([String: Any])
    case signGoogle([String: Any])
    case signSocial(String, [String: Any])

    case getWallet()
    case getMnemonic()
    case createWallet([String: Any])

    case getAsset(Int)
    case createAsset([String: Any])
    case importAsset([String: Any])
    case deleteAsset(Int)

    case sendMoney(Int, [String: Any])
    case getTransactionCost([String: Any])
    case getTransactionTokenCost([String: Any])

    case getCurrencyRate([String: Any])

    case getTransactions()
    case getTransaction(Int)
    case getContactTransactions(Int)

    case getConverter([String: Any])

    case exportPrivateKey(Int, [String: Any])
    case exportPrivateData(Int, [String: Any])

    case checkAddress([String: Any])

    case findTokenByAddress([String: Any])

    case sendEmailToVerify([String: Any])
    case resendEmailToVerify()
    
    private var urlEncoder: ParameterEncoding {
        return Alamofire.URLEncoding()
    }
    private var jsonEncoder: ParameterEncoding {
        return Alamofire.JSONEncoding()
    }

    var method : Alamofire.HTTPMethod {
        switch self {
        //case .updateContact(_,_):
        //    return .put
        //case .deleteContact(_),
        //     .deleteContactAddress(_, _):
        //    return .delete
        case .getUser(),
             .getWallet(),
             .getMnemonic(),
             .getAsset(_),
             .getCurrencyRate(_),
             .getTransactions(),
             .getTransaction(_),
             .getContactTransactions(_),
             .getConverter(_),
             .getTransactionCost(_),
             .getTransactionTokenCost(_),
             .exportPrivateKey(_, _),
             .exportPrivateData(_, _),
             .checkAddress(_),
             .findTokenByAddress(_):
            return .get
        case
                .deleteAsset(_),
                .signIn(_),
             .signFacebook(_),
             .signGoogle(_),
                .signSocial(_, _),
             .signUp(_),
             .logout(),
             .createWallet(_),
             .createAsset(_),
             .importAsset(_),
             .sendMoney(_, _),
            .sendEmailToVerify(_),
            .resendEmailToVerify():
            return .post
        }
    }
    
    var path : String {
        switch self {
        case .getUser():
            return "/api/v2/users/me"
        case .signIn(_):
            return "/api/v2/users/auth/email"
        case .signFacebook(_):
            return "/api/v2/users/auth/facebook/token"
        case .signGoogle(_):
            return "/api/v2/users/auth/google/token"
        case .signSocial(let network, _):
            return "/api/v2/users/auth/\(network)/token"
        case .signUp(_):
            return "/api/v2/users"
        case .logout():
            return "/api/v1/user/logout"
        case .getWallet():
            return "/api/v2/wallets/me"
        case .getMnemonic():
            return "/api/v2/wallets/mnemonic"
        case .createWallet(_):
            return "/api/v2/wallets"
        case .getAsset(let id):
            return "/api/v2/wallets/assets/\(id)"
        case .createAsset(_):
            return "/api/v2/wallets/assets"
        case .deleteAsset(let id):
            return "/api/v2/wallets/assets/\(id)/delete"
        case .importAsset(_):
            return "/api/v2/wallets/assets/import"
        case .getCurrencyRate(_):
            return "/api/v2/currencies/rates"
        case .getTransactions():
            return "/api/v2/wallets/transactions/me"
        case .getTransaction(let id):
            return "/api/v2/wallets/transactions/\(id)"
        case .getContactTransactions(let id):
            return "/api/v2/wallets/transactions/contacts/\(id)"
        case .getTransactionCost(_):
            return "/api/v2/currencies/transaction/cost"
        case .getTransactionTokenCost(_):
            return "/api/v2/currencies/transaction/cost/token"
        case .sendMoney(let id, _):
            return "/api/v2/wallets/assets/\(id)/transaction"
        case .getConverter(_):
            return "/api/v2/currencies/converter"
        case .exportPrivateKey(let id, _):
            return "/api/v2/wallets/assets/\(id)/export"
        case .exportPrivateData(let id, _):
            return "/api/v2/wallets/assets/\(id)/export"
        case .checkAddress(_):
            return "/api/v2/currencies/address/check"
        case .findTokenByAddress(_):
            return "/api/v2/currencies/address"
        case .sendEmailToVerify(_):
            return "/api/v2/users/email/send"
        case .resendEmailToVerify():
            return "/api/v2/users/email/send"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let requestUrl = URL(string: ApiManager.shared.getServerUrl() + path)
        var request = try URLRequest(url: requestUrl!, method: method)
        var paramsToLog: [String: Any]?
        
         switch self {
         case .signIn(let params):
            request = try jsonEncoder.encode(request, with: params)
             paramsToLog = params
         case .signSocial(_, let params):
             request = try jsonEncoder.encode(request, with: params)
             paramsToLog = params
         case .signFacebook(let params):
             request = try jsonEncoder.encode(request, with: params)
             paramsToLog = params
         case .signGoogle(let params):
             request = try jsonEncoder.encode(request, with: params)
             paramsToLog = params
         case .signUp(let params):
             request = try jsonEncoder.encode(request, with: params)
             paramsToLog = params
         case .logout():
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .getWallet():
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .getMnemonic():
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .createWallet(let params):
             request = try jsonEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .getAsset(_):
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .createAsset(let params):
             request = try jsonEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .importAsset(let params):
             request = try jsonEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .getCurrencyRate(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .getTransactions():
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .getContactTransactions(_):
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .deleteAsset(_):
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .getTransaction(_):
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         case .getTransactionCost(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .getTransactionTokenCost(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .sendMoney(_, let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .getConverter(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .exportPrivateKey(_, let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .exportPrivateData(_, let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .checkAddress(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .findTokenByAddress(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .sendEmailToVerify(let params):
             request = try urlEncoder.encode(request, with: params)
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
             paramsToLog = params
         case .resendEmailToVerify():
             request.setValue("Bearer \(KeychainManager.shared.sessionToken!)", forHTTPHeaderField: "Authorization")
         default:
                break
         }

        //request.setValue("Bearer XXX", forHTTPHeaderField: "Authorization")

        log(request: request, params: paramsToLog)
        
        return request
    }

    private func log(request: URLRequest, params: [String: Any]?) {
#if DEBUG
        print(request.log(requestId: ApiManager.shared.requestId, params: params))
#endif
    }
}
