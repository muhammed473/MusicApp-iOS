//
//  SubTitleTableViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 19.06.2024.
//

import UIKit

class SubTitleTableViewCell : UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "SubTitleTableViewCell"
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let subTitlelabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
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
        contentView.addSubview(subTitlelabel)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = contentView.height - 7
        let labelHeight = contentView.height / 2
        photoImageView.frame = CGRect(x: 10, y: 0, width: imageSize, height: imageSize)
       
        label.frame = CGRect(x: photoImageView.right + 10, y: 0, width: contentView.width - photoImageView.right - 15, height: labelHeight)
        subTitlelabel.frame = CGRect(x: photoImageView.right + 10, y: label.bottom, width: contentView.width - photoImageView.right - 15, height: labelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        label.text = nil
        subTitlelabel.text = nil
    }
    
    // MARK: - Assistants
    
    func configure(viewModel : SubTitleTableViewModel){
        
        label.text = viewModel.title
        photoImageView.sd_setImage(with: viewModel.imageUrl)
        subTitlelabel.text = viewModel.subTitle
    }
}
