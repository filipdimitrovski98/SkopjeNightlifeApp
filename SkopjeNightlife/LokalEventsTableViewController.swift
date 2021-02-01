//
//  LokalEventsTableViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 2/1/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var userrole = true
var sendeventId = String()

class LokalEventsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        updateTable()
    }
    var objectIds = [String]()
    var names = [String]()
    var datumi = [String]()

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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "eventkelija")
        // Configure the cell...
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = datumi[indexPath.row]
        cell.backgroundColor = .systemYellow
        
        return cell
    }
    @objc func updateTable() {
          self.names.removeAll()
          self.objectIds.removeAll()
        self.datumi.removeAll()
          
          let query = PFQuery(className: "Event")
          
            query.whereKey("lokalId", equalTo: sendobjectId)
          
          
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
                          self.datumi.append(object["pocetok"] as! String)
                          
                         
                          
                      }
                  }
                  
                  OperationQueue.main.addOperation {
                      self.tableView.reloadData()
                  }
              }
              
          })
          
      }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendeventId = objectIds[indexPath.row]
        performSegue(withIdentifier: "toEventDetail", sender: nil)
        
    }
    

  

}
