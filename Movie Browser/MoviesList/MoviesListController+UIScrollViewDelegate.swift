//
//  MoviesListController+UIScrollViewDelegate.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit

extension MoviesListController :UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewContentHeight = self.collectionView.contentSize.height;
        let scrollOffsetThreshold = scrollViewContentHeight - self.collectionView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionView.isDragging) {
            if !loading{
                
                let frame = CGRect(x: 0, y: self.collectionView.contentSize.height, width: self.collectionView.bounds.size.width, height: ActivityIndicatorView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                scrollToTop = false;
                
                switch movieType{
                    
                case .topRated:
                    TopRatedMovies();
                    break;
                case .popular:
                    popularMovies();
                    break;
                case .nowPlaying:
                    nowPlayingMovies();
                    break;
                case .searching:
                    
                    if let searchText = searchText {
                        searchScrolling(text: searchText);
                    }
                    break
                }
            }
        }
    }
}
