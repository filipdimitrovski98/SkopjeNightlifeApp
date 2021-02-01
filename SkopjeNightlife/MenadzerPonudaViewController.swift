//
//  MenadzerPonudaViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 2/1/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class MenadzerPonudaViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white
        createDatePicker()
        createDatePicker2()

   
    }
    var pressed = false
    
    @IBOutlet weak var muzikaTextField: UITextField!
    
    @IBOutlet weak var imeTextField: UITextField!
    @IBOutlet weak var vremepocetokTextField: UITextField!
    
    @IBOutlet weak var vremekrajTextField: UITextField!
    
    @IBOutlet weak var tipvlezTextField: UITextField!
    
    @IBOutlet weak var cenavlezTextField: UITextField!
    
    @IBOutlet weak var specijalnoTextField: UITextField!
    
    @IBOutlet weak var imageToPost: UIImageView!
    
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
    
    @IBAction func createPonuda(_ sender: Any) {
    
    if let image = imageToPost.image {
        if pressed != true && muzikaTextField.text != "" && vremekrajTextField.text != "" && vremepocetokTextField.text != "" && tipvlezTextField.text != "" {
        let lokalEntry = PFObject(className: "Event")
        lokalEntry["name"] = imeTextField.text
        lokalEntry["muzika"] = muzikaTextField.text
        lokalEntry["lokalId"] = sendlokalId
        lokalEntry["pocetok"] = vremepocetokTextField.text
        lokalEntry["kraj"] = vremekrajTextField.text
        lokalEntry["tipvlez"] = tipvlezTextField.text
        lokalEntry["cenavlez"] = cenavlezTextField.text
        lokalEntry["specijalno"] = specijalnoTextField.text
            
            
        
        
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
                    self.displayAlert(title: "Success !", message: "Eventot e kreiran")
                    
                    
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
    
    func displayAlert(title:String, message:String) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default))
           self.present(alertController, animated: true, completion: nil)
       }
    
    let datePicker = UIDatePicker()
    
    func createDatePicker(){
        vremepocetokTextField.textAlignment = .center
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        vremepocetokTextField.inputAccessoryView = toolbar
        vremepocetokTextField.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        
        
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        vremepocetokTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        
    }
    
    let datePicker2 = UIDatePicker()
    
    func createDatePicker2(){
        vremekrajTextField.textAlignment = .center
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        toolbar.setItems([doneButton], animated: true)
        vremekrajTextField.inputAccessoryView = toolbar
        vremekrajTextField.inputView = datePicker
        datePicker2.datePickerMode = .dateAndTime
        
        
    }
    @objc func donePressed2(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        vremekrajTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        
    }
    
    
}
