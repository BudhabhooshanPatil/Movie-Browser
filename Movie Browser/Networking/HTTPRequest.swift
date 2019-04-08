//
//  HTTPRequest.swift
//  HeadyProject
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

enum ResultType<T> {
    case success
    case failure(T)
}

private func handleRsponse (_ response:HTTPURLResponse ,serverdata:Data) -> ResultType<Any> {
    
    switch response.statusCode {
    case 200...299:
        return .success
    default:
        return .failure(serverdata);
    }
}
internal typealias NetworkRouterCompletion = (_ data:Data? ,_ error:Error?)->();

internal func dataTaskWith(request : URLRequest, completionHandler: @escaping NetworkRouterCompletion) {
    
    let session = URLSession.shared;
    
    let task = session.dataTask(with: request){ (data, response, error) -> Void in
        
        NetworkLogger.log(request: request);
        
        guard error == nil else {
            completionHandler(nil,error);
            return
        }
        guard let content = data else {
            return;
        }
        
        if let response = response as? HTTPURLResponse{
            
            let Result = handleRsponse(response, serverdata: content);
            
            switch Result{
            case .success:
                completionHandler(data,nil);
                break;
            case .failure(let networkFailureError):
                completionHandler(nil,networkFailureError as! Error);
                break;
            }
        }
    }
    task.resume();
}
