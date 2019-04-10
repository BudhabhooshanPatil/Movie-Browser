//
//  APIConnection.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit

public typealias Response = (_ data:Data? ,_ error:Error?) -> Void;

let imageBasePath = "https://image.tmdb.org/t/p/w185_and_h278_bestv2"

let API_KEY = "53eafbc1ab15fcd88324c96a958d6ca5"

let ratingsDisplay = ["★☆☆☆☆☆☆☆☆☆",
                      "★★☆☆☆☆☆☆☆☆",
                      "★★★☆☆☆☆☆☆☆",
                      "★★★★☆☆☆☆☆☆",
                      "★★★★★☆☆☆☆☆",
                      "★★★★★★☆☆☆☆",
                      "★★★★★★★☆☆☆",
                      "★★★★★★★★☆☆",
                      "★★★★★★★★★☆",
                      "★★★★★★★★★★"];

func getTopMovies(page:Int = 1 , language:String? ,completionHandler:@escaping Response) {
    
    let api = API(baseUrl: .version3, path: "movie/top_rated?page=\(page)&language=\(language ?? "en-US")&api_key=\(API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}
func getPopular(page:Int = 1 , language:String? ,completionHandler:@escaping Response){
    
    let api = API(baseUrl: .version3, path: "movie/popular?page=\(page)&language=\(language ?? "en-US")&api_key=\(API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}

func getNowPlaying(page:Int = 1 , language:String?,completionHandler:@escaping Response){
    
    let api = API(baseUrl: .version3, path: "movie/now_playing?page=\(page)&language=\(language ?? "en-US")&api_key=\(API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}

func search (page:Int = 1 , language:String?,searchText:String,completionHandler:@escaping Response){
    
    let api = API(baseUrl: .version3, path: "search/movie?page=\(page)&query=\(searchText.replacingOccurrences(of: " ", with: ""))&language=\(language ?? "en-US")&api_key=\(API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}

func findMovie(id:Int , completionHandler:@escaping Response){
    
    let api = API(baseUrl: .version3, path: "movie/\(id)?&api_key=\(API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}

func downloadImage(url:URL ,onImage:@escaping ( _ image:UIImage?)-> Void) -> Void {
    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        
        if error != nil {
            return
        }
        if let imageData = data {
            onImage(UIImage(data: imageData));
        }
        
    }).resume()
}
