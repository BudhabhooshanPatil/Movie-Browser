//
//  MovieListViewModel.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 12/05/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func didReceivedMovies()
    func didReceivedError(error: TMDBException)
    func didSelectItemAt(indexPath: IndexPath)
}

class MovieListViewModel: NSObject {
    
    public var moviesArray: [Movie] = []
    public weak var delegate: MovieListViewModelDelegate?
    private let connection = ApiConnections()
    public var loading = false
    private var currentPage = 0
    private var totalPages = Int.max
    private typealias ResponseType = (Result<ResultElement, TMDBException>)
    
    private var request: URLRequest?
    
    private var queryParams: [URLQueryItem] {
        return [URLQueryItem(name: "page", value: "\(self.currentPage + 1)")]
    }
    
    public func popular() -> MovieListViewModel {
        self.request = API(path: MovieEndpoint.popular.rawValue, httpMethod: .get,queryItems: self.queryParams).buildRequest
        return self
    }
    
    public func nowPlaying() -> MovieListViewModel {
        self.request = API(path: MovieEndpoint.nowPlaying.rawValue, httpMethod: .get,queryItems: self.queryParams).buildRequest
        return self
    }
    
    public func upComing() -> MovieListViewModel {
        self.request = API(path: MovieEndpoint.upcoming.rawValue, httpMethod: .get,queryItems: self.queryParams).buildRequest
        return self
    }
    
    public func topRated() -> MovieListViewModel {
        self.request = API(path: MovieEndpoint.topRated.rawValue, httpMethod: .get,queryItems: self.queryParams).buildRequest
        return self
    }
    
    public func reset(){
        self.moviesArray = []
        self.currentPage = 0
    }
    
    public func load(shouldReset:Bool = false) {
        if shouldReset {
            self.reset()
        }
        
        self.loadMovies { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.moviesArray.append(contentsOf: result.movies ?? [])
                self.loading = false
                self.delegate?.didReceivedMovies()
            case .failure(let error):
                self.delegate?.didReceivedError(error: error)
                self.loading = false
            }
        }
    }
    
    private func loadMovies(completion: @escaping (ResponseType) -> Void) {
        self.getMovies { (response: ResponseType) in
            DispatchQueue.main.async {
                switch response {
                case .success(let result):
                    self.currentPage = result.page ?? 0
                    self.totalPages = result.totalPages ?? Int.max
                    completion(.success(result))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
    
    private func getMovies(completion: @escaping (ResponseType) -> Void) {
        
        guard let request = self.request, self.currentPage < self.totalPages else {
            completion(.failure(TMDBException(code: 0, localizedDescription: "currentPage == totalPages")))
            return
        }
        
        self.connection.loadRequest(request: request, completionHandler: completion)
    }
}
