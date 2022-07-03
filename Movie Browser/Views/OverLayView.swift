//
//  OverLayView.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 03/07/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class OverLayView: UIView {
    
    static var sharedInstance = OverLayView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()
    
    
    private func setup() {
        self.setupViews()
        self.setupLayouts()
    }
    
    func setupViews() {
        self.addSubview(self.container)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.container.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    deinit {
        debugPrint("deinit \(NSStringFromClass(OverLayView.self))")
    }
}
