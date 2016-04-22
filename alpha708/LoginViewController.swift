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
    

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userNameLabel: TextField!
    
    @IBOutlet weak var passwordLabel: TextField!
    
    @IBOutlet weak var loginButton: FlatButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
    
        view.backgroundColor = pomegranate_2
        
        let viewFrame = view.frame
        
        view.backgroundColor = MaterialColor.teal.base
        

        headerView.backgroundColor = MaterialColor.teal.lighten1
        
        headerView.layer.cornerRadius = 5
        
        
        

        userNameLabel.backgroundColor = MaterialColor.clear
        userNameLabel.placeholder = "Username".lowercaseString
        userNameLabel.placeholderTextColor = MaterialColor.white
        userNameLabel.font = RobotoFont.regularWithSize(15)
        userNameLabel.textColor = MaterialColor.white
        userNameLabel.textAlignment = .Center
        
        userNameLabel.titleLabel = UILabel()
        userNameLabel.titleLabel!.font = RobotoFont.mediumWithSize(10)
        userNameLabel.titleLabelColor = MaterialColor.white
        userNameLabel.titleLabelActiveColor = MaterialColor.white
        
        userNameLabel.bottomBorderColor = MaterialColor.teal.darken1
        userNameLabel.layer.cornerRadius = 5
        
        userNameLabel.delegate = self
        
        
        
        userNameLabel.keyboardType = UIKeyboardType.EmailAddress
        userNameLabel.returnKeyType = .Next
        


        passwordLabel.backgroundColor = MaterialColor.clear
        passwordLabel.placeholder = "password".lowercaseString
        passwordLabel.placeholderTextColor = MaterialColor.white
        passwordLabel.font = RobotoFont.regularWithSize(15)
        passwordLabel.textColor = MaterialColor.white
        passwordLabel.textAlignment = .Center
        
        passwordLabel.delegate = self
        
        
        passwordLabel.layer.cornerRadius = 5
        passwordLabel.titleLabel = UILabel()
        passwordLabel.titleLabel!.font = RobotoFont.mediumWithSize(10)
        passwordLabel.titleLabelColor = MaterialColor.white
        passwordLabel.titleLabelActiveColor = MaterialColor.white
        userNameLabel.bottomBorderColor = MaterialColor.teal.darken1
        passwordLabel.secureTextEntry = true
        
        passwordLabel.returnKeyType = .Go
        
        passwordLabel.bottomBorderColor = MaterialColor.teal.darken1
        
        
        loginButton.backgroundColor = MaterialColor.white
        
        
        loginButton.setTitle("LOGIN", forState: .Normal)
        
        loginButton.setTitleColor(MaterialColor.teal.darken1, forState: .Normal)
        loginButton.titleLabel?.font = RobotoFont.regularWithSize(10)
        loginButton.pulseColor = MaterialColor.blue.accent3
        loginButton.pulseScale = true
        loginButton.tintColor = MaterialColor.blue.accent3
        
        loginButton.addTarget(self, action: #selector(LoginViewController.loginAction), forControlEvents: .TouchUpInside)
        
        
//        loginButton.layer.cornerRadius = 30

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.userNameLabel) {
            self.passwordLabel.alpha = 1
            self.loginButton.alpha = 1
            self.passwordLabel.becomeFirstResponder()
        } else if (textField == self.passwordLabel) {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    func loginAction() {
        
        self.userNameLabel.resignFirstResponder()
        self.passwordLabel.resignFirstResponder()
        
        let username = self.userNameLabel.text
        let password = self.passwordLabel.text
        
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

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) as? NSPredicate {
            return emailTest.evaluateWithObject(testStr)
        }
        return false
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
