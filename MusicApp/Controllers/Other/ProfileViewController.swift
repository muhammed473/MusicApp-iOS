//
//  ProfileViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PROFİLE"
        CallerApi.shared.getUserProfile { result in
            switch result {
            case .success(let userProfileModel):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
