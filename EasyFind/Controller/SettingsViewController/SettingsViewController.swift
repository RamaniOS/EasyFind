//
//  SettingsViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class SettingsViewController: AbstractViewController {
    
    @IBOutlet weak var infoContainer: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        guard let userName = UserStore.currentUser else { return }
        let (isUser, user) = UserStore.isUserExist(user: userName)
        if isUser {
            userNameLabel.text = user?.userName
            fullNameLabel.text = user?.name
        }
        Helper.applyGradient(to: logoutButton)
        infoContainer.addShadow(color: UIColor.lightGray.cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.4, radius: 5)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        UserStore.isLogin = false
        UserStore.currentUser = nil
        ActionShowLogin.execute()
    }
}
