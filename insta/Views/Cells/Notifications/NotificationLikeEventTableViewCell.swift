//
//  NotificationsFollowEventTableViewCell.swift
//  insta
//
//  Created by Jahongir Anvarov on 24.10.2021.
//

import UIKit

protocol NotificationLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: String)
}

class NotificationLikeEventTableViewCell: UITableViewCell {

    static let identifier = "NotificationLikeEventTableViewCell"
    
    weak var delegate: NotificationsFollowEventTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: String){
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postButton.setTitle(nil, for: .normal)
        postButton.backgroundColor = nil
        postButton.layer.borderWidth = 0
        label.text = nil
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
