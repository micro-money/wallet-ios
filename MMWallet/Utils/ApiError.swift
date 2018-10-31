//
//  ApiError.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 18.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

enum ApiError: Error {
    
    // Default
    case unknown
    case connectionError
    case accessError
    case parametrsError
    case serverError
    
    // Custom
    //case balanceTooLow
    
    static func from(statusCode: Int?) -> ApiError {
        return ApiError.from(code: statusCode)
    }

    func getErrorString() -> String {
        switch self {
            case .connectionError:
                return "Connection Error"
            case .parametrsError:
                return "Try user other email and password"
            case .accessError:
                return "Authorization Error"
            case .serverError:
                return "Server Internal Error"
            default:
                return "Unknown Error"
        }
    }
    
    private static func from(code: Int?) -> ApiError {
        
        switch code {
        case nil:
            return .connectionError
        case -1009, -1004, -1001, 0:
            return .connectionError
        case 400:
            return .parametrsError
        case 403:
            return .accessError
        case 500:
            return .serverError
        default:
            break
        }
        
        return .unknown
    }
}
