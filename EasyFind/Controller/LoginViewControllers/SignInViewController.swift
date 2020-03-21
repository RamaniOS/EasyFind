//
//  SignInViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

/// Class for sign in new users
class SignInViewController: AbstractViewController {
    
    // MARK: IBOutlets for storyboard objects
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var signupLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // checking login status here
        guard !UserStore.isLogin else {
            ActionShowHome.execute()
            return
        }
        initViews()
    }
    
    // MARK: Init views
    private func initViews() {
        setUpUI()
    }
    
    // MARK: Init views
    private func setUpUI() {
        // add left image on textfields
        userNameTextField.addLeftImage(#imageLiteral(resourceName: "user"))
        passwordTextField.addLeftImage(#imageLiteral(resourceName: "password"))
        // set border for textfields
        Helper.setBorder(for: [userNameTextField, passwordTextField])
        // set gradient color for signin button
        Helper.applyGradient(to: signInButton)
        // add shadow to login container
        loginContainer.addShadow(color: UIColor.lightGray.cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.4, radius: 5)
        // add action for signup label
        signupLabel.actionBlock { [weak self] in
            guard let `self` = self else { return }
            self.signupLabelClicked()
        }
    }
    
    // MARK: SignIn button Action
    @IBAction func signInButtonClicked(_ sender: Any) {
        // checking all validations
        if !userNameTextField.hasText {
            UIAlertController.showAlert("Error", "Please enter your username", in: self)
        } else if !passwordTextField.hasText {
            UIAlertController.showAlert("Error", "Please enter your password", in: self)
        } else {
            let isUser = UserStore.checkUserAuth(user: userNameTextField.text!, password: passwordTextField.text!)
            if isUser {
                UserStore.currentUser = userNameTextField.text!
                UserStore.isLogin = true
                ActionShowHome.execute()
            } else {
                UIAlertController.showAlert("Error", "Invalid Username/Password combination", in: self)
            }
        }
    }    
    
    // MARK: Open Signup controller
    func signupLabelClicked() {
        navigationController?.pushViewController(SignupViewController.control, animated: true)
    }    
}
