//
//  MainViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(touchSettings))
        
        fetchNewReleasesPlayList()
    }
    
    // MARK: - Assistants
    
    func fetchNewReleasesPlayList(){
        
        CallerApi.shared.getNewReleasesPlaylists { result in
            switch result {
            case .success(let newRelease): break
            case.failure(let error): break
            }
            
        }
    }
    
    func fetchNewReleasesAlbum(){
        
        CallerApi.shared.getNewReleasesPlaylists { result in
            switch result {
            case .success(let newRelease): break
            case.failure(let error): break
            }
            
        }
    }
    
    // MARK: - Actions
    
    @objc func touchSettings(){
        
        let vc = SettingsViewController()
        vc.title = "SETTİNGS"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
