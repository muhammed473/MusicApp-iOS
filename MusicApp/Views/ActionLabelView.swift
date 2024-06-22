//
//  ActionLabelView.swift
//  MusicApp
//
//  Created by muhammed dursun on 22.06.2024.
//

import UIKit

struct ActionLabelViewModel{
    let text : String
    let actionTitle : String
}
protocol ActionLabelViewDelegate : AnyObject{
    func touchButton(actionLabelView: ActionLabelView)
}

class ActionLabelView : UIView{
    
    // MARK: - Properties
    
    weak var delegate : ActionLabelViewDelegate?
    private let mylabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    private let mybutton : UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        clipsToBounds = true
        addSubview(mylabel)
        addSubview(mybutton)
        mybutton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mybutton.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        mylabel.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
    }
    
    // MARK: - Assistants
    
    func configure(viewModel : ActionLabelViewModel){
        
        mylabel.text = viewModel.text
        mybutton.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc func actionButton(){
        delegate?.touchButton(actionLabelView: self)
    }
    
}
