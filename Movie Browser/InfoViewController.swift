//
//  InfoViewController.swift
//  Movie Browser
//
//  Created by Budhabhooshan Patil on 10/04/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    private var infoMovie:Movie? = nil;
    
    var detailsofMovie: Movie? {
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
        
    }
    lazy var tableView:UITableView = {
        
        let _tableView = UITableView(frame: .zero, style: .plain);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: "PosterTableViewCell")         // register cell name
        _tableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: "OverviewTableViewCell")
        _tableView.separatorStyle = .none;
        _tableView.allowsSelection = false;
        return _tableView;
    }();
    lazy var headerView: UIView = {
        
        let view = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.size.width, height: 44));
        let label = UILabel(frame: view.frame);
        label.text = "OverView";
        label.font = UIFont.boldSystemFont(ofSize: 20);
        view.addSubview(label);
        return view;
    }()
}
extension InfoViewController :UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 44.0;
        default:
            break;
        }
        return 0.0;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Overview";
        default:
            break;
        }
        return String();
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return self.headerView;
        default:
            break;
        }
        return UIView();
    }
}
extension InfoViewController :UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(2.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1;
        case 1:
            return 1;
        default:
            break;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PosterTableViewCell", for: indexPath) as? PosterTableViewCell {
                cell.tag = indexPath.row;
                cell.bind(movie: detailsofMovie, indexPath: indexPath);
                return cell;
            }
        case 1:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as? OverviewTableViewCell{
                cell.bind(movie: detailsofMovie, indexPath: indexPath);
                return cell;
            }
        default:
            break;
        }
        return UITableViewCell();
    }
}
