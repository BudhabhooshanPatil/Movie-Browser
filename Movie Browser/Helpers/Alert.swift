//
//  Alert.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 01/07/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit

//  title, message and style
struct AppAlertProperties {
    var title: String?
    var message: String?
    var preferredStyle: UIAlertController.Style = .alert
}

// alert action handler
struct AppAlertActionProperties {
    var title: String?
    var alertActionStyle: UIAlertAction.Style = .default
    var action: ((UIAlertAction) -> Void)?
}

public final class AppAlertBuilder {
    private let viewController: UIViewController
    private var alertProperties = AppAlertProperties()
    private var alertActionSuccessProperties = AppAlertActionProperties()
    private var alertActionCancelProperties = AppAlertActionProperties()
    private var onSuccess: ((UIAlertAction) -> Void)?
    private var onCancel: ((UIAlertAction) -> Void)?
    private var customActions:[AppAlertActionProperties] = []
    private var alertContext: UIAlertController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func withTitle(_ title: String) -> AppAlertBuilder {
        alertProperties.title = title
        return self
    }
    
    public func andMessage(_ message: String) -> AppAlertBuilder {
        alertProperties.message = message
        return self
    }
    
    public func preferredStyle(_ style: UIAlertController.Style) -> AppAlertBuilder {
        alertProperties.preferredStyle = style
        return self
    }
    
    public func onSuccessAction(title: String, _ onSuccess: @escaping ((UIAlertAction) -> Void)) -> AppAlertBuilder {
        alertActionSuccessProperties.title = title
        self.onSuccess = onSuccess
        return self
    }
    
    public func onCancelAction(title: String, _ onCancel: @escaping ((UIAlertAction) -> Void)) -> AppAlertBuilder {
        alertActionCancelProperties.title = title
        self.onCancel = onCancel
        return self
    }
    
    public func onCustomAction(title: String, _ onCustomAction: @escaping ((UIAlertAction) -> Void)) -> AppAlertBuilder {
        let customAction = AppAlertActionProperties(title: title, alertActionStyle: .default, action: onCustomAction)
        self.customActions.append(customAction)
        return self
    }
    
    // 'UIAlertController must have a title, a message or an action to display'
    @discardableResult
    public func show() -> UIAlertController {
        
        let alert = UIAlertController(title: alertProperties.title, message: alertProperties.message, preferredStyle: alertProperties.preferredStyle)
        
        if let onSuccess = onSuccess {
            alert.addAction(.init(title: alertActionSuccessProperties.title, style: alertActionSuccessProperties.alertActionStyle, handler: onSuccess))
        }
        
        if let onCancel = onCancel {
            alert.addAction(.init(title: alertActionCancelProperties.title, style: .cancel, handler: onCancel))
        }
        
        for item in self.customActions {
            alert.addAction(.init(title: item.title, style: item.alertActionStyle, handler: item.action))
        }
        
        viewController.present(alert, animated: true, completion: nil)
        self.alertContext = alert
        return alert
    }
    
    public func dismiss() -> Void {
        self.alertContext?.dismiss(animated: true)
    }
}
