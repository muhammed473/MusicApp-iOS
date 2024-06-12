//
//  PlayListHeaderCollectionReusableView.swift
//  MusicApp
//
//  Created by muhammed dursun on 12.06.2024.
//

import UIKit
import SDWebImage

protocol PlayListHeaderCollectionReusableViewDelegate : AnyObject {
    func playListDetailHeaderProtocol(headerView: PlayListHeaderCollectionReusableView)
}

final class PlayListHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifer = "PlayListHeaderCollectionReusableView"
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        return label
    }()
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20,weight: .regular)
        return label
    }()
    private let ownerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 20,weight: .light)
        return label
    }()
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")
        return imageView
    }()
    private let playButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        let image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 35,weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        return button
    }()
    weak var delegate : PlayListHeaderCollectionReusableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    //  backgroundColor = .blue
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(touchPlayButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = height/1.7
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 70,width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom , width: width - 20, height: 50)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-10, height: 50)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom , width: width-20,height: 50)
        playButton.frame = CGRect(x:  width - 100,y:ownerLabel.bottom - 25 , width: 60, height: 60)
    }
    
    func configure(viewModel : PlayListDetailHeaderForViewModel){
        
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.owner
        imageView.sd_setImage(with: viewModel.imageForUrl)
    }
    
    // MARK: - Actions
    
    @objc func touchPlayButton() {
        
        delegate?.playListDetailHeaderProtocol(headerView: self)
    }
    
}
