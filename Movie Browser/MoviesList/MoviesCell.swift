//
//  CollectionViewCell.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        viewWillAddSubViews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewWillAddSubViews() -> Void {
        
        self.contentView.addSubview(self.holderView);
        self.holderView.addSubview(self.icon);
        self.contentView.addSubview(self.name);
        self.contentView.addSubview(self.rating);
        
        let views = ["icon":self.icon , "name":self.name , "rating":rating , "holderView":self.holderView];
        
        let horizontal1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[holderView]-|", options: [], metrics: nil, views: views);
        let horizontal2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-|", options: [], metrics: nil, views: views);
        let horizontal3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[rating]-|", options: [], metrics: nil, views: views);
        let vertical1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[holderView]-[name(20)]-[rating(20)]-|", options: [], metrics: nil, views: views);
        
        self.contentView.addConstraints(horizontal1);
        self.contentView.addConstraints(horizontal2);
        self.contentView.addConstraints(horizontal3);
        self.contentView.addConstraints(vertical1);
        
        let horizontal4 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[icon]|", options: [], metrics: nil, views: views);
        let vertical2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[icon]|", options: [], metrics: nil, views: views);
        
        self.holderView.addConstraints(horizontal4);
        self.holderView.addConstraints(vertical2);
        
    }
    
    lazy var holderView: UIView = {
        let view = UIView();
        view.layer.cornerRadius = 10.0;
        view.translatesAutoresizingMaskIntoConstraints = false;
        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        return view;
    }();
    
    let icon: UIImageView  = {
        
        let imageView = UIImageView(frame: .zero);
        imageView.clipsToBounds = true;
        imageView.contentMode = .scaleAspectFill;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.image = UIImage(named: "iconPlaceHolder");
        imageView.layer.cornerRadius = 10.0
        return imageView;
    }()
    
    let name: UILabel  = {
        
        let label = UILabel();
        label.adjustsFontSizeToFitWidth = true;
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 14.0);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        return label;
    }()
    
    let rating: UILabel = {
        
        let label = UILabel();
        label.adjustsFontSizeToFitWidth = true;
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 18.0);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .left;
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1);
        return label;
    }()
    
    func bind(movie:Movie , indexPath:IndexPath) -> Void {
        
        name.text = movie.title;
        
        print(Int(movie.voteAverage));
        
        if Int(movie.voteAverage)-1 > 0 {
            
            rating.text = AppConstants.ratingsDisplay[Int(movie.voteAverage) - 1] ;
        }
        
        ApiConnections.downloadMoviePoster(imagepathType: .w185, posterPath: movie.posterPath) { (_image) in
            
            DispatchQueue.main.async {
                
                if (self.tag == indexPath.row) {
                    
                    self.icon.image = _image;
                }
            }
        }
    }
}
