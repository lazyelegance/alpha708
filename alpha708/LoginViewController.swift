//
//  LoginViewController.swift
//  alpha708
//
//  Created by Ezra Bathini on 19/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Parse
import Material




class LoginViewController: UIViewController, TextFieldDelegate {
    
    var userNameLabel = TextField()
    var passwordLabel = TextField()
    
    var loginButton = FlatButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        view.backgroundColor = pomegranate_2
        
        let viewFrame = view.frame
        
        
        userNameLabel = TextField(frame: CGRectMake(viewFrame.origin.x + 30, viewFrame.origin.x + 120, viewFrame.size.width - 60, 20))
        userNameLabel.backgroundColor = UIColor.clearColor()
        userNameLabel.placeholder = "Username".uppercaseString
        userNameLabel.placeholderTextColor = peterrock_2
        userNameLabel.font = RobotoFont.regularWithSize(15)
        userNameLabel.textColor = MaterialColor.white
        userNameLabel.textAlignment = .Center
        
        userNameLabel.titleLabel = UILabel()
        userNameLabel.titleLabel!.font = RobotoFont.mediumWithSize(10)
        userNameLabel.titleLabelColor = MaterialColor.white
        userNameLabel.titleLabelActiveColor = MaterialColor.white
        
        userNameLabel.delegate = self
        
        
        
        userNameLabel.keyboardType = UIKeyboardType.EmailAddress
        userNameLabel.returnKeyType = .Next
        
        view.addSubview(userNameLabel)
        
        passwordLabel = TextField(frame: CGRectMake(viewFrame.origin.x + 30, viewFrame.origin.x + 120 + 60, viewFrame.size.width - 60, 20))
        passwordLabel.backgroundColor = UIColor.clearColor()
        passwordLabel.placeholder = "password".uppercaseString
        passwordLabel.placeholderTextColor = peterrock_2
        passwordLabel.font = RobotoFont.regularWithSize(15)
        passwordLabel.textColor = MaterialColor.white
        passwordLabel.textAlignment = .Center
        
        passwordLabel.delegate = self
        
        passwordLabel.titleLabel = UILabel()
        passwordLabel.titleLabel!.font = RobotoFont.mediumWithSize(10)
        passwordLabel.titleLabelColor = MaterialColor.white
        passwordLabel.titleLabelActiveColor = MaterialColor.white
        
        passwordLabel.secureTextEntry = true
        
        passwordLabel.returnKeyType = .Go
        
        view.addSubview(passwordLabel)
        
        loginButton = FlatButton(frame: CGRectMake(viewFrame.origin.x + 80, viewFrame.origin.x + 120 + 60 + 60, viewFrame.size.width - 160, 40))
        loginButton.backgroundColor = MaterialColor.white
        
        
        loginButton.setTitle("LOGIN", forState: .Normal)
        
        loginButton.setTitleColor(pomegranate_2, forState: .Normal)
        loginButton.titleLabel?.font = RobotoFont.regularWithSize(10)
        loginButton.pulseColor = MaterialColor.blue.accent3
        loginButton.pulseScale = true
        loginButton.tintColor = MaterialColor.blue.accent3
        
        loginButton.addTarget(self, action: #selector(LoginViewController.loginAction), forControlEvents: .TouchUpInside)
        
//        loginButton.layer.cornerRadius = 30

        
        
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.userNameLabel) {
            self.passwordLabel.becomeFirstResponder()
        } else if (textField == self.passwordLabel) {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    func loginAction() {
        
        self.userNameLabel.resignFirstResponder()
        self.passwordLabel.resignFirstResponder()
        
        var username = self.userNameLabel.text
        var password = self.passwordLabel.text
        
        // Validate the text fields
        
        if username != nil {
            var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // Send a request to login
            
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                    
                } else {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            })
            
        } else {
            print("incorrect email")
            userNameLabel.detailLabel = UILabel()
            userNameLabel.detailLabel!.text = "Email is incorrect."
            userNameLabel.detailLabel!.font = RobotoFont.regularWithSize(12)
            userNameLabel.detailLabelActiveColor = MaterialColor.white
            
            userNameLabel.detailLabelHidden = false
        }
        
        
//        if count(username) < 5 {
//            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            
//        } else if count(password) < 8 {
//            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            
//        } else {
//            // Run a spinner to show a task in progress
//            var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
//            spinner.startAnimating()
//            
//            // Send a request to login
//            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
//                
//                // Stop the spinner
//                spinner.stopAnimating()
//                
//                if ((user) != nil) {
//                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
//                        self.presentViewController(viewController, animated: true, completion: nil)
//                    })
//                    
//                } else {
//                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()
//                }
//            })
//        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) as? NSPredicate {
            return emailTest.evaluateWithObject(testStr)
        }
        return false
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
