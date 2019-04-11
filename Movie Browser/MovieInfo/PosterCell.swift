//
//  PosterTableViewCell.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 10/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class PosterCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.poster);
        self.poster.addSubview(self.title);
        self.poster.addSubview(self.genres);
        
        self.poster.translatesAutoresizingMaskIntoConstraints = false;
        self.title.translatesAutoresizingMaskIntoConstraints = false;
        self.genres.translatesAutoresizingMaskIntoConstraints = false;
        
        let view = ["title":self.title,"releasedDate":genres,"poster":self.poster];
        
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[poster]-|", options: [], metrics: nil, views:view );
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[poster]-|", options: [], metrics: nil, views: view);
        
        self.contentView.addConstraints(horizontal);
        self.contentView.addConstraints(vertical);
        
        let horizontal1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views:view );
        let horizontal2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[releasedDate]-|", options: [], metrics: nil, views: view);
        let vertical1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[releasedDate]-|", options: [], metrics: nil, views: view);
        
        self.poster.addConstraints(horizontal1);
        self.poster.addConstraints(horizontal2);
        self.poster.addConstraints(vertical1);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(movie:Movie?, indexPath:IndexPath) -> Void {
        
        guard let movie = movie else { return  }
        self.title.text = movie.originalTitle;
        
        if movie.genres.count > 0 {
            self.genres.text = movie.genres.joined(separator: "/");
        }
        
        ApiConnections.downloadMoviePoster(imagepathType: .w300, posterPath: movie.posterPath) { (_image) in
            
            DispatchQueue.main.async {
                if (self.tag == indexPath.row) {
                    self.poster.image = _image;
                }
            }
        }
    }
    
    lazy var poster: UIImageView = {
        
        let imageView = UIImageView();
        imageView.clipsToBounds = true;
        imageView.contentMode = .scaleToFill;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.image = UIImage(named: "iconPlaceHolder");
        imageView.layer.cornerRadius = 10.0
        return imageView;
    }();
    
    lazy var title: UILabel = {
        
        let label = UILabel();
        label.adjustsFontSizeToFitWidth = true;
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 30.0);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.textAlignment = .left
        return label;
    }()
    
    lazy var genres: UILabel = {
        
        let label = UILabel();
        label.adjustsFontSizeToFitWidth = true;
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 30.0);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .left;
        label.textColor = .white;
        return label;
    }()
    
    func date(releaseDate:String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: releaseDate) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        
        return releaseDate;
    }
}
