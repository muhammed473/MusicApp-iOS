//
//  PlaybackPresenter.swift
//  MusicApp
//
//  Created by muhammed dursun on 19.06.2024.
//

import UIKit

final class PlaybackPresenter{
    
    static func startPlayback(viewController : UIViewController,trackModel : TracksModel){
        
        let vc = PlayerViewController()
        vc.title = trackModel.name
        viewController.present(UINavigationController(rootViewController: vc),animated: true)
    }
    
    static func startPlayback(viewController : UIViewController,tracks : [TracksModel]){
        
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}
