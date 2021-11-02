//
//  NotificationViewController.swift
//  insta
//
//  Created by Jahongir Anvarov on 20.10.2021.
//

import UIKit

enum UserNotificationType{
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification{
    let type: UserNotificationType
    let text: String
    let user: User
}

final class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationsFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationsFollowEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationsView = NotificationsView()
    
    private var models = [UserNotification]()
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchNotifications()
        
        navigationItem.title = "Notifications"
        view.addSubview(tableView)
        //view.addSubview(spinner)
        //spinner.startAnimating()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    /*private func fetchNotifications(){
        for x in 0...100 {
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.google.com")!,
                            postURL: URL(string: "https://www.google.com")!,
                            caption: nil,
                            likeCount: [],//"shuha",'yusuf','ilhom'],
                            comments: [],//"cool photo", "pretty photo"],
                            postedDate: Date(),//(02.02.12),
                            taggedUsers: ["gulya", "kto-to"])
        
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow,
                                         text: "Hello",
                                         user: User(username: "username",
                                                    bio: "bio",
                                                    name: (first: "first", last: "last"),
                                                    birthDate: Date(),//("01-08-1995"),
                                                    gender: .male,
                                                    counts: UserCount(followers: 150,
                                                                      following: 100,
                                                                      posts: 23),
                                                    joinDate: Date(),//(01.01.2021),
                                                    profilePhoto: URL(string: "https://www.google.com")!))
            models.append(model)
        }
    }*/
    
    
    
    private func fetchNotifications(){
        for x in 0...100 {
          let user = User(username: "jaha",
                          bio: "",
                          name: (first: "", last: ""),
                          profilePhoto: URL(string: "http://www.google.com")!,
                          birthDate: Date(),
                          gender: .male,
                          counts: UserCount(followers: 1, following: 1, posts: 1),
                          joinDate: Date())
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "http://www.google.com")!,
                                postURL: URL(string: "http://www.google.com")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                postedDate: Date(),
                                taggedUsers: [],
                                owner: user)
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_follwing),
                                         text: "Hello world",
                                         user: user)
        
        models.append(model)
        
        }
    }
    
    
    private func addNoNotificationsView(){
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            //like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            //follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsFollowEventTableViewCell.identifier, for: indexPath) as! NotificationsFollowEventTableViewCell
          //  cell.configure(with: model)
            cell.delegate = self
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension NotificationViewController: NotificationLikeEventTableViewCellDelegate{
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never get called")
        }
        //print("Tapped Post Button")
        //open post

        
    }
}


extension NotificationViewController: NotificationsFollowEventTableViewCellDelegate{
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("tapped button")
        // perform DB update
    }
    
}
