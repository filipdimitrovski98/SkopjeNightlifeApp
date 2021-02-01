//
//  EventDetailViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 2/1/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class EventDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white
        updatedata()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imeLabel: UILabel!
    
    @IBOutlet weak var muzikaLabel: UILabel!
    
    @IBOutlet weak var pocetokLabel: UILabel!
    
    @IBOutlet weak var krajLabel: UILabel!
    
    @IBOutlet weak var tipvlezLabel: UILabel!
    
    @IBOutlet weak var cenaLabel: UILabel!
    
    @IBOutlet weak var ponudaLabel: UILabel!
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    func updatedata(){
        let query = PFQuery(className: "Event")
        query.whereKey("objectId", equalTo: sendeventId)
        query.findObjectsInBackground(block: {
            (objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                let object = objects[0]
                self.imeLabel.text = object["name"] as! String
                 self.muzikaLabel.text = object["muzika"] as! String
                 self.pocetokLabel.text = object["pocetok"] as! String
                 self.krajLabel.text = object["kraj"] as! String
                 self.tipvlezLabel.text = object["tipvlez"] as! String
                if let cena = object["cena"] as? String{
                    self.cenaLabel.text = cena
                    
                }
                else {
                    self.cenaLabel.text = "Free"
                }
                if let ponuda = object["specijalno"] as? String{
                    self.ponudaLabel.text = ponuda
                    
                }
                else {
                    
                    self.ponudaLabel.isHidden = true
                }
                 
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
}
