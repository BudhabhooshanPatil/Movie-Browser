//
//  APIConnection.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

public typealias Response = (_ data:Data? ,_ error:Error?) -> Void;

func getTopMovies(page:Int = 1 , language:String? ,completionHandler:@escaping Response) {
    
    let api = API(baseUrl: .version3, path: "movie/top_rated?page=\(page)&language=\(language ?? "en-US")&api_key=\(MoviesViewController.API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}
func getPopular(page:Int = 1 , language:String? ,completionHandler:@escaping Response){
    
    let api = API(baseUrl: .version3, path: "movie/popular?page=\(page)&language=\(language ?? "en-US")&api_key=\(MoviesViewController.API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}
func search (page:Int = 1 , language:String?,searchText:String,completionHandler:@escaping Response){
    
    let api = API(baseUrl: .version3, path: "search/movie?page=\(page)&query=\(searchText.replacingOccurrences(of: " ", with: ""))&language=\(language ?? "en-US")&api_key=\(MoviesViewController.API_KEY)", httpMethod: .get).buildRequest;
    
    httpRequest(request: api) { (data, error) in
        completionHandler(data,error);
    };
}
