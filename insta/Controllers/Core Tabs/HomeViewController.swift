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
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createMockModels(){
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
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(PostComment(identifier: "\(x)",
                                        username: "@jenny",
                                        text: "the best post i've seen",
                                        createdDate: Date(),
                                        likes: []))
        }
        
        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModel.append(viewModel)
        }
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
        return feedRenderModel.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModel[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x%4))/4)
            model = feedRenderModel[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            //header
            return 1
        }
        else if subSection == 1 {
            //post
            return 1
        }
        else if subSection == 2 {
            //actions
            return 1
        }
        else if subSection == 3 {
            // comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .actions, .header, .primaryContent: return 0
                //@unknown default: fatalError("Invalid case")
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell()
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModel[0]
        } else {
            let position = x % 4 == 0 ? x/4 : ((x - (x%4))/4)
            model = feedRenderModel[position]
        }
        
        
        let subSection = x % 4
        
        if subSection == 0 {
            //header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
                // @unknown default: fatalError("Invalid case")
            case .actions, .comments, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            //post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGPostFeedTableViewCell.identifier, for: indexPath) as! IGPostFeedTableViewCell
                cell.configure(with: post)
                return cell
                // @unknown default: fatalError("Invalid case")
            case .actions, .header, .comments: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            //actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                cell.delegate = self
                return cell
                //@unknown default: fatalError("Invalid case")
            case .comments, .header, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 3 {
            // comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
                // @unknown default: fatalError("Invalid case")
            case .actions, .header, .primaryContent: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let subSection = indexPath.section % 4
        if subSection == 0 {
            return 70
        }
        else if subSection == 1 {
            return tableView.width
        }
        else if subSection == 2 {
            return 60
        }
        else if subSection == 3 {
            return 50
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}


extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "post options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    func reportPost(){
        
    }
}

extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("like")
//        IGFeedPostActionsTableViewCell.
    }
    
    func didTapCommentButton() {
        print("comment")
    }
    
    func didTapSendButton() {
        print("send")
    }
    
}
