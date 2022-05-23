//
//  MovieListView.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 12/05/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieListView: UIView {
	
	var viewModel: MovieListViewModel?
	
	let collectionView: UICollectionView = {
		let collectionview = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
		collectionview.translatesAutoresizingMaskIntoConstraints = false
		collectionview.alwaysBounceVertical = true
		collectionview.backgroundColor = .white
        collectionview.register(MoviesCell.self,
                                forCellWithReuseIdentifier: MoviesCell.classIdentifier)
		return collectionview
	}()
	
	
	init(viewModel: MovieListViewModel) {
		super.init(frame: .zero)
		self.viewModel = viewModel
		backgroundColor = .white
		self.setup()
	}
	
	private func setup() {
		self.addSubview(self.collectionView)
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		NSLayoutConstraint.activate([
			self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
			self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    public func reload() {
        self.collectionView.reloadData()
    }
}

extension MovieListView : UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let totalwidth = collectionView.bounds.size.width;
		let dimensions = CGFloat(Int(totalwidth) / 2)
		return CGSize(width: dimensions - 8.0, height: dimensions*2 - 16.0);
	}
	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
	}
}
extension MovieListView :UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
		return self.viewModel?.moviesArray.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCell.classIdentifier,
                                                         for: indexPath) as? MoviesCell {
			cell.tag = indexPath.row;
			cell.bind(movie: self.viewModel?.moviesArray[indexPath.row],
                      indexPath: indexPath);
			return cell;
		}
		
		return UICollectionViewCell();
	}
}
extension MovieListView :UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
		
	}
}
