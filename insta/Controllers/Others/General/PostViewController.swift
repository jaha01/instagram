//
//  PostViewController.swift
//  insta
//
//  Created by Jahongir Anvarov on 20.10.2021.
//

import UIKit
/*
 Section
  - Header model
 Section
  - Post Cell model
 Section
  - Action Button
 Section
  - n Number of general models for comments
 */


// States of a render cell
enum PostRenderType{
    case header(provider: User)
    case primaryContent(provider: UserPost) //post
    case actions(provider: String) // like, comment, share
    case comments(comments: [PostComment])
}


// Model of render Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {

    private let model: UserPost?
    
    private var renderModel = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        //register view controller
        tableView.register(IGPostFeedTableViewCell.self, forCellReuseIdentifier: IGPostFeedTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        //tableView.isHidden = false
        return tableView
    }()
    
    //MARK:  - init
    
    init(model: UserPost?){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels(){
        guard let userPostModel = self.model else {
            return
        }
        // Header
        renderModel.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        
        // Post
        renderModel.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        
        // Actions
        renderModel.append(PostRenderViewModel(renderType: .actions(provider: "")))
                                               
        //4 Comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(identifier:"123\(x)",
                                        username: "@tima",
                                        text: "great post!",
                                        createdDate: Date(),
                                        likes: []))
        }
        renderModel.append(PostRenderViewModel(renderType: .comments(comments: comments)))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}



extension PostViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModel[section].renderType {
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        case .header(_): return 1
        case .primaryContent(_): return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell()
        let model = renderModel[indexPath.section]
        
        switch model.renderType {
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGPostFeedTableViewCell.identifier, for: indexPath) as! IGPostFeedTableViewCell
            cell.configure(with: post)
            return cell
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = renderModel[indexPath.section]
        
        switch model.renderType {
        case .actions(_):
            return 60
        case .comments(_):
           return 50
        case .primaryContent(_):
            return tableView.width
        case .header(_):
            return 70
            
        }
    }
}
