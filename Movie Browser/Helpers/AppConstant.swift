//
//  AppConstant.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

class AppConstants:NSObject {
    
    public typealias Response = (_ data:Data? ,_ error:TMDBException?) -> Void;
    
    public static let imageBase = "https://image.tmdb.org/t/p/"
    
    public static let API_KEY = "53eafbc1ab15fcd88324c96a958d6ca5"
    
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
