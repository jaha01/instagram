//
//  ViewController.swift
//  instagram
//
//  Created by Jahongir Anvarov on 04.10.2021.
//

import UIKit
import Firebase

struct HomeFeedRenderViewModel{
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {

    private var feedRenderModel = [HomeFeedRenderViewModel]()
    
    private let tableView : UITableView = {
       let tableView = UITableView()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: IGPostFeedTableViewCell.identifier)
        tableView.register(IGPostFeedTableViewCell.self, forCellReuseIdentifier: IGPostFeedTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // handleNotAuthenticated()
        
        if Auth.auth().currentUser == nil {
            //Show login
        let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false)

            }
        
//        do {
//            try Auth.auth().signOut()
//        }
//        catch {
//            print("failed to sign out")
//        }

        }
    }

    
    private func handleNotAuthenticated(){
        //Check auth status
        
        if Auth.auth().currentUser == nil {
            //Show login
        let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
        //    self.present(loginVC, animated: false)
            
        

        }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IGPostFeedTableViewCell.identifier, for: indexPath) as! IGPostFeedTableViewCell
        return cell
    }
}
