//
//  SearchResultsViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate : AnyObject {
    func touchResult(result : SearchResultModel)
}

class SearchResultsViewController: UIViewController {

    // MARK: - Properties
    
    private var searchSections : [SearchSection] = []
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    weak var delegate : SearchResultsViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    
    // MARK: - Assistants
    
    func configureData(searchResultModels : [SearchResultModel] ){
        let artists = searchResultModels.filter(
            {
                switch $0 {
                case .artist : return true
                default: return false
                }
            } )
        let albums = searchResultModels.filter(
            {
                switch $0 {
                case .album : return true
                default: return false
                }
            } )
        let playlists = searchResultModels.filter(
            {
                switch $0 {
                case .playlist : return true
                default: return false
                }
            } )
        let tracks = searchResultModels.filter(
            {
                switch $0 {
                case .track  : return true
                default: return false
                }
            } )
      
        self.searchSections = [
            SearchSection(title: "Songs", searchResultModels : tracks),
            SearchSection(title: "Artists", searchResultModels : artists),
            SearchSection(title: "Albums", searchResultModels : albums),
            SearchSection(title: "PlayLists", searchResultModels : playlists)
        ]
       
        tableView.reloadData()
        tableView.isHidden = searchResultModels.isEmpty
    }

}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension SearchResultsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSections[section].searchResultModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = searchSections[indexPath.section].searchResultModels[indexPath.row]
        switch result{
            
        case .album(model: let model):
            cell.textLabel?.text =  model.name
        case .artist(model: let model):
            cell.textLabel?.text = model.name
        case .playlist(model: let model):
            cell.textLabel?.text =  model.name
        case .track(model: let model):
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchSections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchSections[indexPath.section].searchResultModels[indexPath.row]
        delegate?.touchResult(result:result)
        
    }
    
    
}
