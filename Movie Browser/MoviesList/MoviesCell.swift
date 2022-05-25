//
//  CollectionViewCell.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesCell: UICollectionViewCell {
    
    static let identifier = "\(String(describing: MoviesCell.self))"
    
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
    
    let moviePosterImage: UIImageView  = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "iconPlaceHolder")
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    let movieName: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    let movieRatings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        label.textAlignment = .left
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        return label
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
        self.imageContainer.addSubview(self.moviePosterImage)
        self.container.addSubview(self.imageContainer)
        self.container.addSubview(self.movieName)
        self.container.addSubview(self.movieRatings)
        
        self.imageContainer.layer.shadowColor = UIColor.black.cgColor
        self.imageContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.imageContainer.layer.shadowOpacity = 0.7
        self.imageContainer.layer.shadowRadius = 4.0
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
        
        // movie name label
        NSLayoutConstraint.activate([
            self.moviePosterImage.topAnchor.constraint(equalTo: self.imageContainer.topAnchor),
            self.moviePosterImage.leadingAnchor.constraint(equalTo: self.imageContainer.leadingAnchor),
            self.moviePosterImage.trailingAnchor.constraint(equalTo: self.imageContainer.trailingAnchor),
            self.moviePosterImage.bottomAnchor.constraint(equalTo: self.imageContainer.bottomAnchor)
        ])
        
        // movie name label
        NSLayoutConstraint.activate([
            self.movieName.topAnchor.constraint(equalTo: self.imageContainer.bottomAnchor, constant: 8.0),
            self.movieName.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            self.movieName.trailingAnchor.constraint(equalTo: self.container.trailingAnchor),
            self.movieName.heightAnchor.constraint(equalToConstant: 34.0)
        ])
        
        // movie ratings
        NSLayoutConstraint.activate([
            self.movieRatings.topAnchor.constraint(equalTo: self.movieName.bottomAnchor),
            self.movieRatings.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            self.movieRatings.trailingAnchor.constraint(equalTo: self.container.trailingAnchor),
            self.movieRatings.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),
            self.movieRatings.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
    
    func bind(movie:Movie?, indexPath:IndexPath) -> Void {
        guard let movie = movie else { return }
        guard let voteAverage = movie.voteAverage else { return }
        self.movieName.text = movie.title
        
        if Int(voteAverage)-1 > 0 {
            movieRatings.text = AppConstants.ratingsDisplay[Int(voteAverage) - 1]
        }
        guard let posterPath = movie.posterPath else { return }
        ApiConnections().downloadMoviePoster(imagepathType: .w185, posterPath: posterPath) { (_image) in
            DispatchQueue.main.async {
                if (self.tag == indexPath.row) {
                    self.moviePosterImage.image = _image
                }
            }
        }
    }
}
