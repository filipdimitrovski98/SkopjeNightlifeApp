//
//  AdminRequestViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/31/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var globalId = String()

class AdminRequestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func prifatiPressed(_ sender: Any) {
        //
    }
    
    @IBAction func odbijPressed(_ sender: Any) {
       //
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
                            if let lastname = user["lastName"] { print(lastname)
                                //print(user.username as! String)
                                var email = user.username as! String
                               // if email != nil { print(email)
                                    if let telefon = user["phoneNumber"] as? String {
                                        if let date = user["birthDate"] { //print(date)
                                            if let lokal = user["lokalId"] { //print(lokal)
                                                self.emailLabel.text = email as! String
                                                self.imeLabel.text = name as! String
                                                self.prezimeLabel.text = lastname as! String
                                                self.telefonLabel.text = telefon as! String
                                                self.vozrastLabel.text = date as! String
                                              //  self.lokalId = lokal as! String
                                                //print(self.lokalId)
                                                globalId = lokal as! String
                                                
                                                let queryy = PFQuery(className: "Lokal")
                                                queryy.whereKey("objectId", equalTo: globalId )
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
                                    //}
                                }
                            }
                        }
                    }
                }
               
            }
            
            
            
        })
        print(globalId)
        /*
         
        
 */
       
      
    }
 
    
}
/*print(user["birthDate"])
                           print(user["lokalId"])
                           self.imeLabel.text = user["name"] as? String
                           self.prezimeLabel.text = user["lastName"] as? String
                           self.emailLabel.text = user.email
                           self.telefonLabel.text = user["phoneNumber"] as? String
                           /*
                            let birthDate = user["birthDate"] as! Date
                            
                            
                            //2 - get today date
                            let today = Date()
                            
                            //3 - create an instance of the user's current calendar
                            let calendar = Calendar.current
                            
                            //4 - use calendar to get difference between two dates
                            let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: today)
                            
                            let ageYears = components.year
                            self.vozrastLabel.text = "\(ageYears!) godini"
                            
                            */
                           //self.vozrastLabel.text = user["birthDate"] as! String
                           self.lokalId = user["lokalId"] as! String
                           
                   */

