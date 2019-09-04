//
//  Movie.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

enum MovieType {
    
    case topRated
    case popular
    case nowPlaying
    case searching
    
    
}

class Movie: NSObject {
    
    var voteCount: Int = 0
    var id: Int = 0
    var video: Bool = false
    var voteAverage: Double = 0.0
    var title: String = ""
    var popularity: Double = 0.0
    var posterPath: String = ""
    var originalLanguage: String = ""
    var originalTitle: String = ""
    var genreids: [Int] = []
    var genres:[String] = [];
    
    var backdropPath: String = ""
    var adult: Bool = false
    var overview: String = ""
    var releaseDate: String = ""
    
    init(model:Movies.Result) {
        super.init();
        
        if let _voteCount = model.voteCount {
            self.voteCount = _voteCount;
        }
        if let id = model.id {
            self.id = id;
        }
        if let video = model.video {
            self.video = video;
        }
        if let voteAverage = model.voteAverage {
            self.voteAverage = voteAverage;
        }
        if let title = model.title {
            self.title = title;
        }
        if let popularity = model.popularity {
            self.popularity = popularity;
        }
        if let posterPath = model.posterPath {
            self.posterPath = posterPath;
        }
        if let originalLanguage = model.originalLanguage {
            self.originalLanguage = originalLanguage;
        }
        if let originalTitle = model.originalTitle {
            self.originalTitle = originalTitle;
        }
        if let genreids = model.genreids {
            self.genreids = genreids;
        }
        if let backdropPath = model.backdropPath {
            self.backdropPath = backdropPath;
        }
        if let adult = model.adult {
            self.adult = adult;
        }
        if let overview = model.overview {
            self.overview = overview;
        }
        if let releaseDate = model.releaseDate {
            self.releaseDate = releaseDate;
        }
        if let geners = model.genres {
            
            for item in geners {
                self.genres.append(item.name);
            }
        }
    }
}

