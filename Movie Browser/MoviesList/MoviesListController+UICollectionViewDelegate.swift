//
//  MoviesListController+UICollectionViewDelegateFlowLayout.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 11/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import Foundation
import UIKit

extension MoviesListController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalwidth = collectionView.bounds.size.width;
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        
        return CGSize(width: dimensions - 8.0, height: dimensions*2 - 16.0);
    }
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
extension MoviesListController :UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MoviesCell {
            cell.tag = indexPath.row;
            cell.bind(movie: moviesArray[indexPath.row], indexPath: indexPath);
            return cell;
        }
        
        return UICollectionViewCell();
    }
}
extension MoviesListController :UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let infoPage = MovieInfoController()
        infoPage.detailsofMovie = self.moviesArray[indexPath .row];
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            
            infoPage.modalPresentationStyle = .popover;
            
            if let popoverController = infoPage.popoverPresentationController {
                popoverController.sourceView = collectionView.cellForItem(at: indexPath);
                popoverController.sourceRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 69/100, height: self.view.frame.size.height * 73/100);
                popoverController.permittedArrowDirections = .any
                self.present(infoPage, animated: true, completion: nil)
            }
        }else{
            self.navigationController?.pushViewController(infoPage, animated: true)
        }
    }
}
