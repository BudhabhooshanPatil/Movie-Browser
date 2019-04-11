//
//  TMDBException.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

class TMDBException: NSObject {
    
    var statusCode:Int          = 0
    var statusMessage:String    = ""
    
    init(code:Int , message:String) {
        
        self.statusCode = code;
        self.statusMessage = message;
    }
}
