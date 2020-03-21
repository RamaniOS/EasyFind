//
//  UserStore.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Foundation
import CoreData

class UserStore {
    
    private init() {}
    
    private static let isLoginKey = "isLoginKey"
    private static let userNameKey = "userNameKey"
    
    // MARK: Set/get current user (work as a primary id)
    public static var currentUser: String? {
        get {
            return UserDefaults.standard.string(forKey: userNameKey)
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: userNameKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: userNameKey)
            }
        }
    }
    
    // MARK: - Check login status
    public static var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isLoginKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isLoginKey)
        }
    }
    
    // MARK: Create new user in database
    static func createUser(user uName: String, name fName: String, password: String) {
        let manager = PersistenceManager.shared
        let user = User(context: manager.context)
        user.userName = uName
        user.password = password
        user.name = fName
        manager.saveContext()
    }
    
    // MARK: Create method to check user name is exist or not (Tupple)
    static func isUserExist(user name: String) -> (Bool, User?) {
        let manager = PersistenceManager.shared
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userName = %@", name)
        request.includesSubentities = false
        do {
            let objects = try manager.context.fetch(request)
            for user in objects where user.userName == name {
                return (true, user)
            }
        } catch {
            return (false, nil)
        }
        return (false, nil)
    }
    
    // MARK: Check user auth for login
    static func checkUserAuth(user name: String, password: String) -> Bool {
        let manager = PersistenceManager.shared
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userName = %@ AND password = %@", name, password)
        request.includesSubentities = false
        do {
            let objects = try manager.context.fetch(request)
            return objects.count > 0
        } catch {
            return (false)
        }
    }
}
