//
//  SettingsViewController.swift
//  instagram
//
//  Created by Jahongir Anvarov on 04.10.2021.
//

import UIKit

struct SettingCellModel{
    let title: String
    let handle: (()-> Void)
}

//ViewController to show user settings
final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
  
     func viewDidLayoutSubview(){
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    private func configureModels(){
        print("111111")
        let section = [
            SettingCellModel(title: "Log out"){ [weak self] in
                //self?.didTapLogOut()
                self?.didTapLogOut()
                print("LOG OUT")
            }
        ]
        data.append(section)
        print("22222")
    }

    private func didTapLogOut(){
        AuthManager.shared.logOut(completion: { success in
            DispatchQueue.main.async{
                if success {
                   //present log in
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true) {
                        self.navigationController?.popViewController(animated: false)
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                 else {
                    //completion(false)
                   // return
                }
            }
        })
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView)->Int{
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        //Handle cell selection
        let model = data[indexPath.section][indexPath.row]
        model.handle()
        // or like this
        //data[indexPath.section][indexPath.row].model.handler()
    }
}

