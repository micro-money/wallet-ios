//
//  NetworkType.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 09.09.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

enum NetworkType: String {
    case main = "main"
    case rinkeby = "rinkeby"
    case ropsten = "ropsten"
    case kovan = "kovan"
    case bcy = "bcy"

    func getLink(hash: String) -> String {
        switch self {
        case .main:
            return "https://etherscan.io/tx/\(hash)"
        case .rinkeby:
            return "https://rinkeby.etherscan.io/tx/\(hash)"
        case .ropsten:
            return "https://ropsten.etherscan.io/tx/\(hash)"
        case .kovan:
            return "https://kovan.etherscan.io/tx/\(hash)"
        case .bcy:
            return "https://live.blockcypher.com/bcy/tx/\(hash)"
        }
    }
}
