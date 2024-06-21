//
//  LibraryToogleView.swift
//  MusicApp
//
//  Created by muhammed dursun on 21.06.2024.
//

import UIKit

protocol ToogleViewDelegate : AnyObject{
    func touchPlayListButton(toogleView:LibraryToogleView)
    func touchAlbumButton(toogleView:LibraryToogleView)
}

class LibraryToogleView : UIView{
    
    // MARK: - Enum (Indicator For)
    
    enum State {
        case playlist
        case album
    }
    
    // MARK: - Properties
    
    var state : State = .playlist // Default
    private let playListButton : UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("PlayList", for: .normal)
        return button
    }()
    private let albumButton : UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Album", for: .normal)
        return button
    }()
    weak var delegate : ToogleViewDelegate?
    private let indicatorView : UIView = {
       let indicatorView = UIView()
        indicatorView.backgroundColor = .red
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = 5
        return indicatorView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playListButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        playListButton.addTarget(self, action: #selector(actionPlayListButton), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(actionAlbumButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playListButton.frame = CGRect(x: 0, y: 0, width: 100, height: 56)
        albumButton.frame = CGRect(x: playListButton.right, y: 0, width: 100, height: 56)
        configureLayoutIndicator()
    }
    
    // MARK: - Assistants
    
    private func configureLayoutIndicator(){
        
        switch state{
            
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playListButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x:100, y: albumButton.bottom, width: 100, height: 3)
        }
    }
    
    func update(state : State){
        
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.configureLayoutIndicator()
        }
    }
    
    // MARK: - Actions
    
    @objc func actionPlayListButton(){
        
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.configureLayoutIndicator()
        }
        delegate?.touchPlayListButton(toogleView:self)
    }
    
    @objc func actionAlbumButton(){
        
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.configureLayoutIndicator()
        }
        delegate?.touchAlbumButton(toogleView:self)
    }
    
}
