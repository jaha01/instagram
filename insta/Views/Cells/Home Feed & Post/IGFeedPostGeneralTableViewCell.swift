//
//  IGFeedPostGeneralTableViewCell.swift
//  insta
//
//  Created by Jahongir Anvarov on 21.10.2021.
//

import UIKit
//Comments
class IGFeedPostGeneralTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostGeneralTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func congigure(){
        //configure cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
