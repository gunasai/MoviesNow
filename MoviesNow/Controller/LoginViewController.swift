//
//  ViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/5/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.returnKeyType = UIReturnKeyType.next
        passwordTextField.returnKeyType = UIReturnKeyType.done
        setCustomStylesForTextFields(for: [usernameTextField, passwordTextField])
        setCustomButtonStyles(for: [loginButton, loginViaWebsiteButton])
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        TMDBClient.getRequestToken(completionHandler: handleRequestTokenResponse(success:error:))
    }
    
    @IBAction func loginViaWebsiteTapped(_ sender: Any) {
        setLoggingIn(true)
        TMDBClient.getRequestToken { (success, error) in
            if success {
                UIApplication.shared.open(TMDBClient.EndPoints.webAuth.url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

    
    // MARK: Set Custom Styles
    
    func setCustomStylesForTextFields(for textFields: [JVFloatLabeledTextField]) {
        for textField in textFields {
            textField.bottomBorder(textFieldWidth: self.view.frame.width)
        }
    }
    
    func setCustomButtonStyles(for buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 5
        }
    }
    
    // MARK: Completion Handlers
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            print(TMDBClient.Auth.reqestToken)
            print(self.usernameTextField.text ?? "")
            TMDBClient.login(username:
                self.usernameTextField.text ?? "", password:
                self.passwordTextField.text ?? "", completionHandler:
                self.handleLoginResponse(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print(TMDBClient.Auth.reqestToken)
        if success {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            TMDBClient.createSessionId(completionHandler: handleSessionResponse(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        usernameTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginViaWebsiteButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }

    
}

