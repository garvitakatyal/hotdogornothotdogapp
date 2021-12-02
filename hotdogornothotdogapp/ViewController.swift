//
//  ViewController.swift
//  hotdogornothotdogapp
//
//  Created by Garvita Katyal on 11/29/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Delegation design pattern -> Text field: Properties
        
        // Steps to implement a delegate:
        // 1. Create an object
    
    let imagePicker = UIImagePickerController()
    let results : [VNClassificationObservation] = []
    


    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        //3. Implement its functions
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2. Initialize the delegate in View Did Load
        imagePicker.delegate = self
        
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1. Select the image
        if let image = info[.originalImage] as? UIImage {
            //display the selected image on screen
            imageView.image = image
            //dismiss imagepicker after capturing the image.
            imagePicker.dismiss(animated: true, completion: nil)
            
            // 2. Convert this image from UIImage data type into CIImage
            guard let ciImage = CIImage(image: image) else {return}
            
            // 3. Detect (CIImage)
            detect(image : ciImage)
            
        }
        
    }
        
    
    
    func detect(image: CIImage) {
        // Detect function:
            // 1. Initialize Model
        if let model = try? VNCoreMLModel(for: Inceptionv3().model){
           
            // 2. Request
            let request =  VNCoreMLRequest(model: model ,completionHandler: { (request, error) in
                // 3. Result
                guard let results = request.results as? [VNClassificationObservation], let topResult = results.first  else {return}
                
                if topResult.identifier.contains("hotdog"){
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog"
                    }
                }
                
                else{
                    DispatchQueue.main.async {
                        self.navigationItem.title = " Not Hotdog"
            
                }
            }
            
            
        })
            // 4. Handler
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            }
                        
            catch {
                print(error)
            }
        

        }
    }
}
        

   
    

