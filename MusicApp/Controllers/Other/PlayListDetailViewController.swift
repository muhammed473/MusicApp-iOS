//
//  PlayListDetailViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 11.06.2024.
//

import UIKit

class PlayListDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var playList : PlayListModels
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _  -> NSCollectionLayoutSection in
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .fractionalHeight(1.0) ) )
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)),
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .fractionalHeight(0.8)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        return section
    }))
    private var viewModels = [RecommendedTrackCellViewModel]()
    private var tracks = [TracksModel]()
    public var isOwner = false 
    
    // MARK: - Lifecycle
    
    init(playList : PlayListModels){
        self.playList  = playList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = playList.name
        view.backgroundColor = .purple
        fetchPlayListDetails()
        view.addSubview(collectionView)
        collectionView.register(RecommendationsCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationsCollectionViewCell.identifier)
        collectionView.register(PlayListHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlayListHeaderCollectionReusableView.identifer)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(touchShareButton))
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    
    // MARK: - Assistants
    
    func fetchPlayListDetails() {
        CallerApi.shared.getFeaturedPlayListDetails(playLists: playList) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name,
                                                      artistName: $0.track.artists.first?.name ?? "--",
                                                      artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func touchShareButton(){
        
        print("PRİNT : external_urls : \(playList.external_urls)")
        guard let externalUrls = URL(string: playList.external_urls["spotify"] ?? "") else {return}
        let vc = UIActivityViewController(
            activityItems: [externalUrls],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    @objc func longPress(gesture : UILongPressGestureRecognizer){
        
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {return}
        let currentTrack = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: currentTrack.name,
                                            message: "Would you like to remove this from the playlist?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else{
                return
            }
            CallerApi.shared.removeTrackFromPlayList(track:currentTrack,playlistModel: strongSelf.playList){success in
                DispatchQueue.main.async {
                    if success{
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    }
                    else{
                        print("PRİNT: Failed to REMOVE")
                    }
                }
            }
        }))
        present(actionSheet, animated: true,completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension PlayListDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationsCollectionViewCell.identifier, for: indexPath) as? RecommendationsCollectionViewCell
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
        let viewModel = PlayListDetailHeaderForViewModel(name: playList.name,
                                                         description: playList.description,
                                                         owner: playList.owner.display_name,
                                                         imageForUrl: URL(string: playList.images?.first?.url ?? "")
        )
        headerView.configure(viewModel : viewModel)
        headerView.delegate = self
        return headerView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(viewController: self, trackModel: track)
    }
    
}

// MARK: - PlayListHeaderCollectionReusableViewDelegate

extension PlayListDetailViewController : PlayListHeaderCollectionReusableViewDelegate{
    
    func playListDetailHeaderProtocol(headerView: PlayListHeaderCollectionReusableView) {
        
        print("PRİNT: Playing all..")
        PlaybackPresenter.shared.startPlayback(viewController: self, tracks: tracks)
    }
    
    
}

