//
//  StorageManager.swift
//  instagram
//
//  Created by Jahongir Anvarov on 07.10.2021.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public  enum IGStorageManagerError: Error{
        case failedToDownload
    }
    
    //MARK: - Public
        
    public func uploadUserPost(model: UserPost, completion: @escaping(Result<URL, Error>) -> Void){
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            completion(.success(url))
        })
    }

}

public enum UserPostType{
    case photo, video
}

//Represent a user post
public struct UserPost{
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL //either video url or full resolution photo
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let postedDate: Date
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
