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
        fetchFeaturedPlayList()
       // fetchRecommendations()
        fetchRecommendationsGenres()
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
    
    func fetchFeaturedPlayList(){
        
        CallerApi.shared.getFeaturedPlaylists { result in
            switch result {
            case .success(let newRelease): break
                3
            case.failure(let error): break
            }

        }
    }
    
   /* func fetchRecommendations(){
        
        CallerApi.shared.getRecommendations(genres: Set<String>){ result in
            switch result {
            case .success(let recommendations): break
                
            case .failure(let error): break
            }
        }
        
    } */
    
    func fetchRecommendationsGenres(){
      
        CallerApi.shared.getRecommendationsGenres { result in
            switch result {
            case .success(let recommendationsGenres):
                let genres = recommendationsGenres.genres
                var seeds = Set<String>()
                while seeds.count < 4 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                CallerApi.shared.getRecommendations(genres: seeds) { _ in
                    
                }
            
            case .failure(_): break
                
                
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
