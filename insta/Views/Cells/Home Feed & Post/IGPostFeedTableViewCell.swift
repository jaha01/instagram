//
//  IGPostFeedTableViewCell.swift
//  insta
//
//  Created by Jahongir Anvarov on 21.10.2021.
//

import UIKit
import SDWebImage
import AVFoundation

//cell for primary content
final class IGPostFeedTableViewCell: UITableViewCell {


    static let identifier = "IGPostFeedTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds  = true
        return imageView
    }()
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       // contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost){
        //configure cell
        postImageView.image = UIImage(named: "test")
        
        return
        
        switch post.postType {
        case .photo:
            //show issue
            postImageView.sd_setImage(with: post.postURL, completed: nil)
        case .video:
            // load and play
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
        postImageView.frame = contentView.bounds
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
}
