//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class PlayerViewController: UIViewController {
   

    // MARK: - Properties
    
   private let photoImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
        
    }()
    private let playerControlsView = PlayerControlsView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        playerControlsView.delegate = self
        view.addSubview(photoImageView)
        view.addSubview(playerControlsView)
        configureBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoImageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        playerControlsView.frame = CGRect(x: 10, y: photoImageView.bottom + 10,
                                          width: view.width - 20,
                                          height: view.height-photoImageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-14)
    }
    
    // MARK: - Assistants
    
    private func configureBarButtons(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(touchCloseButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(touchActionButton))
    }
    
    // MARK: - Actions
    
    @objc func touchCloseButton(){

     dismiss(animated: true,completion: nil)
    }
    
    @objc func touchActionButton(){
        print("Action button clicked.")
    }
    
}

// MARK: - PlayerControlsViewDelegate

extension PlayerViewController : PlayerControlsViewDelegate{
    
    func touchPlayPauseButtonProtocol(playerControlsView: PlayerControlsView) {
        
    }
    
    func touchForwardButtonProtocol(playerControlsView: PlayerControlsView) {
        
    }
    
    func touchBackButtonProtocol(playerControlsView: PlayerControlsView) {
        
    }
    
    
}
