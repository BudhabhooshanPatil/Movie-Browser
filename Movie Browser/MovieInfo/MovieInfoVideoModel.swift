//
//  MovieInfoVideoModel.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 02/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import Foundation

protocol MovieInfoViewModelDelegate: AnyObject {
    func didReceivedPrimaryInformationAboutAmovie()
    func didReceivedCastAndCrewForAMovie()
    func didReceivedImagesForAMovie()
}

class MovieInfoViewModel {
    
    public var delegate: MovieInfoViewModelDelegate? = nil
    private let connection: ApiConnections?
    public typealias PrimaryInformationType = (Result<MoviePrimaryInformationResult, TMDBException>)
    public typealias CastType = (Result<MovieCastResult, TMDBException>)
    public typealias MovieImagesType = (Result<MovieImagesResult, TMDBException>)
    
    public var moviePrimaryInformationResult: MoviePrimaryInformationResult?
    public var movieCastResult: MovieCastResult?
    public var movieImagesResult: MovieImagesResult?
    
    public var movie = Movie()
    
    public init(connection: ApiConnections) {
        self.connection = connection
    }
    
    public func getThePrimaryInformationAboutAmovie(aMovie: Movie?) -> Void {
        self.connection?.getThePrimaryInformationAboutAmovie(aMovie: aMovie, completion: { (response: PrimaryInformationType) in
            switch response {
            case .success(let result):
                self.moviePrimaryInformationResult = result
                self.delegate?.didReceivedPrimaryInformationAboutAmovie()
            case .failure(let failure):
                break
            }
        })
    }
    
    // Get the images that belong to a movie
    public func getTheImagesThatBelongToAMovie(aMovie: Movie?) -> Void {
        self.connection?.getTheImagesThatBelongToAMovie(aMovie: aMovie, completion: { (response: MovieImagesType) in
            switch response {
            case .success(let result):
                self.movieImagesResult = result
                self.delegate?.didReceivedImagesForAMovie()
            case .failure(let failure):
                break
            }
        })
    }
    
    public func getTheCastAndCrewForAMovie(aMovie: Movie?) -> Void {
        self.connection?.getTheCastAndCrewForAMovie(aMovie: aMovie, completion: { (response: CastType) in
            switch response {
            case .success(let result):
                self.movieCastResult = result
                self.delegate?.didReceivedCastAndCrewForAMovie()
            case .failure(let failure):
                break
            }
        })
    }
}
