//
//  URLRequest.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

extension URLRequest {
    
    func log(requestId: Int?, params: [String: Any]?) -> String {
        var result = ""
        
        if  let httpBody = self.httpBody,
            let jsonBody = try? JSONSerialization.jsonObject(with: httpBody, options: .mutableLeaves) as? [String: Any] {
            let parameters = jsonBody as NSDictionary?
            result = """
            [\(requestId!)] (\(self.httpMethod!)) \(self.url!.scheme!)://\(self.url!.host!)\(self.url!.path) <\(self.cachePolicy)>
            Request:
            {
            Headers = {
            \(self.allHTTPHeaderFields ?? [:])
            };
            Parameters = {
            \(parameters ?? [:])
            };
            }
            """
        } else if let query = self.url?.query {
            var parameters: String = ""
            let queryParameters = query.components(separatedBy: "=")
            for (i, field) in queryParameters.enumerated() {
                parameters.append(i % 2 == 0 ? "\(field) = " : "\(field);\n")
            }
            
            result = """
            [\(requestId!)] (\(self.httpMethod!)) \(self.url!.scheme!)://\(self.url!.host!)\(self.url!.path) <\(self.cachePolicy)>
            Request:
            {
            Headers = {
            \(self.allHTTPHeaderFields ?? [:])
            };
            Parameters = {
            \(parameters)
            };
            }
            """
        } else {
            let parameters = params as NSDictionary?
            result = """
            [\(requestId!)] (\(self.httpMethod!)) \(self.url!.scheme!)://\(self.url!.host!)\(self.url!.path) <\(self.cachePolicy)>
            Request:
            {
            Headers = {
            \(self.allHTTPHeaderFields ?? [:])
            };
            Parameters = {
            \(parameters ?? [:])
            };
            }
            """
        }
        
        return result
    }
}
