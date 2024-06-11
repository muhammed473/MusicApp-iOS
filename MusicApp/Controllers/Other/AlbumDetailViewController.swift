//
//  AlbumDetailViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 11.06.2024.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    private var album : Album
    
    init(album:Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        view.backgroundColor = .green
        fetchAlbumDetails()
    }
    
    func fetchAlbumDetails() {
        CallerApi.shared.getAlbumDetails(album: album) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
}
