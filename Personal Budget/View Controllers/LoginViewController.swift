//
//  LoginViewController.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 10/19/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import LocalAuthentication


class LogInViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    

    
    var ref: DatabaseReference!
    
    let googleBtn: GIDSignInButton = {
        let button = GIDSignInButton()
        button.frame = CGRect(x: 16, y: 116, width: 240, height: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let inputContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let buttonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        //textField.textAlignment = center
        return textField
    }()
    
    let loginRegisterSegControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["Login","Register"])
        segControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segControl
    }()
    
    let loginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(inputContainer)
        view.addSubview(buttonContainer)
        //view.addSubview(googleBtn)
        
        setupInputContainer()
        setupButtonContainer()
        setupGoogleBtn()
        print("At login screen")
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil && user?.uid != nil{
                self.performSegue(withIdentifier: "goToMainMenu", sender: nil)
            }
        }
        
        //touchIDLogin()
        
    }
    
    func setupInputContainer() {
        //inputContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true

        inputContainer.addSubview(nameTextField)
        inputContainer.addSubview(nameSeperator)
        inputContainer.addSubview(emailTextField)
        inputContainer.addSubview(emailSeperator)
        inputContainer.addSubview(passwordTextField)

        
        setupNameTextField()
        setupNameSeperator()
        setupEmailTextField()
        setupEmailSeperator()
        setupPasswordTextField()

    }
    
    func setupButtonContainer() {
        buttonContainer.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 25).isActive = true
        buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 144).isActive = true
        
        buttonContainer.addSubview(loginRegisterSegControl)
        buttonContainer.addSubview(loginBtn)
        buttonContainer.addSubview(googleBtn)
        
        setupLoginRegisterSegControl()
        setupLoginButton()
        setupGoogleBtn()
    }
    

    
    func setupNameTextField() {
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        nameTextField.placeholder = "Name"
    }
    
    func setupNameSeperator() {
        nameSeperator.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        nameSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupEmailTextField() {
        emailTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        emailTextField.placeholder = "Email"
    }
    
    func setupEmailSeperator() {
        emailSeperator.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperator.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        passwordTextField.placeholder = "Password"
    }
    
    func setupLoginRegisterSegControl() {
        loginRegisterSegControl.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
        loginRegisterSegControl.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        loginRegisterSegControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginRegisterSegControl.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupLoginButton() {
        loginBtn.topAnchor.constraint(equalTo: loginRegisterSegControl.bottomAnchor).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: loginRegisterSegControl.centerXAnchor).isActive = true
        loginBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loginBtn.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor, multiplier: 1/3).isActive = true
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    

    func setupGoogleBtn() {
        GIDSignIn.sharedInstance().uiDelegate = self
        googleBtn.centerXAnchor.constraint(equalTo: loginBtn.centerXAnchor).isActive = true
        googleBtn.centerYAnchor.constraint(equalTo: loginBtn.centerYAnchor, constant: 48).isActive = true
    }
    
    @objc func loginBtnClick() {
        loginUser()
        //loginRegister()
        //self.performSegue(withIdentifier: "goToNewAccount", sender: nil)
    }
    

    func loginRegister() {
        if loginRegisterSegControl.selectedSegmentIndex == 0 {
            loginUser()
        } else {
            registerUser()
        }
    }
    
//Login User
    func loginUser() {
//        guard let email = emailTextField.text, let password = passwordTextField.text else {
//            return
//        }
        let email = "test@test.com"
        let password = "123test"
        
        
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                self.performSegue(withIdentifier: "goToMainMenu", sender: nil)
            }
        }
        
    }
    
//Register User
    func registerUser() {
//        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
//            return
//        }
        let name = "Test Account"
        let email = "test@test.com"
        let password = "123test"
        print("Register function")
        Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
            if error != nil {
                print(error as Any)
                return
            }
            print("Created User")
            
            self.ref = Database.database().reference()
            guard let uid = user?.uid else { return }
            let userReference = self.ref.child("Users").child(uid)
            let values = ["name": name, "email" : email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
                
                
                print("Saved user into firebase")
            })
            self.performSegue(withIdentifier: "goToNewAccount", sender: nil)
        })
        
    }
    

}
