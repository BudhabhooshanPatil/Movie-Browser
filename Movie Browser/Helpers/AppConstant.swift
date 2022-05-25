//
//  AppConstant.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

class AppConstants:NSObject {
    
    public static let imageBase = "https://image.tmdb.org/t/p/"
        
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

struct Constants {
    enum APIDetails: String {
        case APIScheme  = "https"
        case APIKey     = "53eafbc1ab15fcd88324c96a958d6ca5"
        case APIHost    = "api.themoviedb.org/3/movie/"
    }
}
