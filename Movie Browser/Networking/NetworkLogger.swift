//
//  NetworkLogger.swift
//  HeadyProject
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

class Logger {
    
    static var isDebug : Bool {
        
        return true;
    }
    
    static func log(request: URLRequest) {
        
        Logger.print(items: "\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        
        defer {  Logger.print(items: "\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        Logger.print(items: logOutput);
    }
    
    static func log(data:Data){
        
        do {
            
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []);
            Logger.print(items:  "\n - - - - - - - - - - response start - - - - - - - - - - \n");
            Logger.print(items:jsonResponse);
            Logger.print(items:  "\n - - - - - - - - - - response end - - - - - - - - - - \n");
            
            if let stringJson = String(data: data, encoding: .utf8){
                
                Logger.print(items:  "\n - - - - - - - - - - json start - - - - - - - - - - \n");
                Logger.print(items: stringJson);
                Logger.print(items:  "\n - - - - - - - - - - json end - - - - - - - - - - \n");
            }
            
        } catch  {
            Logger.print(items: error.localizedDescription);
        }
    }
    
    static func print(items: Any..., separator: String = " ", terminator: String = "\n"){
        
        if isDebug {
            
            var idx = items.startIndex;
            let endIdx = items.endIndex;
            
            repeat {
                
                Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator);
                idx += 1;
            }
            while idx < endIdx;
        }
    }
    
    
}
