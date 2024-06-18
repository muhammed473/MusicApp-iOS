//
//  DefaultTableViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 18.06.2024.
//

import UIKit

class DefaultTableViewCell : UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "DefaultTableViewCell"
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - İnit
    
    override init(style : UITableViewCell.CellStyle,reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = contentView.height - 7
        photoImageView.frame = CGRect(x: 10, y: 0, width: imageSize, height: imageSize)
        photoImageView.layer.cornerRadius = imageSize / 2
        photoImageView.layer.masksToBounds = true
        label.frame = CGRect(x: photoImageView.right + 10, y: 0, width: contentView.width - photoImageView.right - 15, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        label.text = nil
    }
    
    // MARK: - Assistants
    
    func configure(viewModel : DefaultTableViewModel){
        
        label.text = viewModel.title
        photoImageView.sd_setImage(with: viewModel.imageUrl)
    }
    
}
