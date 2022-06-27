//
//  MovieInfoContentView.swift
//  Movie Browser
//
//  Created by Bhooshan Patil on 02/06/22.
//  Copyright © 2022 Inscripts.com. All rights reserved.
//

import UIKit

class MovieInfoContentView: UIView {
    var viewModel: MovieInfoViewModel?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    init(viewModel: MovieInfoViewModel?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupViews()
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MovieInfoTopNameTableViewCell.self, forCellReuseIdentifier: MovieInfoTopNameTableViewCell.identifier)
        self.tableView.register(MovieCastAndCrewTableViewCell.self, forCellReuseIdentifier: MovieCastAndCrewTableViewCell.identifier)
        self.tableView.register(MovieDescriptionTableViewCell.self, forCellReuseIdentifier: MovieDescriptionTableViewCell.identifier)
        self.tableView.register(MovieImagesTableViewCell.self, forCellReuseIdentifier: MovieImagesTableViewCell.identifier)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    public func reloadMoviePrimaryInformation() {
        self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0),
                                       IndexPath(item: 2, section: 0)],
                                  with: .automatic)
    }
    
    public func reloadMovieImagesInformation() {
        self.tableView.reloadRows(at: [IndexPath(item: 1, section: 0),],
                                  with: .automatic)
    }
    
    public func reloadCastAndCrewInformation() {
        self.tableView.reloadRows(at: [IndexPath(item: 3, section: 0),],
                                  with: .automatic)
    }
}

extension MovieInfoContentView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieInfoTopNameTableViewCell.identifier, for: indexPath) as? MovieInfoTopNameTableViewCell {
                cell.configure(moviePrimaryInformationResult: self.viewModel?.moviePrimaryInformationResult)
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieImagesTableViewCell.identifier, for: indexPath) as? MovieImagesTableViewCell {
                cell.configurationFor(movieImagesbackdrop: self.viewModel?.movieImagesResult?.backdrops)
                return cell
            }
            break
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieDescriptionTableViewCell.identifier, for: indexPath) as? MovieDescriptionTableViewCell {
                cell.descripntionLabel.text = self.viewModel?.moviePrimaryInformationResult?.overview
                return cell
            }
            break
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCastAndCrewTableViewCell.identifier, for: indexPath) as? MovieCastAndCrewTableViewCell {
                cell.configurationFor(cast: self.viewModel?.movieCastResult?.cast)
                return cell
            }
            break
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}
