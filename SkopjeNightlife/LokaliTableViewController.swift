//
//  LokaliTableViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/29/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var selected = false
var tip = String()
var sendobjectId = String()
class LokaliTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       self.modalPresentationStyle = .fullScreen
        updateTable()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        updateTable()
    }
    var imageFiles = [PFFileObject]()
    var objectIds = [String]()
    var names = [String]()
    var tipovi = [String]()
    

    @IBOutlet weak var kafanaButton: UIButton!
    @IBOutlet weak var discoButton: UIButton!
    @IBOutlet weak var kaficButton: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBAction func kaficPressed(_ sender: Any) {
        selected = true
        kaficButton.isHighlighted = true
        kafanaButton.isHighlighted = false
        barButton.isHighlighted = false
        discoButton.isHighlighted = false
        tip = "Kafic"
        updateTable()
    }
    @IBAction func kafanaPressed(_ sender: Any) {
        selected = true
        kaficButton.isHighlighted = false
        kafanaButton.isHighlighted = true
        barButton.isHighlighted = false
        discoButton.isHighlighted = false
        tip = "Kafana"
        updateTable()
    }
    @IBAction func barPressed(_ sender: Any) {
        selected = true
        kaficButton.isHighlighted = false
        kafanaButton.isHighlighted = false
        barButton.isHighlighted = true
        discoButton.isHighlighted = false
        tip = "Bar"
        updateTable()
    }
    @IBAction func discoPressed(_ sender: Any) {
        selected = true
        kaficButton.isHighlighted = false
        kafanaButton.isHighlighted = false
        barButton.isHighlighted = false
        discoButton.isHighlighted = true
        tip = "Disco"
        updateTable()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        selected = false
        kaficButton.isHighlighted = false
        kafanaButton.isHighlighted = false
        barButton.isHighlighted = false
        discoButton.isHighlighted = false
        tip = ""
        updateTable()
        
    }
    @IBAction func logoutPressed(_ sender: Any) {
          PFUser.logOut()
          print("Logout Success")
          navigationController?.dismiss(animated: true, completion: nil)
          
      }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectIds.count
    }

    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lokalkelija", for: indexPath) as! LokalTableViewCell
        
    cell.imeLokal.text = names[indexPath.row]
    cell.tipLokal.text = tipovi[indexPath.row]
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                if let imageToDisplay = UIImage(data: imageData) {
                    cell.imageplace.image = imageToDisplay
                }
            }
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendobjectId = objectIds[indexPath.row]
        performSegue(withIdentifier: "todetail", sender: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 199
    }
    @objc func updateTable() {
        self.names.removeAll()
        self.objectIds.removeAll()
        self.tipovi.removeAll()
        self.imageFiles.removeAll()
        
        let query = PFQuery(className: "Lokal")
        if selected {
          query.whereKey("tiplokal", equalTo: tip)
        }
        
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                if objects.count > 0 {
                    //print(objects.count)
                    //print(objects[0].object(forKey: "objectId"))
                    for object in objects{
                        
                        
                        self.objectIds.append(object.objectId!)
                        self.names.append(object["name"] as! String)
                        self.tipovi.append(object["tiplokal"] as! String)
                        
                        if object["imageFile"] != nil {
                            self.imageFiles.append(object["imageFile"] as! PFFileObject)
                            
                        }
                        
                        
                        //print(object["datumbaranje"])
                        //self.tableView.reloadData()
                        //print(object.objectId as! String)
                        
                        //print(object["korisnikbaratel"] as! String)
                        
                    }
                }
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK ", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
  
}
