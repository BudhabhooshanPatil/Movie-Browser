//
//  APIConnection.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit

class AppConstants {
    
    public typealias Response = (_ data:Data? ,_ error:Error?) -> Void;
    
    public static let imageBase = "https://image.tmdb.org/t/p/"
    
    public static let  API_KEY = "53eafbc1ab15fcd88324c96a958d6ca5"
    
    public static let ratingsDisplay = ["★☆☆☆☆☆☆☆☆☆",
                                        "★★☆☆☆☆☆☆☆☆",
                                        "★★★☆☆☆☆☆☆☆",
                                        "★★★★☆☆☆☆☆☆",
                                        "★★★★★☆☆☆☆☆",
                                        "★★★★★★☆☆☆☆",
                                        "★★★★★★★☆☆☆",
                                        "★★★★★★★★☆☆",
                                        "★★★★★★★★★☆",
                                        "★★★★★★★★★★"];
}

class ApiConnections {
    
    static func  getTopMovies(page:Int = 1 , language:String? ,completionHandler:@escaping AppConstants.Response) {
        
        let api = API(baseUrl: .version3, path: "movie/top_rated?page=\(page)&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    static func  getPopular(page:Int = 1 , language:String? ,completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "movie/popular?page=\(page)&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    static func  getNowPlaying(page:Int = 1 , language:String?,completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "movie/now_playing?page=\(page)&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    static func  search (page:Int = 1 , language:String?,searchText:String,completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "search/movie?page=\(page)&query=\(searchText.replacingOccurrences(of: " ", with: ""))&language=\(language ?? "en-US")&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    static func  findMovie(id:Int , completionHandler:@escaping AppConstants.Response){
        
        let api = API(baseUrl: .version3, path: "movie/\(id)?&api_key=\(AppConstants.API_KEY)", httpMethod: .get).buildRequest;
        
        httpRequest(request: api) { (data, error) in
            completionHandler(data,error);
        };
    }
    
    static func downloadMoviePoster(imagepathType:imagebasePath,posterPath:String,onImage:@escaping ( _ image:UIImage?)-> Void) -> Void {
        
        var url = AppConstants.imageBase;
        switch imagepathType {
            
        case .w185:
            url = url + "w185"+"/\(posterPath)"
            break;
        case .w300:
            url = url + "w300"+"/\(posterPath)"
            break
        }
        if let imageURL = URL(string: url) {
            
            URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    return
                }
                if let imageData = data {
                    onImage(UIImage(data: imageData));
                }
                
            }).resume()
            
        }
    }
}
