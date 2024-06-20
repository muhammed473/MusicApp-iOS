//
//  PlaybackPresenter.swift
//  MusicApp
//
//  Created by muhammed dursun on 19.06.2024.
//

import UIKit
import AVFoundation
import Foundation

protocol PlayerDataSourceProtocol : AnyObject{
    var songName : String? {get}
    var subTitle : String? {get}
    var imageUrl : URL? {get}
}

final class PlaybackPresenter{
    
    //  MARK: - Properties
    
    static let shared = PlaybackPresenter()
    var avPlayer : AVPlayer?
    var playerQueue : AVQueuePlayer?
    private var trackModel : TracksModel?
    private var tracks = [TracksModel]()
    var currentTrack : TracksModel?{
        if let track = trackModel, tracks.isEmpty{
            return track
        }
        else if let playerQueue = self.playerQueue, !tracks.isEmpty{
            let item = playerQueue.currentItem
            let items = playerQueue.items()
            guard let index = items.firstIndex(where: {$0 == item })else{
                return nil
            }
            return tracks[index]
        }
        return nil
    }
    
    // MARK: - Assistants
    
    func startPlayback(viewController : UIViewController,trackModel : TracksModel){
        
        guard let url = URL(string: trackModel.preview_url ?? "") else {return}
        avPlayer = AVPlayer(url: url)
        avPlayer?.volume = 0.0
        self.trackModel = trackModel
        self.tracks = []
        let vc = PlayerViewController()
        vc.playerDataSourceProtocol = self
        vc.delegate = self
        vc.title = trackModel.name
        viewController.present(UINavigationController(rootViewController: vc),animated: true) { [weak self]  in
            self?.avPlayer?.play()
        }
        
    }
    
    func startPlayback(viewController : UIViewController,tracks : [TracksModel]){
        
        self.tracks = tracks
        self.trackModel = nil
        
        let items : [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string:$0.preview_url ?? "")else{
                return nil
            }
            return AVPlayerItem(url: url)
        })
        self.playerQueue = AVQueuePlayer(items: items)
       /* self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return  AVPlayer(url: url)
        })) */
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        let vc = PlayerViewController()
        vc.playerDataSourceProtocol = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}

// MARK: - PlayerDataSourceProtocol

extension PlaybackPresenter : PlayerDataSourceProtocol{
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subTitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

// MARK: - PlayerViewControllerDelegate

extension PlaybackPresenter : PlayerViewControllerDelegate{
    
    func touchPlayPause() {
        
        if let avPlayer = avPlayer{
            if avPlayer.timeControlStatus == .playing{
                avPlayer.pause()
            }
            else if avPlayer.timeControlStatus == .paused{
                avPlayer.play()
            }
        }
        else if let playerQueue = playerQueue {
            if playerQueue.timeControlStatus == .playing{
                playerQueue.pause()
            }
            else if playerQueue.timeControlStatus == .paused{
                playerQueue.play()
            }
        }
    }
    
    func touchForward() {
        
        if tracks.isEmpty{
            avPlayer?.pause()
            
        }
        else if let playerQueue = playerQueue{
           playerQueue.advanceToNextItem() // Go next song.
        }
    }
    
    func touchBack() {
        
        if tracks.isEmpty{
            avPlayer?.pause()
            avPlayer?.play()
        }
        else if let firstItem = playerQueue?.items().first{
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem]) // Go back to first song.
            playerQueue?.play()
        }
    }
    
    func touchSlider(resultValue: Float) {
        avPlayer?.volume = resultValue
    }
    
    
}
