//
//  ViewController.swift
//  fotogma
//
//  Created by 장창순 on 2016. 3. 2..
//  Copyright © 2016년 fotogma. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var emailField: LoginTextFieldView!
    @IBOutlet var passwordField: LoginTextFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
     resignFirstResponder()
        
    }
    override func resignFirstResponder() -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult:FBSDKLoginManagerLoginResult!, facebookError:NSError!) -> Void in
            
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookLogin)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully loggen in with facebook. \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("Login Failed. \(error)")
                    } else {
                        print("Logged In!\(authData)")
                        
                        let user = ["provider": authData.provider!]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
                
            }

        }
        

    }
    
    @IBAction func attempLogin(sender:UIButton!) {
        if let email = emailField.text where email != "" , let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                       DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                        
                        if error != nil {
                            self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else")
                        } else {
                            NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                            
                            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)
                            
                            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                              
                                
                                let user = ["provider": authData.provider!]
                                DataService.ds.createFirebaseUser(authData.uid, user: user)
                            
                            })
                            
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                        
                       })
                    } else {
                        self.showErrorAlert("Could not login", msg: "Please check your username or passworkd")
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}








