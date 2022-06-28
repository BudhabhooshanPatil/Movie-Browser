//
//  MovieCastAndCrewCollectionViewCell.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 09/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieCastAndCrewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCastAndCrewCollectionViewCell"

    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let posterImage: UIImageView  = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    lazy var originalName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        return label
    }()
    
    lazy var knownForDepartment: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var characterPlayed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.originalName,self.knownForDepartment,self.characterPlayed])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() -> Void {
        self.contentView.addSubview(self.container)
        self.imageContainer.addSubview(self.posterImage)
        self.container.addSubview(self.imageContainer)
        self.container.addSubview(self.stackView)

        self.imageContainer.layer.shadowColor = UIColor.darkGray.cgColor
        self.imageContainer.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.imageContainer.layer.shadowOpacity = 0.5
        self.imageContainer.layer.shadowRadius = 2.0
    }
    
    private func setupLayouts() {
        
        // whole container
        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        // image container
        NSLayoutConstraint.activate([
            self.imageContainer.topAnchor.constraint(equalTo: self.container.topAnchor),
            self.imageContainer.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            self.imageContainer.trailingAnchor.constraint(equalTo: self.container.trailingAnchor),
        ])
        
        // image
        NSLayoutConstraint.activate([
            self.posterImage.topAnchor.constraint(equalTo: self.imageContainer.topAnchor),
            self.posterImage.leadingAnchor.constraint(equalTo: self.imageContainer.leadingAnchor),
            self.posterImage.trailingAnchor.constraint(equalTo: self.imageContainer.trailingAnchor),
            self.posterImage.bottomAnchor.constraint(equalTo: self.imageContainer.bottomAnchor)
        ])
        
        // stack container
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.imageContainer.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.imageContainer.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.imageContainer.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.originalName.heightAnchor.constraint(equalToConstant: (22.0)),
            self.knownForDepartment.heightAnchor.constraint(equalToConstant: (22.0)),
            self.characterPlayed.heightAnchor.constraint(equalToConstant: (2 * 22.0))
        ])
    }
    
    public func bind(castAndCrew:Cast, indexPath:IndexPath) {
        
        self.originalName.text = castAndCrew.originalName
        self.knownForDepartment.text = castAndCrew.knownForDepartment
        self.characterPlayed.text = castAndCrew.character
        
        guard let profilePath = castAndCrew.profilePath else {
            self.posterImage.image = UIImage(named: "logo")
            return
        }
        
        ApiConnections().downloadMoviePoster(imagepathType: .w300, posterPath: profilePath) { (_image) in
            DispatchQueue.main.async {
                if (self.tag == indexPath.row) {
                    self.posterImage.image = _image
                }
            }
        }
    }
}
