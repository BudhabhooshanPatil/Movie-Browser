//
//  MovieInfoTopNameTableViewCell.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 09/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieInfoTopNameTableViewCell: UITableViewCell {
    
    static let identifier = "MovieInfoTopNameTableViewCell"
    
    let titleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Poppins-Medium", size: 24.0)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Regular", size: 14.0)
        return label
    }()
    
    let productionCompaniesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 14.0)
        label.textAlignment = .center
        return label
    }()
    
    let spokenLanguagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleNameLabel,self.releaseDateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.productionCompaniesLabel,self.spokenLanguagesLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.topStackView,self.bottomStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20.0
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.stackView)
    }
    
    public func configure(moviePrimaryInformationResult:MoviePrimaryInformationResult?) {
        self.titleNameLabel.text = moviePrimaryInformationResult?.originalTitle
        self.releaseDateLabel.text = moviePrimaryInformationResult?.releaseDate?.toDate()
        self.productionCompaniesLabel.text = moviePrimaryInformationResult?.productionCompanies?[0].name
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 48.0),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
