//
//  LokalDetailViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/30/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
import MapKit
var selectedobjectIds = [String]()
class LokalDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updatedata()
        createDatePicker()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        selectedobjectIds.removeAll()
    }
    
    @IBOutlet weak var tiplokalLabel: UILabel!
    
    @IBOutlet weak var imeLabel: UILabel!
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var kontaktLabel: UILabel!
    @IBOutlet weak var rabotnovremeLabel: UILabel!
    
    @IBOutlet weak var dresscodeLabel: UILabel!
    
    @IBOutlet weak var brosobiTextField: UITextField!
    
    @IBOutlet weak var opisTextField: UITextField!
    
    @IBOutlet weak var datumvremeTextField: UITextField!
    let datePicker = UIDatePicker()
    
    func createDatePicker(){
        datumvremeTextField.textAlignment = .left
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        datumvremeTextField.inputAccessoryView = toolbar
        datumvremeTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        datumvremeTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        
    }
    
    @IBAction func aplicirajMenadzer(_ sender: Any) {
       let userquery = PFUser.query()
        //print("korisnik")
        //print(korisnikIds[indexPath.row])
        let current = PFUser.current()?.objectId
        userquery?.whereKey( "objectId", equalTo: current! )
        userquery?.findObjectsInBackground(block: { (users,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let users = users {
                let user = users[0]
                user["lokalId"] = sendobjectId
                user["apliciral"] = "Da"
                user.saveInBackground()
            }
            
        })
    }
    
    @IBAction func rezervirajPressed(_ sender: Any) {
        if selectedobjectIds.firstIndex(of: sendobjectId) != nil {
            displayAlert(title: "Cannot call this action", message: "Vekje ima isprateno baranje")
        }
        else {
        selectedobjectIds.append(sendobjectId)
        
       
        
        let baranjeEntry = PFObject(className: "Rezervacija")
        baranjeEntry["gostinId"] = PFUser.current()?.objectId
        baranjeEntry["lokalId"] = sendobjectId
            baranjeEntry["opis"] = opisTextField.text
            baranjeEntry["datum"] = datumvremeTextField.text
            baranjeEntry["brojgosti"] = brosobiTextField.text
        baranjeEntry["status"] = "Ne potvrdena"
        
        
        baranjeEntry.saveInBackground()
        print("Successfull entry for rezervacija")
        }
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        let query = PFQuery(className: "Lokal")
        query.whereKey("objectId", equalTo: sendobjectId)
        query.findObjectsInBackground(block: {(objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                let object = objects[0]
                
                let location = object["lokacija"] as! [String:String]
                        
                let lat = location["lat"]
                let lon = location["lon"]
                let latd = (lat! as NSString).doubleValue
                let lond = (lon! as NSString).doubleValue
                let requestCLLocation = CLLocation(latitude: latd, longitude: lond)
            CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placeMark = MKPlacemark(placemark: placemarks[0])
                        let mapItem = MKMapItem(placemark: placeMark)
                        mapItem.name = self.imeLabel.text
                        let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: options)
                    }
                }
            }
            }
        })
        
        
    }
    
    func updatedata(){
        let query = PFQuery(className: "Lokal")
        //print("korisnik")
        //print(korisnikIds[indexPath.row])
        query.whereKey("objectId", equalTo: sendobjectId)
        query.findObjectsInBackground(block: { (objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                let object = objects[0]
                self.imeLabel.text = object["name"] as? String
                self.tiplokalLabel.text = object["tiplokal"] as? String
                self.dresscodeLabel.text = object["dresscode"] as? String
                self.rabotnovremeLabel.text = object["rabotnovreme"] as? String
                self.kontaktLabel.text = object["kontakt"] as? String
                
                let imageFile = object["imageFile"] as! PFFileObject
                
                imageFile.getDataInBackground { (data, error) in
                    if let imageData = data {
                        if let imageToDisplay = UIImage(data: imageData) {
                            self.imageToPost.image = imageToDisplay
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
     override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        //navigationController?.navigationBar.tintColor = .white
    }
    
}
