//
//  SettingViewController.swift
//  insta
//
//  Created by Jahongir Anvarov on 20.10.2021.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handler: (()-> Void)
}

class SettingViewController: UITableViewController {

    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func viewDidLayoutSubview(){
       super.viewDidLayoutSubviews()
       tableView.frame = view.bounds
   }
    
    private func configureModels(){
  
        data.append( [
            SettingCellModel(title: "Edit Profile"){ [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite friends"){ [weak self] in
                self?.didTapInviteFriends()
            },
            SettingCellModel(title: "Save Orginal Posts"){ [weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        
        data.append( [
            SettingCellModel(title: "Terms of Policy"){ [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy"){ [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Help/ Feedback"){ [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append( [
            SettingCellModel(title: "Log out"){ [weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    
    enum SettingURLType{
        case terms, privacy, help
    }
    
    func openURL(type: SettingURLType){
        let urlString: String
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/196883487377501"
        case .help: urlString = "https://help.instagram.com/"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func didTapSaveOriginalPosts(){
        
    }
    
    func didTapInviteFriends(){
        //Show share sheet to invite friends
    }
    
    func didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
    
    //////////////////////////////////////https://it-guru.kz/swift_blog/sozdayem-sektsii-v-tableview-programmno-create-section-for-tableview-swift-5///////////////////////////////////////////// / / / /
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = data[section].handler()
//    return section
//    }
    /*
    // Метод позволяет работать с секцией
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    // Изменяем фон секции
    view.tintColor = .clear

    // Изменяем цвет текста для секции
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = .gray


    // Можно ещё так, если пожелаете
    let header = view as! UITableViewHeaderFooterView
    header.backgroundView?.backgroundColor = .white
    header.textLabel?.textColor = .black
    header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
    }
*/
    private func didTapLogOut(){
        let actionSheet = UIAlertController(title: "Log Out", message: "Do you wanna log out", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async{
                    if success {
                       //present log in
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true)
                            self.navigationController?.popViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        
                    }
                     else {
                        fatalError("could not log out user")
                    }
                }
            })
            
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }
}




//extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
//}
