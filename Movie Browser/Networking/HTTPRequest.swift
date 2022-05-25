//
//  HTTPRequest.swift
//  HeadyProject
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

struct HttpRequest {
        
    public func dataTask<T: Codable>(request : URLRequest,
                                     completionHandler: @escaping (Result<T, TMDBException>) -> Void) {
                
        Logger.log(request: request)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) -> Void in
            if let error = error {
                let error = TMDBException(code: 1, localizedDescription: error.localizedDescription)
                completionHandler(.failure(error))
                return
            }
            
            guard let content = data, let response = response as? HTTPURLResponse else { return }

            switch self.handleURLResponse(response, content: content) {
            case .success(_):
                do {
                    completionHandler(.success(try JSONDecoder().decode(T.self, from: content)))
                } catch {
                    let error = TMDBException(code: 1, localizedDescription: error.localizedDescription)
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
    
    private func handleURLResponse (_ response:HTTPURLResponse, content: Data) -> Result<Bool, TMDBException> {
        
        switch response.statusCode {
        case 200...299:
            return .success(true)
        default:
            return .failure(content.exception)
        }
    }
}
