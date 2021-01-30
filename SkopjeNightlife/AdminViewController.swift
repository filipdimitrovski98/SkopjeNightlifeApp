//
//  AdminViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/29/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
var lokalplace = [String:String]()
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
class AdminViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var manager = CLLocationManager()
    var pressed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(AdminViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var imeTextField: UITextField!
    @IBOutlet weak var tiplokalTextField: UITextField!
    
    @IBOutlet weak var kontaktTextField: UITextField!
    @IBOutlet weak var dresscodeTextfield: UITextField!
    @IBOutlet weak var rabotnovremeTextField: UITextField!
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        print("longpress")
        if(self.pressed) {
            print("Already pressed")
            return
            
        }
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            //print(newCoordinate)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                    if title == "" {
                        title = "Added \(NSDate())"
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    self.map.addAnnotation(annotation)
                    let lat = String(newCoordinate.latitude)
                    let lon = String(newCoordinate.longitude)
                    
                    let place = ["name": title,
                                 "lat": lat,
                                 "lon": lon
                    ]
                    lokalplace = place
                    
                    
                    
                    self.pressed = true
                }
            })
            
        }
    }
    @IBAction func chooseImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToPost.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createPlace(_ sender: Any) {
        
        if let image = imageToPost.image {
            if pressed != false && imeTextField.text != "" && rabotnovremeTextField.text != "" && dresscodeTextfield.text != "" && tiplokalTextField.text != "" {
            let lokalEntry = PFObject(className: "Lokal")
            lokalEntry["name"] = imeTextField.text
            lokalEntry["lokacija"] = lokalplace
            lokalEntry["rabotnovreme"] = rabotnovremeTextField.text
            lokalEntry["dresscode"] = dresscodeTextfield.text
            lokalEntry["tiplokal"] = tiplokalTextField.text
            lokalEntry["kontakt"] = kontaktTextField.text
            
            //lokalEntry.saveInBackground()
            
            if let imageData = image.jpeg(.medium) {
                let imageFile = PFFileObject(name: "image.jpg", data: imageData)
                lokalEntry["imageFile"] = imageFile
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                self.view.addSubview(activityIndicator)
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                lokalEntry.saveInBackground { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if success {
                        self.displayAlert(title: "Success !", message: "Lokalot e kreiran")
                        
                        
                    } else {
                        self.displayAlert(title: "Failed", message: error?.localizedDescription ?? "Please try again later")
                    }
                }
            }
            }
            else{
                self.displayAlert(title: "Failed !", message: "Popolni gi site informacii")
                
            }
            
            
        }
        
        
    }
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
        print("Logout Success")
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
