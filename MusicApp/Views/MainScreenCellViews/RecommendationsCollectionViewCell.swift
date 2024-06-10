//
//  RecommendationsCollectionViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 8.06.2024.
//

import UIKit

class RecommendationsCollectionViewCell : UICollectionViewCell{
    
    static let identifier = "RecommendationsCollectionViewCell"
    private let recommendationImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    private let trackNameLabel : UILabel = {
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
        
        recommendationImage.frame = CGRect(x:  5 , y: 2 , width: contentView.height - 4 , height: contentView.height - 4 )
        trackNameLabel.frame = CGRect(x: recommendationImage.right + 9, y: 0,
                                      width: contentView.width - recommendationImage.right - 15, height: (contentView.height)/2)
        artistNameLabel.frame = CGRect(x: recommendationImage.right + 9, y: contentView.height/2,
                                       width: contentView.width - recommendationImage.right - 15, height: contentView.height/2)
      
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        recommendationImage.image = nil
    }
    
    func configureRecommendation(viewModel : RecommendedTrackCellViewModel){
        
        recommendationImage.sd_setImage(with: viewModel.artworkURL,completed: nil)
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
