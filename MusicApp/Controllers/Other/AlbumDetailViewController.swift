//
//  AlbumDetailViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 11.06.2024.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var album : Album
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _  -> NSCollectionLayoutSection in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)),
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .fractionalHeight(0.7)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        return section
    }))
    private var viewModels = [AlbumDetailViewModel]()
    private var tracks = [TracksModel]()
    
    // MARK: - Lifecycle
    
    init(album:Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        title = album.name
        collectionView.register(AlbumTrackForCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackForCollectionViewCell.identifier)
        collectionView.register(PlayListHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlayListHeaderCollectionReusableView.identifer)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchAlbumDetails()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self, action: #selector(didTapActions))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Assistants
        
    func fetchAlbumDetails() {
        CallerApi.shared.getAlbumDetails(album: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumDetailViewModel(name: $0.name,
                                             artistName: $0.artists.first?.name ?? "--" ,
                                             url: URL(string: $0.album?.images.first?.url ?? "" ))})
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Actions
    
   @objc func didTapActions(){
        
       let actionSheet = UIAlertController(title: album.name, message: "Actions", preferredStyle: .actionSheet)
       actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in
           guard let strongSelf = self else {return}
           CallerApi.shared.saveAlbum(album: strongSelf.album) { success in
               if success{
                   NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
               }
           }
       }))
        present(actionSheet, animated: true)
    }
    
}
    
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource
    
    extension AlbumDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource{
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModels.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackForCollectionViewCell.identifier, for: indexPath) as? AlbumTrackForCollectionViewCell
            else  { return UICollectionViewCell() }
            cell.configureRecommendation(viewModel: viewModels[indexPath.row])
            // cell.backgroundColor = .blue
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            guard kind == UICollectionView.elementKindSectionHeader else{ return UICollectionReusableView() }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlayListHeaderCollectionReusableView.identifer,
                for: indexPath) as? PlayListHeaderCollectionReusableView
            else {
                return UICollectionReusableView()
            }
            let viewModel = PlayListDetailHeaderForViewModel(name: album.name,
                                                             description:"Release Date : \(String.formattedDate(string: album.release_date))",
                                                             owner: album.artists.first?.name,
                                                             imageForUrl: URL(string: album.images.first?.url ?? "")
            )
            headerView.configure(viewModel : viewModel)
            headerView.delegate = self
            return headerView
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            // Song Play
            
            var track = tracks[indexPath.row]
            track.album = self.album
            PlaybackPresenter.shared.startPlayback(viewController: self, trackModel: track)
        }
        
        
    }
    
    // MARK: - PlayListHeaderCollectionReusableViewDelegate
    
    extension AlbumDetailViewController : PlayListHeaderCollectionReusableViewDelegate{
        
        func playListDetailHeaderProtocol(headerView: PlayListHeaderCollectionReusableView) {
            
            let trackWithAlbum : [TracksModel] = tracks.compactMap({
                var track = $0
                track.album = self.album
                return track
            })
            PlaybackPresenter.shared.startPlayback(viewController: self, tracks: tracks)
        }
        
        
    }
    
    
    

