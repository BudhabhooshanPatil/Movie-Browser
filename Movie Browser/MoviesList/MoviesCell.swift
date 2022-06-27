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
        label.font =  UIFont(name: "HelveticaNeue-Bold", size: 11.0)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        label.numberOfLines = 3
        return label
    }()
    
    let movieReleaseDate: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 11.0)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        label.numberOfLines = 2
        return label
    }()
    
    let movieRatings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 10.0)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.movieName, self.movieReleaseDate, self.movieRatings])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
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
        
        // movie name label
        NSLayoutConstraint.activate([
            self.moviePosterImage.topAnchor.constraint(equalTo: self.imageContainer.topAnchor),
            self.moviePosterImage.leadingAnchor.constraint(equalTo: self.imageContainer.leadingAnchor),
            self.moviePosterImage.trailingAnchor.constraint(equalTo: self.imageContainer.trailingAnchor),
            self.moviePosterImage.bottomAnchor.constraint(equalTo: self.imageContainer.bottomAnchor)
        ])
        
        // movie name label
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.imageContainer.bottomAnchor, constant: 8.0),
            self.stackView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor)
        ])
     
        for item in self.stackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                item.heightAnchor.constraint(greaterThanOrEqualToConstant: 14.0)
            ])
        }
    }
    
    func bind(movie:Movie?, indexPath:IndexPath) -> Void {
        guard let movie = movie else { return }
        guard let voteAverage = movie.voteAverage else { return }
        self.movieName.text = movie.title
        self.movieRatings.text = "★" + " \(voteAverage)"
        self.movieReleaseDate.text = movie.releaseDate
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
