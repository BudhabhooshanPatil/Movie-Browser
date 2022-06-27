//
//  EndPointType.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.themoviedb.org/3/movie/"
    }
}

enum ImagebasePath: String {
    case w185
    case w300
    case w500
}

struct API: Endpoint {
    
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]?
    var body: Data?
    
    init(path: String, httpMethod: HTTPMethod, body: Data? = nil, queryItems: [URLQueryItem]? = nil) {
        self.path = path
        self.method = httpMethod
        self.body = body
        self.queryItems = queryItems
    }
    
    var buildRequest: URLRequest {
        
        var urlComponents = URLComponents(string: self.baseURL + self.path)
        urlComponents?.queryItems = [self.apiKeyQueryItem]
        if let queryItems = self.queryItems {
            urlComponents?.queryItems?.append(contentsOf: queryItems)
        }
        guard let url = urlComponents?.url else { fatalError() }
        var request = URLRequest(url:url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        
        request.httpMethod = self.method.rawValue
        request.httpBody = self.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private var apiKeyQueryItem =  URLQueryItem(name: "api_key", value: Constants.APIDetails.APIKey.rawValue)
}
