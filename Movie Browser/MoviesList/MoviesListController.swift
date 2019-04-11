//
//  MoviesViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesListController: UIViewController{
    
    var currentPage = 1;
    var totalPages:Int = 0;
    
    
    let decoder = JSONDecoder()
    var moviesArray:[Movie] = []
    var loading = false
    var searching = false;
    var scrollToTop = false;
    
    var movieType:MovieType = .nowPlaying;
    var searchText:String? = nil;
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView);
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView]);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView]);
        self.view.addConstraints(horizontal);
        self.view.addConstraints(vertical);
        
        nowPlayingMovies();
        viewWillSetUpNaviagtionBar();
    }
    
    
    func viewWillSetUpNaviagtionBar() -> Void {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = self.searchController;
        
        let orderButton = UIBarButtonItem(image: UIImage(named: "order"), style: .plain,target: self, action: #selector(showSimpleAlert));
        self.navigationItem.rightBarButtonItem = orderButton;
    }
    
    func nowPlayingMovies() -> Void {
        
        self.navigationItem.title = "Now Playing"
        loading = true;
        movieType = .nowPlaying;
        
        ApiConnections.getNowPlaying(page: currentPage, language: nil, completionHandler: { (data, error) in
            
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
    
    func TopRatedMovies() -> Void {
        
        self.navigationItem.title = "Top Rated"
        loading = true;
        movieType = .topRated;
        
        ApiConnections.getTopMovies(page: Int(currentPage), language: nil, completionHandler: { (data, error) in
            
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
                        if self.scrollToTop {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                             at: .top,
                                                             animated: true)
                        }
                    }
                }catch{
                    self.loading = false;
                    Logger.print(items: error.localizedDescription);
                }
            }
        });
    }
    func popularMovies() -> Void {
        
        self.navigationItem.title = "Most Popular"
        loading = true;
        movieType = .popular;
        
        ApiConnections.getPopular(page: Int(currentPage), language: nil) { (data, error) in
            
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
                        if self.scrollToTop {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                             at: .top,
                                                             animated: true)
                        }
                    }
                }catch{
                    self.loading = false;
                    Logger.print(items: error.localizedDescription);
                }
            }
        }
    }
    func searchMovie(text:String) -> Void {
        
        movieType = .searching;
        if let searchText = searchText {
            self.navigationItem.title = searchText + "...";
        }
        
        ApiConnections.search(language: nil, searchText: text) { (data, error) in
            
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
    func searchScrolling(text:String) -> Void {
        
        movieType = .searching;
        self.loading = true;
        
        ApiConnections.search(page: currentPage, language: nil, searchText: text) { (data, error) in
            
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
        collectionview.register(MoviesCell.self, forCellWithReuseIdentifier: "Cell");
        return collectionview;
    }()
    
    @objc func showSimpleAlert() {
        
        let alert = UIAlertController(title: "Sort", message: "",preferredStyle: .actionSheet);
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil));
        alert.addAction(UIAlertAction(title: "Most Popular Movies", style: UIAlertAction.Style.default, handler: {(_) in
            
            self.currentPage = 1;
            self.moviesArray.removeAll();
            self.scrollToTop = true;
            self.popularMovies();
        }));
        alert.addAction(UIAlertAction(title: "Top Rated Movies", style: UIAlertAction.Style.default, handler: {(_) in
            
            self.currentPage = 1;
            self.moviesArray.removeAll();
            self.scrollToTop = true;
            self.TopRatedMovies();
        }));
        self.present(alert, animated: true, completion: nil)
    }
}
extension MoviesListController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searching = true;
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            searchText = text;
            searchMovie(text: text);
        }
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
extension MoviesListController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds;
        var screenWidth:CGFloat? = nil;
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            screenWidth = (screenRect.size.width / 3) - 16
        }else{
            screenWidth = (screenRect.size.width/2) - 8.0;
        }
        let screenHeight = screenWidth!*2 - 16.0;
        
        return CGSize(width: screenWidth!, height: screenHeight);
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
extension MoviesListController :UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height;
        let contentYoffset = scrollView.contentOffset.y;
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset;
        if distanceFromBottom < height {
            if !loading{
                
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