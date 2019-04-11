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

private func handleRsponse (_ response:HTTPURLResponse ,serverdata:Data) -> ResultType<TMDBException> {
    
    switch response.statusCode {
    case 200...299:
        return .success
    default:
        return .failure(serverdata.exception);
    }
}
internal typealias NetworkRouterCompletion = (_ data:Data? ,_ error:TMDBException?)->();

internal func httpRequest(request : URLRequest, completionHandler: @escaping NetworkRouterCompletion) {
    
    let session = URLSession.shared;
    
    let task = session.dataTask(with: request){ (data, response, error) -> Void in
        
        Logger.log(request: request);
        
        guard error == nil else {
            return
        }
        guard let content = data else {
            return;
        }
        Logger.log(data: content);
        
        if let response = response as? HTTPURLResponse{
            
            let Result = handleRsponse(response, serverdata: content);
            
            switch Result{
            case .success:
                completionHandler(data,nil);
                break;
            case .failure(let networkFailureError):
                completionHandler(nil ,networkFailureError);
                break;
            }
        }
    }
    task.resume();
}
