//
//  DatabaseManager.swift
//  instagram
//
//  Created by Jahongir Anvarov on 07.10.2021.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: - Public
      
    //Check if username and email is available
    //--Parameters
    // - email String representing email
    // - email String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)->Void){
        completion(true)
    }
    
    //INsert new user data to database
    //--Parameters
    // - email String representing email
    // - email String representing username
    // - completion Async callback for result if database entry succeeded
    public func insertNewUser(with email: String, username: String, completion: @escaping(Bool)->Void){
        database.child(email.safeDatabaseKey()).setValue(["username":username]){ error, _ in
            if error == nil {
                //succeeded
                completion(true)
            }
            else {
                //failed
                completion(false)
            }
        }
    }

    
}

