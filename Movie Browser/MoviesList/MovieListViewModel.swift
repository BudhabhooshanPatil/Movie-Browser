//
//  MovieListViewModel.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 12/05/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func didReceivedCurrentPopularMovies()
}

class MovieListViewModel: NSObject {
    
    public var moviesArray: [Movie] = []
    public weak var delegate: MovieListViewModelDelegate?
    
    /// load movies in theater
    func nowPlayingMovies() -> Void {
        
        ApiConnections.getNowPlaying(language: nil) { (data, error) in
            
            if let data = data{
                do{
                    let result = try JSONDecoder().decode(ResultElement.self, from: data);
                    DispatchQueue.main.async {
                        self.moviesArray.append(contentsOf: result.Movies ?? [])
                        self.delegate?.didReceivedCurrentPopularMovies()
                    }
                }catch{
                    Logger.print(items: error);
                }
            }else{
                if let error = error {
                    Logger.print(items: error.statusMessage);
                }
            }
        }
    }
}
