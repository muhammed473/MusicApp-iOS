//
//  FeaturedCollectionViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 8.06.2024.
//

import UIKit

class FeaturedCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "FeaturedCollectionViewCell"
    private let featuredImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let creatorLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(featuredImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(creatorLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 100
        creatorLabel.frame = CGRect(x: 3, y: contentView.height - 43,
                                    width: contentView.width - 6, height: 30)
        nameLabel.frame = CGRect(x: 3, y: contentView.height - 86,
                                    width: contentView.width - 6, height: 30)
        featuredImageView.frame = CGRect(x: (contentView.width - imageSize) / 2, y: 3,
                                         width: imageSize, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        creatorLabel.text = nil
    }
    
    func configureFeatured(viewModel : FeaturedPlaylistCellViewModel){
        
        featuredImageView.sd_setImage(with: viewModel.featuredImageURL,completed: nil)
        nameLabel.text = viewModel.name
        creatorLabel.text = viewModel.creatorName
    }
    
}
