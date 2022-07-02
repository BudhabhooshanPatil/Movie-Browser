//
//  MoviesViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesListController: UIViewController{
    
    let viewModel = MovieListViewModel()
    
    lazy var contentView: MovieListView = {
        let view = MovieListView(viewModel: self.viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupLayouts()
        self.setupNavigationBar()
        self.viewModel.delegate = self
        self.viewModel.popular().load()
    }
    
    private func setupViews() {
        self.view.addSubview(self.contentView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem(title: "Switch", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc fileprivate func menuButtonTapped() {
        
        // TODO: optimize
        let popularHandler = { [weak self] (alertAction: UIAlertAction) -> Void in
            self?.contentView.collectionViewBackground.startAnimating()
            self?.viewModel.popular().load(shouldReset: true)
        }
        
        let upComingHandler = { [weak self] (alertAction: UIAlertAction) -> Void in
            self?.contentView.collectionViewBackground.startAnimating()
            self?.viewModel.upComing().load(shouldReset: true)
        }
        
        let topRatedHandler = { [weak self] (alertAction: UIAlertAction) -> Void in
            self?.contentView.collectionViewBackground.startAnimating()
            self?.viewModel.topRated().load(shouldReset: true)
        }
        
        let nowPlayingHandler = { [weak self] (alertAction: UIAlertAction) -> Void in
            self?.contentView.collectionViewBackground.startAnimating()
            self?.viewModel.nowPlaying().load(shouldReset: true)
        }
        
        let cancelHandler = {(alertAction: UIAlertAction) -> Void in
            // do nothing
        }
        
        // TODO: localization
        AppAlertBuilder(viewController: self)
            .withTitle("Select")
            .preferredStyle(.actionSheet)
            .onCustomAction(title: "Popular", popularHandler)
            .onCustomAction(title: "Now Playing", nowPlayingHandler)
            .onCustomAction(title: "Upcoming", upComingHandler)
            .onCustomAction(title: "Top Rated", topRatedHandler)
            .onCancelAction(title: "Cancel", cancelHandler)
            .show()
    }
    
    
    private func displayError(error: TMDBException) {
        
        let successHandler = { [weak self] (alertAction: UIAlertAction) -> Void in
            self?.viewModel.popular().load()
        }
        
        let cancelHandler = {(alertAction: UIAlertAction) -> Void in
            // do nothing
        }
        
        // TODO: localization
        AppAlertBuilder(viewController: self)
            .withTitle("An error occured")
            .andMessage(error.localizedDescription)
            .onSuccessAction(title: "Retry", successHandler)
            .onCancelAction(title: "Cancel", cancelHandler)
            .show()
    }
}

extension MoviesListController: MovieListViewModelDelegate {
    
    func didReceivedError(error: TMDBException) {
        self.contentView.collectionViewBackground.stopAnimating()
        self.contentView.loadingMoreView?.stopAnimating()
        self.displayError(error: error)
    }
    
    func didReceivedMovies() {
        self.contentView.reload()
        self.contentView.collectionViewBackground.stopAnimating()
        self.contentView.loadingMoreView?.stopAnimating()
    }
    
    // TODO: co-ordinator
    func didSelectItemAt(indexPath: IndexPath) {
        let controller = MovieInfoController()
        let viewModel = MovieInfoViewModel(connection: ApiConnections())
        viewModel.movie = self.viewModel.moviesArray[indexPath.row]
        controller.viewModel = viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
