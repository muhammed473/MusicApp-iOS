//
//  ProfileViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var userProfileModelValues = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchProfileInfos()
        title = "PROFİLE"
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    private func fetchProfileInfos(){
        
        CallerApi.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileModel):
                    self?.updateUI(userProfileModel:userProfileModel)
                case .failure(let error):
                    self?.failedGetProfile()
                }
            }
            
        }
    }
    
    private func updateUI(userProfileModel: UserProfileModel){
        tableView.isHidden = false
        userProfileModelValues.append("Full Name : \(userProfileModel.display_name)")
        userProfileModelValues.append("Email : \(userProfileModel.email)")
        userProfileModelValues.append("User id : \(userProfileModel.id)")
        userProfileModelValues.append("Country: \(userProfileModel.country)")
        userProfileModelValues.append("Product : \(userProfileModel.product)")
        configureTableHeaderPhoto(string: userProfileModel.images.first?.url)
        tableView.reloadData()
    }
    
    private func configureTableHeaderPhoto(string:String?){
        
        guard let urlString = string, let url = URL(string: urlString) else { return }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/1.5))
        let imageSize : CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 1.8
        imageView.sd_setImage(with: url,completed: nil)
        tableView.tableHeaderView = headerView
    }
     
    private func failedGetProfile(){
        
        let label = UILabel()
        label.text = "Failed to load Profile."
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
    
}

// MARK: - UITableViewDelegate

extension ProfileViewController : UITableViewDelegate{
    
    
}

// MARK: - UITableViewDataSource

extension ProfileViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfileModelValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userProfileModelValues[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}


