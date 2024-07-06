//
//  SettingsViewController.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
    private var sections = [Section]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingsModels()
        title = "Settings"
        view.backgroundColor = .systemBlue
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Assistants
    
    private  func configureSettingsModels(){
        
        sections.append(Section(title:"Profile",options:[Option(title:"View your profile",handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToProfileController()
            }
        })]))
        sections.append(Section(title:"Account",options:[Option(title:"Sign Out ",handler: { [weak self] in
            DispatchQueue.main.async {
                self?.touchSignOut()
            }
        })]))
    }
    
    private func goToProfileController(){
        
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func touchSignOut() {
        
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthDirector.shared.signOut { [weak self] signedOut in
                if signedOut{
                    DispatchQueue.main.async {
                        let navVC  = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true,completion: {
                            self?.navigationController?.popViewController(animated: false)
                        })
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionAndValue = sections[indexPath.section].options[indexPath.row]
        sectionAndValue.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionAndValue = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "my settings"
        return cell
    }
    
}

