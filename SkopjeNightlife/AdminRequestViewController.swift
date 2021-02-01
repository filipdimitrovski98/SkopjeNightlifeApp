//
//  AdminRequestViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/31/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse


class AdminRequestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(sendaplikacijaId)
        //print(sendobjectId)
        updatedata()
        
    }
    
    
    @IBOutlet weak var imeLabel: UILabel!
    
    @IBOutlet weak var prezimeLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var vozrastLabel: UILabel!
    
    @IBOutlet weak var lokalLabel: UILabel!
    
    @IBOutlet weak var imelokalLabel: UILabel!
    
    var lokalId = String()
    var pressed = false
    @IBAction func prifatiPressed(_ sender: Any) {
        if pressed {
           displayAlert(title: "Failed", message: "Already accepted")
        }
        else {
            let query = PFQuery(className: "Lokal")
                   query.whereKey("objectId", equalTo: sendlokalId)
                   query.findObjectsInBackground(block: { (objects,error) in
                       if error != nil {
                           print(error?.localizedDescription ?? "")
                       }
                       else if let objects = objects {
                           let object = objects[0]
                           object["menadzer"] = sendobjectId
                           object.saveInBackground()
                           print("Uspesno postavuvanje na menadzer na lokal")
                           
                           let queryy = PFQuery(className: "Aplikacija")
                           queryy.whereKey("objectId", equalTo: sendaplikacijaId)
                           queryy.findObjectsInBackground(block: { (objects2,error2) in
                               if error2 != nil {
                                   print(error2?.localizedDescription ?? "")
                               }
                               else if let objects2 = objects2 {
                                   let object2 = objects2[0]
                                   object2["status"] = "Potvrdena"
                                   object2.saveInBackground()
                                   print("Uspesno postavuvanje na menadzer na lokal")
                                   
                                   
                               }
                           })
                           
                           
                       }
                   })
            pressed = true
        }
       
        
    }
    
    @IBAction func odbijPressed(_ sender: Any) {
        
        let queryy = PFQuery(className: "Aplikacija")
        queryy.whereKey("objectId", equalTo: sendaplikacijaId)
        queryy.findObjectsInBackground(block: { (objects2,error2) in
            if error2 != nil {
                print(error2?.localizedDescription ?? "")
            }
            else if let objects2 = objects2 {
                let object2 = objects2[0]
                object2["status"] = "Odbiena"
                object2.saveInBackground()
                print("Uspesno odbivanje na menadzer na lokal")
                
                
            }
        })
        
    }
    func updatedata(){
        
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: sendobjectId)
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let users = users {
                for object in users {
                    if let user = object as? PFUser{
                        if let name = user["name"] { //print(name)
                            if let lastname = user["lastName"] { //print(lastname)
                                //print(user.username as! String)
                                let email = user.username!; print(email)
                                // if email != nil { print(email)
                                if let telefon = user["phoneNumber"] {
                                    if let date = user["birthDate"] { print(date)
                                        
                                        self.emailLabel.text = email
                                        self.imeLabel.text = name as! String
                                        self.prezimeLabel.text = lastname as! String
                                        self.telefonLabel.text = telefon as! String
                                        self.vozrastLabel.text = date as! String
                                        
                                       // print("Stignav tuka")
                                        let birthDate = user["birthDate"] as! String
                                        //print(birthDate)
                                        let dateFormatterGet = DateFormatter()
                                        dateFormatterGet.dateFormat = "MMM dd, yyyy"
                                        
                                        
                                        if let date = dateFormatterGet.date(from: birthDate ) {
                                           // print("Ova \(date)")
                                           
                                            let today = Date()
                                            
                                            //3 - create an instance of the user's current calendar
                                            let calendar = Calendar.current
                                            
                                            //4 - use calendar to get difference between two dates
                                            let components = calendar.dateComponents([.year, .month, .day], from: date,to: today)
                                            
                                            let ageYears = components.year
                                            self.vozrastLabel.text = "\(ageYears!) godini"
                                           
                                        } else {
                                            print("There was an error decoding the string")
                                            self.vozrastLabel.text = user["birthDate"] as! String
                                        }

                                        let queryy = PFQuery(className: "Lokal")
                                        queryy.whereKey("objectId", equalTo: sendlokalId )
                                        queryy.findObjectsInBackground(block: {(objects,error) in
                                            if error != nil {
                                                
                                            }
                                            else if objects != nil {
                                                let object = objects![0]
                                                self.imelokalLabel.text = (object.value(forKey: "name") as! String)
                                                self.lokalLabel.text = (object.value(forKey: "tiplokal") as! String)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
        
}
