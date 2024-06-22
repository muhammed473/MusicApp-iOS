//
//  CategoryForPlayListController.swift
//  MusicApp
//
//  Created by muhammed dursun on 15.06.2024.
//

import UIKit

class CategoryForPlayListController : UIViewController {

    // MARK: - Properties

    let categoryModel : CategoryModel
    private var playlists = [PlayListModels]()
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(245)),
                subitem: item,
                count: 2)
            horizontalGroup.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            return NSCollectionLayoutSection(group: horizontalGroup)
        }))
        
    

    // MARK: - Lifecycle

    init(categoryModel : CategoryModel){
        self.categoryModel = categoryModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryModel.name
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchCategoryForPlaylist()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    func fetchCategoryForPlaylist() {
        
        CallerApi.shared.getCategoryPlayList(categoryModel: categoryModel) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playLists):
                    self?.playlists = playLists
                    self?.collectionView.reloadData()
                case .failure(let error):
                    break
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension CategoryForPlayListController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      guard   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier,
                                                            for: indexPath) as? FeaturedCollectionViewCell 
        else{return UICollectionViewCell()}
        let playlists = self.playlists[indexPath.row]
        cell.configureFeatured(viewModel: FeaturedPlaylistCellViewModel(name: playlists.name,
                                                                        featuredImageURL: URL(string: playlists.images?.first?.url ?? "-"),
                                                                        creatorName: playlists.owner.display_name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = PlayListDetailViewController(playList: self.playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
