//
//  File.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height) + 32.0
    }
}
extension Data {
    
    var exception:TMDBException {
        do {
            let serverError = try JSONDecoder().decode(TMDBError.self, from: self);
            return TMDBException(code: serverError.statusCode, message: serverError.statusMessage);
        } catch  {
            return TMDBException(code: 0, message: error.localizedDescription);
        }
    }
}
