//
//  PlayListDetailViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 11.06.2024.
//

import UIKit

class PlayListDetailViewController: UIViewController {
    
    private var playList : PlayListModel
    
    init(playList:PlayListModel){
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
    }
    
    func fetchPlayListDetails() {
        CallerApi.shared.getFeaturedPlayListDetails(playList: playList) { result in
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
