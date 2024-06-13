//
//  AlbumTrackForCollectionViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 13.06.2024.
//

import UIKit

class  AlbumTrackForCollectionViewCell : UICollectionViewCell {
    
    
    static let identifier = "AlbumTrackForCollectionViewCell"
    let recommendationImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    let trackNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(recommendationImage)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackNameLabel.frame = CGRect(x: 10, y: 0,
                                      width: contentView.width - 15, height: (contentView.height)/2)
        artistNameLabel.frame = CGRect(x: 10, y: contentView.height/2,
                                       width: contentView.width - 15, height: contentView.height/2)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configureRecommendation(viewModel : AlbumDetailViewModel){
        
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
