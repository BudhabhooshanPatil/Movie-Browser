//
//  MoviesViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 08/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MoviesListController: UIViewController{
    
    /****/
    var currentPage = 1;
    var totalPages:Int = 0;
    var loadingMoreView:ActivityIndicatorView?
    var collectionViewBackground:ActivityIndicatorView?
    var numberOfCellsPerRow = 2
    let decoder = JSONDecoder()
    var moviesArray:[Movie] = []
    var loading = false
    var searching = false;
    var scrollToTop = false;
    var movieType:MovieType = .nowPlaying;
    var searchText:String? = nil;
    /********/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add UICollectionView to UIView
        self.view.addSubview(self.collectionView);
        
        // remove autoLayout constraints
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // horizontal constraints for UICollectionView
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: ["collectionView":collectionView]);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["collectionView":collectionView]);
        self.view.addConstraints(horizontal);
        self.view.addConstraints(vertical);
        
        // load movies in theater for first lauch
        nowPlayingMovies();
        
        // set up naviagtion bar
        viewWillSetUpNaviagtionBar();
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // check if device is iPad or Iphone
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            numberOfCellsPerRow = 3;
        }
    }
    
    /// set up naviagtion bar
    func viewWillSetUpNaviagtionBar() -> Void {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = self.searchController;
        
        // add sort bar button
        let orderButton = UIBarButtonItem(image: UIImage(named: "order"), style: .plain,target: self, action: #selector(showSimpleAlert(sender:)));
        self.navigationItem.rightBarButtonItem = orderButton;
    }
    
    
    /// load movies in theater
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
                        self.moviesArray.append(Movie(model: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                        self.loadingMoreView?.stopAnimating();
                        self.collectionViewBackground?.stopAnimating();
                        self.collectionViewBackground?.removeFromSuperview();
                    }
                }catch{
                    self.loading = false;
                    self.loadingMoreView?.stopAnimating();
                    Logger.print(items: error.localizedDescription);
                }
            }else{
                if let error = error {
                    Logger.print(items: error.statusMessage);
                }
            }
        });
    }
    /// load top rated movies
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
                        self.moviesArray.append(Movie(model: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                        self.loadingMoreView?.stopAnimating();
                        if self.scrollToTop {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                             at: .top,
                                                             animated: true)
                        }
                    }
                }catch{
                    self.loading = false;
                    self.loadingMoreView?.stopAnimating();
                    Logger.print(items: error.localizedDescription);
                }
            }else{
                if let error = error {
                    Logger.print(items: error.statusMessage);
                }
            }
        });
    }
    
    /// load popular movies
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
                        self.moviesArray.append(Movie(model: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                        self.loadingMoreView?.stopAnimating();
                        if self.scrollToTop {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                             at: .top,
                                                             animated: true)
                        }
                    }
                }catch{
                    self.loading = false;
                    self.loadingMoreView?.stopAnimating();
                    Logger.print(items: error.localizedDescription);
                }
            }else{
                if let error = error {
                    Logger.print(items: error.statusMessage);
                }
            }
        }
    }
    
    /// search movie
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
                        self.moviesArray.append(Movie(model: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                        self.loadingMoreView?.stopAnimating();
                    }
                }catch{
                    self.loading = false;
                    self.loadingMoreView?.stopAnimating();
                    Logger.print(items: error.localizedDescription);
                }
            }else{
                if let error = error {
                    Logger.print(items: error.statusMessage);
                }
            }
        }
    }
    /// scrolling while searching
    func searchScrolling(text:String) -> Void {
        
        movieType = .searching;
        self.loading = true;
        
        ApiConnections.search(page: currentPage, language: nil, searchText: text) { (data, error) in
            
            if let data = data{
                do{
                    let movies_ = try self.decoder.decode(Movies.self, from: data);
                    self.currentPage = self.currentPage + 1;
                    for _movie in movies_.results{
                        self.moviesArray.append(Movie(model: _movie));
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData();
                        self.loading = false;
                        self.loadingMoreView?.stopAnimating();
                    }
                }catch{
                    self.loading = false;
                    self.loadingMoreView?.stopAnimating();
                    Logger.print(items: error.localizedDescription);
                }
            }else{
                if let error = error {
                    Logger.print(items: error.statusMessage);
                }
            }
        }
    }
    
    
    /// search controller
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
    
    
    /// UICollectionView
    lazy var collectionView: UICollectionView = {
        
        // setup the collection view
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout());
        collectionview.dataSource = self;
        collectionview.delegate = self;
        collectionview.alwaysBounceVertical = true;
        collectionview.backgroundColor = .white;
        collectionview.register(MoviesCell.self, forCellWithReuseIdentifier: "Cell");
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: collectionview.contentSize.height, width: collectionview.bounds.size.width, height: ActivityIndicatorView.defaultHeight)
        loadingMoreView = ActivityIndicatorView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionview.addSubview(loadingMoreView!)
        
        var insets = collectionview.contentInset
        insets.bottom += ActivityIndicatorView.defaultHeight
        collectionview.contentInset = insets
        
        collectionViewBackground = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60));
        collectionViewBackground?.startAnimating();
        collectionViewBackground?.center = self.view.center;
        collectionview.backgroundView = collectionViewBackground;
        
        return collectionview;
    }()
    
    
    /// Alert Controller
    ///
    /// - Parameter sender: bar button
    @objc func showSimpleAlert(sender: UIBarButtonItem)  {
        
        let alert = UIAlertController(title: "Sort", message: "",preferredStyle: .actionSheet);
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil));
        alert.addAction(UIAlertAction(title: "Now Playing", style: UIAlertAction.Style.default, handler: {(_) in
            
            self.currentPage = 1;
            self.moviesArray.removeAll();
            self.scrollToTop = true;
            self.nowPlayingMovies();
        }));
        
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
        
        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem = sender;
            
        }
        
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


