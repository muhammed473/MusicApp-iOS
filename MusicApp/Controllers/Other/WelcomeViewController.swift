//
//  WelcomeViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 1.0
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()
    private let overlayView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    private let my_LogoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "musicLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let descriptionlabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28,weight: .semibold)
        label.text = "You can listen to hundreds of thousands of songs.."
        return label
    }()
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemPurple
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        view.addSubview(descriptionlabel)
        view.addSubview(my_LogoImageView)
        signInButton.addTarget(self, action: #selector(touchSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        signInButton.frame = CGRect(x: 25,
                                    y:view.height-45-view.safeAreaInsets.bottom,
                                    width: view.width-38,
                                    height: 45)
        my_LogoImageView.frame = CGRect(x: (view.width - 120)/2, y: (view.height-600), width: 118, height: 118)
        descriptionlabel.frame = CGRect(x: 30, y: my_LogoImageView.bottom+30, width: view.width-60, height: 150)
    }
    
    // MARK: - Assistants
    
    private func logIn(success: Bool){
       
        guard success else {
            let alert = UIAlertController(title: "Error", message: "Could not log in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert,animated: true)
            return
        }
        let MainTabBarVc = TabBarViewController()
        MainTabBarVc.modalPresentationStyle = .fullScreen
        present(MainTabBarVc,animated: true)
        
        
    }
    
    // MARK: - Actions
    
    @objc func touchSignIn() {
        
        let vc = AuthenticationViewController()
        vc.completion = { [weak self] success in
            DispatchQueue.main.async {
                self?.logIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
