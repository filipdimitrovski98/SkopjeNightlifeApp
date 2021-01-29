//
//  ViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/29/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signUpMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        nameTextField.isHidden = true
        lastnameTextField.isHidden = true
        numberTextField.isHidden = true
        birthDateTextField.isHidden = true
    }
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var login_signupButton: UIButton!
    @IBOutlet weak var switchLoginSignupButton: UIButton!
    
    let datePicker = UIDatePicker()
    
    func createDatePicker(){
        birthDateTextField.textAlignment = .center
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        birthDateTextField.inputAccessoryView = toolbar
        birthDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        
    }
    
   @IBAction func LogIn_SignUp(_ sender: Any) {
      
                  if signUpMode {
                   let user = PFUser()
                   
                   
                    if emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" || lastnameTextField.text == "" || numberTextField.text == "" || birthDateTextField.text == ""{
                       displayAlert(title: "Error in form", message: "You must provide all the informations") }
                       else {
                       user.email = emailTextField.text
                       user.username = emailTextField.text
                       user.password = passwordTextField.text
                       user.email = emailTextField.text
                       user["name"] = nameTextField.text
                       user["lastName"] = lastnameTextField.text
                       user["phoneNumber"] = numberTextField.text
                       user["birthDate"] = birthDateTextField.text
                       user["korisnik"] = "obicen"
                       
                   user.signUpInBackground { (success, error) in
                       
                    if let error = error {
                           let errorString = error.localizedDescription
                           self.displayAlert(title: "Error signing up", message: errorString)
                       } else {
                           print("Sign up success!")
                           self.performSegue(withIdentifier: "toDefektView", sender: self)
                       }
                   }
                   }
                   
                  } // signup
              else { //login
                   
                  PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                          
                          if let error = error {
                              let errorString = error.localizedDescription
                              self.displayAlert(title: "Error logging in", message: errorString)
                          } else {
                              print("Log in success!")
                           if(user!["korisnik"] as! String == "obicen"){
                               print(user!["korisnik"] as! String)
                             self.performSegue(withIdentifier: "toLokali", sender: self)
                           }
                           else if(user!["korisnik"] as! String == "menadzer") {
                             self.performSegue(withIdentifier: "toMenadzerHome ", sender: self) // TUKA SMENI
                           }
                            else if(user!["korisnik"] as! String == "admin") {
                            //print(user!["korisnik"])
                            self.performSegue(withIdentifier: "toAdminView", sender: self) // TUKA SMENI
                            }
                            
                              
                          }
                      }
                      
                  }
   }
    
    @IBAction func Switch_Screens(_ sender: Any) {
        if signUpMode {//smeni vo login
                   signUpMode = false
            
            nameTextField.isHidden = true
            lastnameTextField.isHidden = true
            numberTextField.isHidden = true
            birthDateTextField.isHidden = true
            
            
            welcomeLabel.text = "Please Log In"
                   login_signupButton.setTitle("Log In", for: .normal)
                   switchLoginSignupButton.setTitle("Switch to Sign Up", for: .normal)
                
            
               } else {//smeni vo signup
                   signUpMode = true
            
            nameTextField.isHidden = false
            lastnameTextField.isHidden = false
            numberTextField.isHidden = false
            birthDateTextField.isHidden = false
            
            welcomeLabel.text = "Please Sign Up"
                    
                   login_signupButton.setTitle("Sign Up", for: .normal)
                   switchLoginSignupButton.setTitle("Switch to Log In", for: .normal)
               }
        
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
}

