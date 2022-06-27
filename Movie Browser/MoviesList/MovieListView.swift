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
    var loadingMoreView: ActivityIndicatorView?
    var collectionViewBackground: ActivityIndicatorView?
    
    lazy var collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        let collectionview = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.alwaysBounceVertical = true
        collectionview.backgroundColor = .white
        collectionview.register(MoviesCell.self,
                                forCellWithReuseIdentifier: MoviesCell.identifier)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: collectionview.contentSize.height, width: collectionview.bounds.size.width, height: ActivityIndicatorView.defaultHeight)
        loadingMoreView = ActivityIndicatorView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionview.addSubview(loadingMoreView!)
        
        var insets = collectionview.contentInset
        insets.bottom += ActivityIndicatorView.defaultHeight
        collectionview.contentInset = insets
        
        collectionViewBackground = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        collectionViewBackground?.startAnimating()
        collectionViewBackground?.center = self.center
        collectionview.backgroundView = collectionViewBackground
        
        return collectionview
    }()    
    
    init(viewModel: MovieListViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        backgroundColor = .white
        setupViews()
        setupLayouts()
    }
    
    private func setupViews() {
        self.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func setupLayouts() {
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
        
        let totalwidth = self.frame.size.width
        let widthForItem = totalwidth / 2 - 16.0
        let heightForItem = widthForItem * 2.0
        return CGSize(width: widthForItem,
                      height: heightForItem)
    }
}
extension MovieListView :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.moviesArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCell.identifier,
                                                         for: indexPath) as? MoviesCell {
            cell.tag = indexPath.row
            cell.bind(movie: self.viewModel?.moviesArray[indexPath.row],
                      indexPath: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
}
extension MovieListView :UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.delegate?.didSelectItemAt(indexPath: indexPath)
    }
}

extension MovieListView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewContentHeight = self.collectionView.contentSize.height;
        let scrollOffsetThreshold = scrollViewContentHeight - self.collectionView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionView.isDragging) {
            guard self.viewModel?.loading == false else { return }
            
            let frame = CGRect(x: 0, y: self.collectionView.contentSize.height, width: self.collectionView.bounds.size.width, height: ActivityIndicatorView.defaultHeight)
            loadingMoreView?.frame = frame
            loadingMoreView?.startAnimating()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel?.loadNowPlayingMovies()
            }
        }
    }
}
