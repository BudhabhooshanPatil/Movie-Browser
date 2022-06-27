//
//  MovieDescriptionTableViewCell.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 09/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieDescriptionTableViewCell: UITableViewCell {
    
    static let identifier = "MovieDescriptionTableViewCell"
    
    let descripntionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.text = "T'Challa, heir to the hidden but advanced kingdom of Wakanda, must step forward to lead his people into a new future and must confront a challenger from his country's past."
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(self.descripntionLabel)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            self.descripntionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            self.descripntionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            self.descripntionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0),
            self.descripntionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0)
        ])
    }
}
