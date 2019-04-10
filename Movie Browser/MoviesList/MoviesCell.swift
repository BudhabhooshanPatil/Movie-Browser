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
        
        self.contentView.addSubview(icon);
        self.contentView.addSubview(name);
        
        let views = ["icon":icon , "name":name];
        
        let horizontal1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[icon]|", options: [], metrics: nil, views: views);
        let horizontal2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-|", options: [], metrics: nil, views: views);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[icon]-[name]-|", options: [], metrics: nil, views: views);
        
        self.contentView.addConstraints(horizontal1);
        self.contentView.addConstraints(horizontal2);
        self.contentView.addConstraints(vertical);
    }
    
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
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        return label;
    }()
    
    public func bind(movie:Movie , indexPath:IndexPath) -> Void {
        name.text = movie.title;
        downloadImage(url: URL(string: MoviesListController.imageBasePath + movie.posterPath)!) { (_image) in
            
            DispatchQueue.main.async {
                if (self.tag == indexPath.row) {
                    self.icon.image = _image;
                }
            }
        }
    }
}
