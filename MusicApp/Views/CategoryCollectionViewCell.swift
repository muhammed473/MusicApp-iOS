//
//  GenreCollectionViewCell.swift
//  MusicApp
//
//  Created by muhammed dursun on 14.06.2024.
//

import UIKit

class CategoryCollectionViewCell : UICollectionViewCell {

    // MARK: - Properties

    static let identifer = "GenreCollectionViewCell"
    private let imageView : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        image.image = UIImage(systemName: "music.quarternote.3",
                              withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return image
    }()
    private let label : UILabel = {
        let label  = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    private var colors: [UIColor] = [
        .systemPink,
        .systemPurple,
        .systemOrange,
        .systemBlue,
        .systemBrown,
        .systemYellow,
        .systemGray,
        .systemGreen
    ]

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 7
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width - 20 , height: contentView.height / 2)
        imageView.frame  = CGRect(x: contentView.width/2 - 15, y: 10, width: contentView.width/2, height: contentView.height/2 + 8)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }

    // MARK: - Assistants

    func configure(viewModel : CategoryViewModel){

        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.categoryImageURL)
        contentView.backgroundColor = colors.randomElement()
    }

}
