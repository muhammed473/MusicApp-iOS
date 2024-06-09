//
//  NewReleasesCollectionViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 8.06.2024.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell : UICollectionViewCell{
    
    static let identifier = "NewReleasesCollectionViewCell"
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let numberOfTracksLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 19,weight: .thin)
        return label
    }()
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20,weight: .light)
        return label
    }()
    private let albumImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(albumImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = contentView.height - 10
        let albumNameLabelSize =  albumNameLabel.sizeThatFits(
            CGSize(width: contentView.width - imageSize - 10 ,height: contentView.height - 10))
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        albumImageView.sizeToFit()
       
        albumImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x:albumImageView.right + 11,y:5,
                                      width:albumNameLabelSize.width,
                                      height:min(80, albumNameLabelSize.height))
        artistNameLabel.frame = CGRect(x:albumImageView.right + 11,y:albumNameLabel.bottom + 5,
                                       width:contentView.width - albumImageView.right - 5,
                                      height:min(70, albumNameLabelSize.height))
        numberOfTracksLabel.frame = CGRect(x: albumImageView.right + 11 , y: albumImageView.bottom-35,
                                           width: numberOfTracksLabel.width + 15, height: 45)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
       
    }
    
    func configureNewReleases(viewModel: NewReleasesCellViewModel) {
        
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks : \(viewModel.numberOfTracks)"
        albumImageView.sd_setImage(with: viewModel.albumImageUrl,completed: nil)
    }
    
}
