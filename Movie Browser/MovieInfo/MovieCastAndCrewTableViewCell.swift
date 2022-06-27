//
//  MovieCastAndCrewTableViewCell.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 09/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieCastAndCrewTableViewCell: UITableViewCell {
    
    static let identifier = "MovieCastAndCrewTableViewCell"
    private var cast:[Cast] = []
    private var movieImages:[MovieImagesResult] = []
    
    lazy var collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        let collectionview = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.alwaysBounceVertical = false
        collectionview.backgroundColor = .white
        collectionview.register(MovieCastAndCrewCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCastAndCrewCollectionViewCell.identifier)
        return collectionview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.collectionView)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 260.0)
        ])
    }
    
    public func configurationFor(cast:[Cast]?) {
        guard let cast = cast, cast.count != 0 else { return }
        self.cast = cast
        self.collectionView.reloadData()
    }
    
    public func configurationFor(movieImages:[MovieImagesResult]?) {
        guard let movieImages = movieImages, movieImages.count != 0 else { return }
        self.movieImages = movieImages
        self.collectionView.reloadData()
    }
}

extension MovieCastAndCrewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCastAndCrewCollectionViewCell.identifier,
                                                         for: indexPath) as? MovieCastAndCrewCollectionViewCell {
            cell.tag = indexPath.row
            cell.bind(castAndCrew: cast[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension MovieCastAndCrewTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MovieCastAndCrewTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 260.0 - (2 * 8.0))
    }
}
