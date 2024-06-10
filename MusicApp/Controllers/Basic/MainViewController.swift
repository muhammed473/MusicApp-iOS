//
//  MainViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

enum ChooseSectionType{
    
    case newReleasesPlayList(viewModels: [NewReleasesCellViewModel] )           // 1
    case featuredPlayList(viewModels: [FeaturedPlaylistCellViewModel] )         // 2
    case recommendationsPlayList(viewModels: [RecommendedTrackCellViewModel] )  // 3
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
    private var sections = [ChooseSectionType]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(touchSettings))
        
        configureCollectionView()
        view.addSubview(spinner)
        
       // fetchNewReleasesPlayList()
       // fetchFeaturedPlayList()
       // fetchRecommendations()
       // fetchRecommendationsGenres()
        fetchData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.identifier)
        collectionView.register(RecommendationsCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationsCollectionViewCell.identifier)
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
 
    func fetchData(){
      
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleasesModelValues : NewReleasesModel?
        var featuredModelValues : FeaturedPlayListModel?
        var recommendationModelValues : RecommendationsModel?
        
        // MARK: - NewReleases
        
        CallerApi.shared.getNewReleasesPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let modelValues):
                newReleasesModelValues = modelValues
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        // MARK: - Featured
        
        CallerApi.shared.getFeaturedPlaylists { result in
            defer{
                group.leave()
            }
            switch result {
            case .success(let modelValues):
                featuredModelValues = modelValues
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        // MARK: - Recommendation
        
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
                CallerApi.shared.getRecommendations(genres: seeds) { recommendationResult in
                    defer {
                        group.leave()
                    }
                    switch recommendationResult {
                    case .success(let modelValues):
                        recommendationModelValues = modelValues
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            guard let newAlbums = newReleasesModelValues?.albums.items,
                  let playLists = featuredModelValues?.playlists.items,
                  let tracks = recommendationModelValues?.tracks
            else {
                fatalError("PRİNT: FATAL ERROR Because : Models are nil")
                return
            }
            print("PRİNT: Configure viewModels is loading ......")
            self.configureModels(newAlbums: newAlbums, playLists: playLists, tracks: tracks)
        }
        
    }
    
    private func configureModels(newAlbums:[Album], playLists: [PlayListModel],tracks: [TracksModel]){
        print("PRİNT: New Album is count : \(newAlbums.count)")
        print("PRİNT: \(playLists.count)")
        print("PRİNT: \(tracks.count)")
        sections.append(.newReleasesPlayList(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            albumImageUrl: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "--")
        })))
        sections.append(.featuredPlayList(viewModels: playLists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name,
                                                 featuredImageURL: URL(string: $0.images.first?.url ?? ""),
                                                 creatorName: $0.owner.display_name)
        }) ))
        sections.append(.recommendationsPlayList(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name,
                                                 artistName: $0.artists.first?.name ?? "--",
                                                 artworkURL: URL(string: $0.album.images.first?.url ?? "" ))
        }) ))
        collectionView.reloadData()
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
        
        let currentSection = sections[section]
        switch currentSection {
            
        case .newReleasesPlayList( let viewModels):
            return viewModels.count
        case .featuredPlayList(let viewModels):
            return viewModels.count
        case .recommendationsPlayList(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentSection = sections[indexPath.section]
        switch currentSection {
            
        case .newReleasesPlayList( let viewModels):
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell
            else { return UICollectionViewCell() }
           // cell.backgroundColor = .blue
            let viewModel = viewModels[indexPath.row]
            cell.configureNewReleases(viewModel: viewModel)
            return cell
            
        case .featuredPlayList(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, 
                                                                for: indexPath) as? FeaturedCollectionViewCell
            else { return UICollectionViewCell() }
            cell.backgroundColor = .green
            let viewModel = viewModels[indexPath.row]
            cell.configureFeatured(viewModel: viewModel)
            return cell
            
        case .recommendationsPlayList(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationsCollectionViewCell.identifier,
                                                                for: indexPath) as? RecommendationsCollectionViewCell
            else { return UICollectionViewCell() }
            //cell.backgroundColor = .red
            let viewModel = viewModels[indexPath.row]
            cell.configureRecommendation(viewModel: viewModel)
            return cell
        }
        
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
