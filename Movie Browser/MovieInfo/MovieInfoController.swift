//
//  InfoViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 10/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MovieInfoController: UIViewController {
    
    var viewModel: MovieInfoViewModel?
    
    lazy var contentView: MovieInfoContentView = {
        let view = MovieInfoContentView(viewModel: self.viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.setupLayouts()
    }
    
    private func setupViews() {
        self.view.addSubview(self.contentView)
        self.viewModel?.delegate = self
        
        self.viewModel?.getThePrimaryInformationAboutAmovie(aMovie: self.viewModel?.movie)
        self.viewModel?.getTheCastAndCrewForAMovie(aMovie: self.viewModel?.movie)
        self.viewModel?.getTheImagesThatBelongToAMovie(aMovie: self.viewModel?.movie)
        
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
}

extension MovieInfoController: MovieInfoViewModelDelegate {
    func didReceivedImagesForAMovie() {
        DispatchQueue.main.async {
            self.contentView.reloadMovieImagesInformation()
        }
    }
    
    func didReceivedCastAndCrewForAMovie() {
        DispatchQueue.main.async {
            self.contentView.reloadCastAndCrewInformation()
        }
    }
    
    func didReceivedPrimaryInformationAboutAmovie() {
        DispatchQueue.main.async {
            self.contentView.reloadMoviePrimaryInformation()
        }
    }
}
