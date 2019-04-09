//
//  EndPointType.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

internal protocol EndPointType {
    
    var baseURL: Host { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}
internal struct API:EndPointType {
    
    public var baseURL: Host
    
    public var path: String
    
    public var httpMethod: HTTPMethod
    
    
    init(baseUrl:Host ,path:String , httpMethod:HTTPMethod) {
        
        self.baseURL = baseUrl;
        self.path = path;
        self.httpMethod = httpMethod;
    }
    
    var buildRequest:URLRequest {
        
        var url:String {
            
            switch self.baseURL {
            case .version3:
                return Routes.version_3.value + self.path;
            case .version4:
                return Routes.version_4.value + self.path;
            }
        }
        
        var request = URLRequest(url: URL(string: url)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        
        request.httpMethod = self.httpMethod.rawValue
        
        return request;
    }
}

