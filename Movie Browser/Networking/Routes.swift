//
//  Routes.swift
//  HeadyProject
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

internal enum Host {
    
    case version3
    case version4
}

internal enum Routes{
    
    case version_3
    case version_4
    case popolar
    case top_rated
    
    var value:String {
        
        switch self {
            
        case .version_3:
            return "https://api.themoviedb.org/3/"
        case .version_4:
            return "https://api.themoviedb.org/4/movie/"
        case .popolar:
            return "popular"
        case .top_rated:
            return "top_rated"
        }
    }
}
