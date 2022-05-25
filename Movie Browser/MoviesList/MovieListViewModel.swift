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
    func didReceivedError(error: TMDBException)
}

class MovieListViewModel: NSObject {
    
    public var moviesArray: [Movie] = []
    public weak var delegate: MovieListViewModelDelegate?
    private let connection = ApiConnections()
    public var loading = false
    private var currentPage = 0
    private var totalPages = Int.max
    private typealias ResponseType = (Result<ResultElement, TMDBException>)
    
    /// load movies in theater
    public func loadNowPlayingMovies() {
        self.loading = true
        self.getMoviesFromServer { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.moviesArray.append(contentsOf: result.movies ?? [])
                self.delegate?.didReceivedCurrentPopularMovies()
                self.loading = false
            case .failure(let error):
                self.delegate?.didReceivedError(error: error)
                self.loading = false
            }
        }
    }
    
    private func getMoviesFromServer(completion: @escaping (ResponseType) -> Void) {
        
        guard self.currentPage < self.totalPages else { return }
        self.currentPage += 1
        connection.getNowPlaying(currentPage: currentPage) { (response: ResponseType) in
            DispatchQueue.main.async {
                switch response {
                case .success(let result):
                    self.currentPage = result.page ?? 0
                    self.totalPages = result.totalPages ?? Int.max
                    completion(.success(result))
                case .failure(let failure):
                    completion(.failure(failure))
                    self.loading = false
                }
            }
        }
    }
}
