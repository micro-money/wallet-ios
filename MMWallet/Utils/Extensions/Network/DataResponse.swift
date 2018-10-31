//
//  DataResponse.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Alamofire

extension DataResponse {
    
    func logError() {
        let url = request?.url?.absoluteString ?? ""
        print("\nFailed request: \(url)")
        guard let errorData = self.data else { return }
        let errorString = String(data: errorData, encoding: .utf8) ?? ""
#if DEBUG
        print("Error : \(errorString)")
#endif
    }
    
    func logResponse(requestId: Int?) {
        guard let bodyData = self.data else { return }
        guard let resultHeader = self.response?.allHeaderFields as NSDictionary? else { return }
        guard let resultBody = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableLeaves) as? [String: Any] else { return }
        
        let result = """
        [\(requestId!)] Response (\(String(describing: self.response?.statusCode)))
        {
        Headers = {
        \(String(describing: resultHeader))
        };
        Body = {
        \(String(describing: resultBody))
        };
        }
        """

#if DEBUG
        print(result)
#endif
    }
    
    func getErrorString() -> [String: Any]? {
        guard let bodyData = self.data else { return nil }
        guard let resultBody = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableLeaves) as? [String: Any] else { return nil }
        return resultBody
    }
    
    func getErrorMessageString() -> String? {
        guard let bodyData = self.data else { return nil }
        guard let resultBody = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableLeaves) as? [String: Any] else { return nil }
        let error = resultBody!["error"] as? NSDictionary
        return error?["message"] as? String
    }
    
    func getErrorCode() -> String? {
        guard let bodyData = self.data else { return nil }
        guard let resultBody = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableLeaves) as? [String: Any] else { return nil }
        let error = resultBody!["error"] as? NSDictionary
        return error?["code"] as? String
    }
}
