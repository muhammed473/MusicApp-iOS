//
//  LibraryAlbumsViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 21.06.2024.
//

import UIKit

class LibraryAlbumsViewController : UIViewController{
    
    // MARK: - Properties
    
    var albums = [Album]()
    private let noAlbumsView = ActionLabelView()
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(SubTitleTableViewCell.self, forCellReuseIdentifier: SubTitleTableViewCell.identifer)
        tableView.isHidden = true
        return tableView
    }()
    private var observer : NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil, queue: .main,
            using: { [weak self] _ in
               self?.fetchData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    // MARK: - Assistants
    
    private func fetchData(){
        albums.removeAll()
       CallerApi.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(){
        
        if albums.isEmpty{
            // Show Label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else{
            // Show TableView
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
            
        }
    }
    
    private func setUpNoAlbumsView(){
        
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(viewModel: ActionLabelViewModel(text: "No Albums",
                                                                 actionTitle: "Browse"))
    }

    
    // MARK: - Actions
    
    @objc func didTapClose(){
        
        dismiss(animated: true,completion: nil)
    }
    
}

// MARK: - ActionLabelViewDelegate

extension LibraryAlbumsViewController : ActionLabelViewDelegate{
    
    func touchButton(actionLabelView: ActionLabelView) {
        
        tabBarController?.selectedIndex = 0
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension LibraryAlbumsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubTitleTableViewCell.identifer,
                                                       for: indexPath) as? SubTitleTableViewCell
        else{
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(viewModel: SubTitleTableViewModel(title: album.name,
                                                         imageUrl: URL(string: album.images.first?.url ?? ""),
                                                         subTitle: album.artists.first?.name ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = albums[indexPath.row]
       
        let vc = AlbumDetailViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
    

