//
//  TitleHeaderCollectionReusableView.swift
//  MusicApp
//
//  Created by muhammed dursun on 13.06.2024.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifer = "TitleHeaderCollectionReusableView"
    private let titleLabel : UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 23,weight: .regular)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: width - 20 , height: height)
    }
    
    // MARK: - Assistants
    
    func configure(title : String){
        titleLabel.text = title
    }
        
}
