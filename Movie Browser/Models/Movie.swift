//
//  Movie.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 09/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation

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
    var backdropPath: String = ""
    var adult: Bool = false
    var overview: String = ""
    var releaseDate: String = ""
    
    init(_movie:Movies.Result) {
        super.init();
        
        if let _voteCount = _movie.voteCount {
            self.voteCount = _voteCount;
        }
        if let video = _movie.video {
            self.video = video;
        }
        if let voteAverage = _movie.voteAverage {
            self.voteAverage = voteAverage;
        }
        if let title = _movie.title {
            self.title = title;
        }
        if let popularity = _movie.popularity {
            self.popularity = popularity;
        }
        if let posterPath = _movie.posterPath {
            self.posterPath = posterPath;
        }
        if let originalLanguage = _movie.originalLanguage {
            self.originalLanguage = originalLanguage;
        }
        if let originalTitle = _movie.originalTitle {
            self.originalTitle = originalTitle;
        }
        if let genreids = _movie.genreids {
            self.genreids = genreids;
        }
        if let backdropPath = _movie.backdropPath {
            self.backdropPath = backdropPath;
        }
        if let adult = _movie.adult {
            self.adult = adult;
        }
        if let overview = _movie.overview {
            self.overview = overview;
        }
        if let releaseDate = _movie.releaseDate {
            self.releaseDate = releaseDate;
        }
    }
}

