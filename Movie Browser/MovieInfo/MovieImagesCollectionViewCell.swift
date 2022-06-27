//
//  MovieImagesCollectionViewCell.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 27/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieImagesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieImagesCollectionViewCell"
    
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
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 10.0
        return imageView
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
            self.imageContainer.bottomAnchor.constraint(equalTo: self.container.bottomAnchor)
        ])
        
        // image
        NSLayoutConstraint.activate([
            self.posterImage.topAnchor.constraint(equalTo: self.imageContainer.topAnchor),
            self.posterImage.leadingAnchor.constraint(equalTo: self.imageContainer.leadingAnchor),
            self.posterImage.trailingAnchor.constraint(equalTo: self.imageContainer.trailingAnchor),
            self.posterImage.bottomAnchor.constraint(equalTo: self.imageContainer.bottomAnchor)
        ])
    }
    
    public func bind(backdrop:Backdrop?, indexPath:IndexPath) {
        
        guard let profilePath = backdrop?.filePath else {
            self.posterImage.image = UIImage(named: "logo")
            return
        }
        
        ApiConnections().downloadMoviePoster(imagepathType: .w500, posterPath: profilePath) { (_image) in
            DispatchQueue.main.async {
                if (self.tag == indexPath.row) {
                    self.posterImage.image = _image
                }
            }
        }
    }
}
