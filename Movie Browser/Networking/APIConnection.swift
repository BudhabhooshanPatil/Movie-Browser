//
//  APIConnection.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit


class ApiConnections {
    
    private var imageCache = NSCache<AnyObject, AnyObject>()
    
    private let httpRequest = HttpRequest()
    
    public func getNowPlaying<T: Codable>(currentPage: Int = 1,
                                          completion: @escaping (Result<T, TMDBException>) -> Void) {
        
        let queryParams = [ URLQueryItem(name: "page", value: "\(currentPage)")]
        
        let sendRequest = API(path: MovieEndpoint.nowPlaying.rawValue, httpMethod: .get,queryItems: queryParams).buildRequest
        httpRequest.dataTask(request: sendRequest) { (response: Result<T, TMDBException>) in
            completion(response)
        }
    }
    
    public func downloadMoviePoster(imagepathType: ImagebasePath,
                                    posterPath:String,
                                    onImage:@escaping ( _ image:UIImage?)-> Void) -> Void {
        
        let url = AppConstants.imageBase + imagepathType.rawValue + "\(posterPath)";
        
        if let urlString = URL(string: url) {
            
            if let cacheImage = self.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                onImage(cacheImage);
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlString, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.imageCache.setObject(image, forKey: urlString as AnyObject)
                    onImage(image);
                }
                
            });
            task.resume();
        }
    }
}
