//
//  SearchViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    let searchController : UISearchController = {
        let sc = UISearchController(searchResultsController: SearchResultsViewController())
        sc.searchBar.placeholder = "Albums,Artists,Songs.."
        sc.searchBar.searchBarStyle = .minimal
        sc.definesPresentationContext = true
        return sc
    }()
    private let collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_  -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160)),
                                                                     subitem: item,
                                                                     count:2
            )
            horizontalGroup.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 0, bottom: 9, trailing: 0)
            return NSCollectionLayoutSection(group: horizontalGroup)
        })
        
    )
    private var allCategoryModel = [CategoryModel]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifer)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchCategory()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    func fetchCategory(){
        CallerApi.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categoryModel):
                    self?.allCategoryModel = categoryModel
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - UISearchResultsUpdating

extension SearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let queryText =  searchController.searchBar.text, !queryText.trimmingCharacters(in: .whitespaces).isEmpty
        else {return}
        
        print(queryText)
    }
    
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension SearchViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategoryModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifer,
                                                            for: indexPath) as? CategoryCollectionViewCell
        else{return UICollectionViewCell()}
        // cell.backgroundColor = .systemBrown
        let category = self.allCategoryModel[indexPath.row]
        let categoryViewModel = CategoryViewModel(title: category.name,
                                                  categoryImageURL: URL(string: category.icons.first?.url ?? "-"))
        cell.configure(viewModel : categoryViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let categoryModel = self.allCategoryModel[indexPath.row]
        let vc = CategoryForPlayListController(categoryModel: categoryModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

