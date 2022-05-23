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
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    class func  getTopMovies(page:Int = 1 , language:String? ,completionHandler:@escaping AppConstants.Response) {
        
        let api = API(baseUrl: .version3, path: "movie/top_rated?page=\(page)&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    class func  getPopular(page:Int = 1 , language:String? ,completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "movie/popular?page=\(page)&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    class func  getNowPlaying(page:Int = 1 , language:String?,completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "movie/now_playing?page=\(page)&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    class func  search (page:Int = 1 , language:String?,searchText:String,completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "search/movie?page=\(page)&query=\(searchText.replacingOccurrences(of: " ", with: ""))&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    class func  findMovie(id:Int , completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "movie/\(id)?&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    class func downloadMoviePoster(imagepathType:imagebasePath,
                                   posterPath:String,
                                   onImage:@escaping ( _ image:UIImage?)-> Void) -> Void {
        
        let url = AppConstants.imageBase + imagepathType.value + "\(posterPath)";
        
        if let urlString = URL(string: url) {
            if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                onImage(cacheImage);
                return
            }
            let task = URLSession.shared.dataTask(with: urlString, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                if let imageData = data, let image = UIImage(data: imageData) {
                    imageCache.setObject(image, forKey: urlString as AnyObject)
                    onImage(image);
                }
            });
            task.resume();
        }
    }
}
