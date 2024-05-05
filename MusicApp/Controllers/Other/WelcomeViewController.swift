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
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemPurple
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(touchSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(x: 25,
                                    y:view.height-45-view.safeAreaInsets.bottom,
                                    width: view.width-38,
                                    height: 45)
    }
    
    // MARK: - Assistants
    
    private func logIn(success: Bool){
        // If successful, you will be logged in, otherwise an error message will be sent.
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
