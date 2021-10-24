//
//  Models.swift
//  insta
//
//  Created by Jahongir Anvarov on 22.10.2021.
//

import Foundation

enum Gender {
        case male, female, other
}

struct User {
    let username: String
    let bio: String
    let name:(first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
    let profilePhoto: URL
}

struct UserCount{
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType{
    case photo, video
}

//Represent a user post
public struct UserPost{
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL //either video url or full resolution photo
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let postedDate: Date
    let taggedUsers: [String]
    
}


struct PostLike {
    let username: String
    let postIdentifier: String
}


struct CommentLike{
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}
