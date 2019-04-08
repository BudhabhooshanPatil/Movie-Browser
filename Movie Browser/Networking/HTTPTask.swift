//
//  HTTPTask.swift
//  HeadyProject
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

internal typealias Parameters = [String:Any];
internal typealias HTTPHeaders = [String:String?];

internal protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

var boundary =  "Boundary-" + UUID().uuidString;

internal struct JSONParameterEncoder:ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: []);
            urlRequest.httpBody = jsonAsData;
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Accept");
            }
        } catch  {
            throw error;
        }
    }
}
