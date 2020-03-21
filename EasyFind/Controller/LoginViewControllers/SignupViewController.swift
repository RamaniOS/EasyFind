//
//  SignupViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

/// Class for sign up exisitng users
class SignupViewController: AbstractViewController {
    
    // MARK: IBOutlets for storyboard objects
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupContainer: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    // MARK: Init views
    private func initViews() {
        setUpUI()
    }
    
    // MARK: Init views
    private func setUpUI() {
        // set left padding for text fields
        Helper.setLeftPadding(textFields: [userNameTextField, nameTextField, passwordTextField, confirmPasswordTextField], 10)
        // set border for textfields
        Helper.setBorder(for: [userNameTextField, nameTextField, passwordTextField, confirmPasswordTextField])
        // set gradient color for signin button
        Helper.applyGradient(to: signupButton)
        // add shadow to login container
        signupContainer.addShadow(color: UIColor.lightGray.cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.4, radius: 5)
    }
    
    // MARK: Signup button action
    @IBAction func signupButtonClicked(_ sender: Any) {
        // checking all validations
        if !userNameTextField.hasText {
            UIAlertController.showAlert("Error", "Please enter your username", in: self)
        } else if !nameTextField.hasText {
            UIAlertController.showAlert("Error", "Please enter your name", in: self)
        } else if !passwordTextField.hasText {
            UIAlertController.showAlert("Error", "Please enter your password", in: self)
        } else if !confirmPasswordTextField.hasText {
            UIAlertController.showAlert("Error", "Please enter confirm password", in: self)
        } else if passwordTextField.text!.count < 6 || passwordTextField.text!.count > 8 {
            UIAlertController.showAlert("Error", "Password should be between 6 to 8 characters", in: self)
        } else if passwordTextField.text != confirmPasswordTextField.text {
            UIAlertController.showAlert("Error", "Confirm password should be same as password", in: self)
        } else {
            let (isUser, _) = UserStore.isUserExist(user: userNameTextField.text!)
            if isUser {
                UIAlertController.showAlert("Error", "This username is already taken. Please try another one.", in: self)
                return
            }
            UserStore.createUser(user: userNameTextField.text!, name: nameTextField.text!, password: passwordTextField.text!)
            UserStore.currentUser = userNameTextField.text!
            UserStore.isLogin = true
            ActionShowHome.execute()
        }
    }
    
    // MARK: Back button action
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
