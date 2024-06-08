//
//  MainViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

enum ChooseSectionType{
    
    case newReleasesPlayList     // 1
    case featuredPlayList        // 2
    case recommendationsPlayList // 3
}

class MainViewController: UIViewController {

    // MARK: - Properties
    
    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout{ (sectionIndex, _ ) -> NSCollectionLayoutSection in
            return MainViewController.createSectionLayout(sectionIndex: sectionIndex)
        }
    )
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = .blue
        return spinner
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(touchSettings))
        
        configureCollectionView()
        view.addSubview(spinner)
        
        fetchNewReleasesPlayList()
        fetchFeaturedPlayList()
       // fetchRecommendations()
        fetchRecommendationsGenres()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
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

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension MainViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .systemGreen
        }
        else if indexPath.section == 1 {
            cell.backgroundColor = .systemRed
        }
        else if indexPath.section == 2 {
            cell.backgroundColor = .systemBlue
        }
        return cell
    }
    
    
}

// MARK: - CreateSectionLayout

extension MainViewController {
    
    static func createSectionLayout(sectionIndex: Int) -> NSCollectionLayoutSection{
       
       switch sectionIndex{
           
       case 0 :
           let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)) )
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           let verticalGroup = NSCollectionLayoutGroup.vertical(
               layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
               subitem: item,
               count: 3
           )
           let horizontalGroup = NSCollectionLayoutGroup.horizontal(
               layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)),
               subitem: verticalGroup,
               count: 1
           )
           let section = NSCollectionLayoutSection(group: horizontalGroup)
           section.orthogonalScrollingBehavior = .groupPaging
           return section
           
       case 1:
           let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(210)) )
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
          
           let verticalGroup = NSCollectionLayoutGroup.vertical(
               layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(420)),
               subitem: item,
               count: 2
           )
           let horizontalGroup = NSCollectionLayoutGroup.horizontal(
               layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(420)),
               subitem: verticalGroup,
               count: 1
           )
           let section = NSCollectionLayoutSection(group: horizontalGroup)
           section.orthogonalScrollingBehavior = .continuous
           return section
           
       case 2:
           let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(80) ) )
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
         
           let verticalGroup = NSCollectionLayoutGroup.vertical(
               layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)),
               subitem: item,
               count: 1
           )
           let section = NSCollectionLayoutSection(group: verticalGroup)
           return section
           
       default:
           let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)) )
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           let group = NSCollectionLayoutGroup.vertical(
               layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(390)),
               subitem: item,
               count: 3
           )
           let section = NSCollectionLayoutSection(group: group)
           return section
       }
       
       
   }
}
