//
//  MenadzerRezervacijaViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 2/1/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse


class MenadzerRezervacijaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updatedata()
    
    }
    var react = false
    
    @IBOutlet weak var imeLabel: UILabel!
    
    @IBOutlet weak var prezimeLabel: UILabel!
    
    @IBOutlet weak var datumLabel: UILabel!
    
    @IBOutlet weak var brGostiLabel: UILabel!
    
    @IBOutlet weak var opisLabel: UILabel!
    
    @IBOutlet weak var kontaktLabel: UILabel!
    
    @IBOutlet weak var vozrastLabel: UILabel!
    
    @IBOutlet weak var imeLokalLabel: UILabel!
    
    @IBOutlet weak var tiplokalLabel: UILabel!
    @IBAction func rezervirajPressed(_ sender: Any) {
        if self.react == true {
            displayAlert(title: "Failed", message: "Vekje imate odgovoreno na ovaa rezervacija")
            return
        }
        let query = PFQuery(className: "Rezervacija")
        query.whereKey("objectId", equalTo: sendobjectId)
        query.findObjectsInBackground(block: {
            (objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                let object = objects[0]
                object["status"] = "Potvrdena"
                object.saveInBackground()
                print("Uspesno rezervirano")
                self.react = true
            }
        })
    }
    
    @IBAction func odbijPressed(_ sender: Any) {
        if self.react == true {
                   displayAlert(title: "Failed", message: "Vekje imate odgovoreno na ovaa rezervacija")
                   return
               }
               let query = PFQuery(className: "Rezervacija")
               query.whereKey("objectId", equalTo: sendobjectId)
               query.findObjectsInBackground(block: {
                   (objects,error) in
                   if error != nil {
                       print(error?.localizedDescription ?? "")
                   }
                   else if let objects = objects {
                       let object = objects[0]
                       object["status"] = "Odbiena"
                       object.saveInBackground()
                       print("Uspesno odbiena rezervacija")
                    self.react = true
                   }
               })
    }
    func updatedata(){
        let query = PFQuery(className: "Lokal")
        
        query.whereKey("objectId", equalTo: sendlokalId)
        query.findObjectsInBackground(block: { (objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                let object = objects[0]
                self.imeLokalLabel.text = object["name"] as? String
                self.tiplokalLabel.text = object["tiplokal"] as? String
               
               let query2 = PFQuery(className: "Rezervacija")
              
               query2.whereKey("objectId", equalTo: sendobjectId)
               query2.findObjectsInBackground(block: { (reservations,error2) in
                   if error != nil {
                       print(error2?.localizedDescription ?? "")
                   }
                   else if let reservations = reservations {
                       let reservation = reservations[0]
                       self.datumLabel.text = reservation["datum"] as? String
                       self.brGostiLabel.text = reservation["brojgosti"] as? String
                    self.opisLabel.text = reservation["opis"] as? String
                    
                    let userquery = PFUser.query()
                    userquery?.whereKey("objectId", equalTo: sendgostinId)
                    userquery?.findObjectsInBackground(block: {
                        (users,error3) in
                        if error3 != nil {
                            print(error3?.localizedDescription ?? "")
                        }
                        else if let users = users {
                            let user = users[0]
                            self.imeLabel.text = user["name"] as? String
                            self.prezimeLabel.text = user["lastName"] as? String
                            self.kontaktLabel.text = user["phoneNumber"] as? String
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
                            
                        }
                        
                    })
                      
                   }
                   
               })
                
            }
            
        })
    }
    
    func displayAlert(title:String, message:String) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default))
          self.present(alertController, animated: true, completion: nil)
      }
     override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        //navigationController?.navigationBar.tintColor = .white
    }
    
    
}
