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
    
    func toDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let formatedStringDate = dateFormatter.string(from: dt)
            return formatedStringDate
        }
        return nil
    }
}

extension Data {
    
    var exception:TMDBException {
        do {
            let serverError = try JSONDecoder().decode(TMDBError.self, from: self);
            return TMDBException(code: serverError.statusCode, localizedDescription: serverError.statusMessage)
        } catch  {
            return TMDBException(code: 0, localizedDescription: error.localizedDescription)
        }
    }
}

extension Date {
    func toString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}
