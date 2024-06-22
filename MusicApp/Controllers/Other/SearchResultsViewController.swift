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
        tableView.register(DefaultTableViewCell.self,forCellReuseIdentifier: DefaultTableViewCell.identifer)
        tableView.register(SubTitleTableViewCell.self, forCellReuseIdentifier: SubTitleTableViewCell.identifer)
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
        
        let result = searchSections[indexPath.section].searchResultModels[indexPath.row]
        switch result{
            
        case .album(let model):
            
            guard let albumCell = tableView.dequeueReusableCell(withIdentifier: SubTitleTableViewCell.identifer,
                                                                for: indexPath) as? SubTitleTableViewCell
            else {
                return UITableViewCell()
            }
            let viewModel = SubTitleTableViewModel(title: model.name,imageUrl: URL(string: model.images.first?.url ?? ""),
                                                   subTitle: model.artists.first?.name ?? "")
            albumCell.configure(viewModel: viewModel)
            return albumCell
        case .artist(let model):
            
            guard let artistCell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifer,
                                                                for: indexPath) as? DefaultTableViewCell
            else {
                return UITableViewCell()
            }
            let viewModel = DefaultTableViewModel(title: model.name,imageUrl: URL(string: model.images?.first?.url ?? ""))
            artistCell.configure(viewModel: viewModel)
        return artistCell
            
        case .playlist(let model):
            guard let albumCell = tableView.dequeueReusableCell(withIdentifier: SubTitleTableViewCell.identifer,
                                                                for: indexPath) as? SubTitleTableViewCell
            else {
                return UITableViewCell()
            }
            let viewModel = SubTitleTableViewModel(title: model.name,imageUrl: URL(string: model.images?.first?.url ?? ""),
                                                   subTitle: model.owner.display_name)
            albumCell.configure(viewModel: viewModel)
            return albumCell
            
        case .track(let model):
            guard let trackCell = tableView.dequeueReusableCell(withIdentifier: SubTitleTableViewCell.identifer,
                                                                for: indexPath) as? SubTitleTableViewCell
            else {
                return UITableViewCell()
            }
            let viewModel = SubTitleTableViewModel(title: model.name,
                                                   imageUrl: URL(string: model.album?.images.first?.url ?? ""),
                                                   subTitle: model.artists.first?.name ?? "")
            trackCell.configure(viewModel: viewModel)
            return trackCell
        }
        
      
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
