//
//  ViewController.swift
//  instagram
//
//  Created by Jahongir Anvarov on 04.10.2021.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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


