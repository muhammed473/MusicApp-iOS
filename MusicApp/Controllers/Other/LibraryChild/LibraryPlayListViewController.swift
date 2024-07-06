//
//  LibraryPlayListViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 21.06.2024.
//

import UIKit

class LibraryPlayListViewController : UIViewController{
    
    // MARK: - Properties
    
    public var selectionHandler : ((PlayListModels) -> Void)?
    var playListsModels = [PlayListModels]()
    private let noPlayListView = ActionLabelView()
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(SubTitleTableViewCell.self, forCellReuseIdentifier: SubTitleTableViewCell.identifer)
        tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlayListView()
        fetchCurrentUserPlayLists()
        if selectionHandler != nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noPlayListView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlayListView.center = view.center
        tableView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    private func fetchCurrentUserPlayLists(){
        CallerApi.shared.getCurrentUserPlayLists { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlistsModels):
                    self?.playListsModels = playlistsModels
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(){
        
        if playListsModels.isEmpty{
            // Show Label
            noPlayListView.isHidden = false
            tableView.isHidden = true
        }
        else{
            // Show TableView
            tableView.reloadData()
            noPlayListView.isHidden = true
            tableView.isHidden = false
            
        }
    }
    
    private func setUpNoPlayListView(){
        
        view.addSubview(noPlayListView)
        noPlayListView.delegate = self
        noPlayListView.configure(viewModel: ActionLabelViewModel(text: "No Playlist",
                                                                 actionTitle: "Create"))
    }
    
     func showCreatePlayListAlert(){
        
        // Show rendering UI ( Documentation -> Create a Playlist
        let alert = UIAlertController(title: "New Playlists", message: "Entere playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist....."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                return
            }
            CallerApi.shared.createPlaylist(name: text) { [weak self] success in
                if success{
                    // Refresh playlist
                    HapticsDirector.shared.vibrate(type: .success)
                    self?.fetchCurrentUserPlayLists()
                }
                else{
                    HapticsDirector.shared.vibrate(type: .error)
                    print("Failed to create playlist.")
                }
            }
            
        }))
        present(alert,animated: true)
    }
    
    // MARK: - Actions
    
    @objc func didTapClose(){
        
        dismiss(animated: true,completion: nil)
    }
    
}

// MARK: - ActionLabelViewDelegate

extension LibraryPlayListViewController : ActionLabelViewDelegate{
    
    func touchButton(actionLabelView: ActionLabelView) {
        
        showCreatePlayListAlert()
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension LibraryPlayListViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return playListsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubTitleTableViewCell.identifer,
                                                       for: indexPath) as? SubTitleTableViewCell
        else{
            return UITableViewCell()
        }
        let playList = playListsModels[indexPath.row]
        cell.configure(viewModel: SubTitleTableViewModel(title: playList.name,
                                                         imageUrl: URL(string: playList.images?.first?.url ?? ""),
                                                         subTitle: playList.owner.display_name))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsDirector.shared.vibrateForSelection()
        let playlist = playListsModels[indexPath.row]
        guard selectionHandler == nil else{
            selectionHandler?(playlist)
            dismiss(animated: true,completion: nil)
            return
        }
        let vc = PlayListDetailViewController(playList: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
