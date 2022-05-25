//
//  MoviesViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesListController: UIViewController{
    
    // view-model
    let viewModel = MovieListViewModel()
    
    // view with view-model dependancy injection
    lazy var contentView: MovieListView = {
        let view = MovieListView(viewModel: self.viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add content-view as subview in view
        self.view.addSubview(self.contentView)
        
        // set-up user interface constraints as no storyboard
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.viewModel.delegate = self
        self.viewModel.loadNowPlayingMovies()
    }
    
    private func displayError(error: TMDBException) {
        let alert = UIAlertController(
            title: "An error occured",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default
        ))
        
        alert.addAction(UIAlertAction(
            title: "Retry",
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel.loadNowPlayingMovies()
            }
        ))
        
        self.present(alert, animated: true)
    }
}

extension MoviesListController: MovieListViewModelDelegate {
    
    func didReceivedError(error: TMDBException) {
        self.contentView.collectionViewBackground?.stopAnimating()
        self.contentView.loadingMoreView?.stopAnimating()
        self.displayError(error: error)
    }
    
    func didReceivedCurrentPopularMovies() {
        self.contentView.reload()
        self.contentView.collectionViewBackground?.stopAnimating()
        self.contentView.loadingMoreView?.stopAnimating()
    }
}
