//
//  InfoViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 10/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class MovieInfoController: UIViewController {
    
    private var infoMovie:Movie!;
    let decoder = JSONDecoder()
    var genres:[String] = [];

    var detailsofMovie: Movie {
        get {
            return infoMovie;
        }
        set {
            infoMovie = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView);
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView":tableView]);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView":tableView]);
        self.view.addConstraints(horizontal);
        self.view.addConstraints(vertical);
        
        ApiConnections.findMovie(id: detailsofMovie.id) { (data, error) in
            
            if let data = data{
                do{
                    let movie_ = try self.decoder.decode(Movies.Result.self, from: data);
                    self.detailsofMovie = Movie(_movie: movie_);
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: 0, section: 0);
                        self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.top);
                    }
                }catch{
                    Logger.print(items: error.localizedDescription);
                }
            }
        }
    }
    lazy var tableView:UITableView = {
        
        let _tableView = UITableView(frame: .zero, style: .plain);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.register(PosterCell.self, forCellReuseIdentifier: "PosterTableViewCell")   ;      // register cell name
        _tableView.register(OverviewCell.self, forCellReuseIdentifier: "OverviewTableViewCell");
        _tableView.separatorStyle = .none;
        _tableView.allowsSelection = false;
        return _tableView;
    }();
    
    func headerView(text:String) -> UIView {
        let view = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.size.width, height: 44));
        view.backgroundColor = .white;
        let label = UILabel(frame: view.frame);
        label.text = text;
        label.font = UIFont.boldSystemFont(ofSize: 25);
        view.addSubview(label);
        return view;
    }
}
extension MovieInfoController :UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return self.view.frame.size.width;
        case 1:
            return detailsofMovie.overview.height(withConstrainedWidth: self.view.frame.size.width, font: UIFont(name: "HelveticaNeue-Medium", size: 22)!);
        case 2:
            return 44.0;
        case 3:
            return 44.0;
        default:
            break;
        }
        return 0.0;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0;
        case 1:
            return 44.0;
        case 2:
            return 44.0;
        case 3:
            return 44.0;
        default:
            break;
        }
        return 0.0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return headerView(text: "Synopsis");
        case 2:
            return headerView(text: "User Rating");
        case 3:
            return headerView(text: "Release Date");
        default:
            break;
        }
        return UIView();
    }
}
extension MovieInfoController :UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PosterTableViewCell", for: indexPath) as? PosterCell {
                cell.tag = indexPath.row;
                cell.bind(movie: detailsofMovie, indexPath: indexPath);
                return cell;
            }
        case 1:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as? OverviewCell{
                cell.bind(text: detailsofMovie.overview, indexPath: indexPath, textColor: .black);
                return cell;
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as? OverviewCell{
                let _vote = Int(detailsofMovie.voteAverage);
                cell.bind(text: AppConstants.ratingsDisplay[_vote], indexPath: indexPath, textColor: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1));
                return cell;
            }
            break;
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as? OverviewCell{
                cell.bind(text: PosterCell().date(releaseDate: detailsofMovie.releaseDate), indexPath: indexPath, textColor: .black);
                return cell;
            }
            break;
        default:
            break;
        }
        return UITableViewCell();
    }
}
extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height) + 32.0
    }
}
