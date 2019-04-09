//
//  MoviesViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController{
    
    var currentPage:CGFloat = 1.0;
    
    let decoder = JSONDecoder()
    var moviesArray:[Movie] = []
    var loading = false
    var searching = false;
    
    
    static let imageBasePath = "https://image.tmdb.org/t/p/w185_and_h278_bestv2"
    static let API_KEY = "53eafbc1ab15fcd88324c96a958d6ca5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView);
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView]);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView]);
        self.view.addConstraints(horizontal);
        self.view.addConstraints(vertical);
        
        topMovies();
        viewWillSetUpNaviagtionBar();
    }
    func viewWillSetUpNaviagtionBar() -> Void {
        self.navigationItem.searchController = self.searchController;
        
    }
    @objc func sort() -> Void {
        
    }
    @objc func order() -> Void {
        
    }
    func topMovies() -> Void {
        
        loading = true;
        
        getTopMovies(page: Int(currentPage), language: nil, completionHandler: { (data, error) in
            
            if let data = data{
                do{
                    let movies_ = try self.decoder.decode(Movies.self, from: data);
                    self.currentPage = self.currentPage + 1;
                    for _movie in movies_.results{
                        self.moviesArray.append(Movie(_movie: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                    }
                }catch{
                    self.loading = false;
                    Logger.print(items: error.localizedDescription);
                }
            }
        });
    }
    func popularMovies() -> Void {
        
        getPopular(page: Int(currentPage), language: nil) { (data, error) in
            
            if let data = data{
                do{
                    let movies_ = try self.decoder.decode(Movies.self, from: data);
                    self.currentPage = self.currentPage + 1;
                    for _movie in movies_.results{
                        self.moviesArray.append(Movie(_movie: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                    }
                }catch{
                    self.loading = false;
                    Logger.print(items: error.localizedDescription);
                }
            }
        }
        
    }
    func searchMovie(text:String) -> Void {
    
        search(language: nil, searchText: text) { (data, error) in
            
            if let data = data{
                do{
                    let movies_ = try self.decoder.decode(Movies.self, from: data);
                    self.moviesArray.removeAll();
                    for _movie in movies_.results{
                        self.moviesArray.append(Movie(_movie: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                    }
                }catch{
                    self.loading = false;
                    Logger.print(items: error.localizedDescription);
                }
            }
        }
    }
    
    lazy var searchController: UISearchController =  {
        
        // setup the search controller
        let searchcontroller = UISearchController(searchResultsController: nil);
        searchcontroller.searchResultsUpdater = self;
        searchcontroller.obscuresBackgroundDuringPresentation = false;
        searchcontroller.searchBar.placeholder = "Search Movies";
        navigationItem.searchController = searchcontroller;
        definesPresentationContext = true;
        return searchcontroller;
    }()
    lazy var collectionView: UICollectionView = {
        
        // setup the collection view
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout());
        collectionview.dataSource = self;
        collectionview.delegate = self;
        collectionview.alwaysBounceVertical = true;
        collectionview.backgroundColor = .white;
        collectionview.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell");
        return collectionview;
    }()
}
extension MoviesViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searching = true;
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            searchMovie(text: text);
        }
    }
}

extension MoviesViewController :UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            cell.tag = indexPath.row;
            cell.bind(movie: moviesArray[indexPath.row], indexPath: indexPath);
            cell.layer.cornerRadius = 10
            
            // shadow
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.layer.shadowOpacity = 0.7
            cell.layer.shadowRadius = 4.0
            return cell;
        }
        
        return UICollectionViewCell();
    }
}
extension MoviesViewController :UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension MoviesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds;
        
        let screenWidth = (screenRect.size.width/2) - 16.0;
        let screenHeight = screenWidth*2 - 16.0;
        
        return CGSize(width: screenWidth, height: screenHeight);
    }
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
extension MoviesViewController :UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height;
        let contentYoffset = scrollView.contentOffset.y;
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset;
        if distanceFromBottom < height {
            if !loading{
                topMovies();
            }
        }
    }
}
