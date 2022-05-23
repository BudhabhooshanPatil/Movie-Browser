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
        self.viewModel.nowPlayingMovies()
    }
}

extension MoviesListController: MovieListViewModelDelegate {
    func didReceivedCurrentPopularMovies() {
        self.contentView.reload()
    }
}
