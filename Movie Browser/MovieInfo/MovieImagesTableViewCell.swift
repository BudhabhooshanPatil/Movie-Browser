//
//  MovieImagesTableViewCell.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 27/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieImagesTableViewCell: UITableViewCell {
    
    static let identifier = "MovieImagesTableViewCell"
    private var movieImagesbackdrop: [Backdrop] =  []
    
    lazy var collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        let collectionview = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.alwaysBounceVertical = false
        collectionview.backgroundColor = .white
        collectionview.register(MovieImagesCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieImagesCollectionViewCell.identifier)
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
            self.collectionView.heightAnchor.constraint(equalToConstant: 220.0)
        ])
    }
    
    public func configurationFor(movieImagesbackdrop:[Backdrop]?) {
        guard let movieImagesbackdrop = movieImagesbackdrop, movieImagesbackdrop.count != 0 else { return }
        self.movieImagesbackdrop = movieImagesbackdrop
        self.collectionView.reloadData()
    }
}

extension MovieImagesTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieImagesbackdrop.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieImagesCollectionViewCell.identifier,
                                                         for: indexPath) as? MovieImagesCollectionViewCell {
            cell.tag = indexPath.row
            cell.bind(backdrop: self.movieImagesbackdrop[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension MovieImagesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MovieImagesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300.0, height: 220.0 - (2 * 8.0))
    }
}
