//
//  LibraryViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class LibraryViewController: UIViewController {

    // MARK: - Properties
    
    private let playListVc = LibraryPlayListViewController()
    private let albumVc = LibraryAlbumsViewController()
    private let scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    private let toogleView = LibraryToogleView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(toogleView)
        toogleView.delegate = self
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.width * 2, height: scrollView.height)
        addChildrenViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50,
                                  width: view.width,
                                  height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-50)
        toogleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top - 10, width: 200, height: 55)
    }
    
    // MARK: - Assistants
    
    private func addChildrenViewControllers(){
        
        addChild(playListVc)
        scrollView.addSubview(playListVc.view)
        playListVc.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playListVc.didMove(toParent: self)
        
        addChild(albumVc)
        scrollView.addSubview(albumVc.view)
        albumVc.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumVc.didMove(toParent: self)
    }
    
    // MARK: - Actions

}

// MARK: - UIScrollViewDelegate

extension LibraryViewController : UIScrollViewDelegate{
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
     // print(scrollView.contentOffset.x) // 0 - 350
        if scrollView.contentOffset.x >= (view.width - 100){
            toogleView.update(state: .album)
        }
        else{
            toogleView.update(state: .playlist)
        }
    }
}

// MARK: - ToogleViewDelegate

extension LibraryViewController : ToogleViewDelegate{
    
    func touchPlayListButton(toogleView: LibraryToogleView) {
        
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func touchAlbumButton(toogleView: LibraryToogleView) {
        
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
    
    
}
