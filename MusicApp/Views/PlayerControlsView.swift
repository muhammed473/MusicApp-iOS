//
//  PlayerControlsView.swift
//  MusicApp
//
//  Created by muhammed dursun on 19.06.2024.
//

import UIKit

protocol PlayerControlsViewDelegate : AnyObject{
    
    func touchPlayPauseButtonProtocol(playerControlsView : PlayerControlsView)
    func touchForwardButtonProtocol(playerControlsView : PlayerControlsView)
    func touchBackButtonProtocol(playerControlsView : PlayerControlsView)
    func touchVolumeSliderProtocol(playerControlsView : PlayerControlsView, slideResultValue : Float)
}

final class PlayerControlsView : UIView{
    
    // MARK: - Properties
    
    weak var delegate : PlayerControlsViewDelegate?
    private var isPlaying : Bool = true
    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    private let nameLabel : UILabel = {
       let label = UILabel()
        label.text = "Sevdiğim Şarkı"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 19,weight: .semibold)
        return label
    }()
    private let subTitleLabel : UILabel = {
       let label = UILabel()
        label.text = "Subtitle"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17,weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    private let backButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 33,weight: .regular)), for: .normal)
        return button
    }()
    private let forwardButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 33,weight: .regular)), for: .normal)
        return button
    }()
    private let playPauseButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 33,weight: .regular)), for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(volumeSlider)
        addSubview(nameLabel)
        addSubview(subTitleLabel)
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(playPauseButton)
        clipsToBounds =  true
        forwardButton.addTarget(self, action: #selector(touchForwardButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(touchBackButton), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(touchPlayPauseButton), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(touchVolumeSlider), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subTitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subTitleLabel.bottom+20, width: width-20, height: 44)
        let buttonSize : CGFloat = 55
        playPauseButton.frame = CGRect(x: (width-buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-110, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: playPauseButton.left+110, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    // MARK: - Assistants
    
    func configure(viewModel : PlayerControlsViewModel){
        
        nameLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
    
    // MARK: - Actions
    
    @objc private func touchBackButton(){
        delegate?.touchBackButtonProtocol(playerControlsView: self)
    }
    
    @objc private func touchForwardButton(){
        delegate?.touchForwardButtonProtocol(playerControlsView: self)
    }
    
    @objc private func touchPlayPauseButton(){
        
        self.isPlaying = !isPlaying
        delegate?.touchPlayPauseButtonProtocol(playerControlsView: self)
        // Update Image..
       let pauseImage = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 33,weight: .regular))
       let playImage = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 33,weight: .regular))
        playPauseButton.setImage(isPlaying ? pauseImage : playImage, for: .normal)
    }
    
    @objc private func touchVolumeSlider(slider : UISlider){
        
        let value = slider.value
        delegate?.touchVolumeSliderProtocol(playerControlsView: self, slideResultValue: value)
    }
    
}
