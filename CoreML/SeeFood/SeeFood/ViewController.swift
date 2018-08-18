//
//  ViewController.swift
//  SeeFood
//
//  Created by Yasir Merchant on 2018-08-14.
//  Copyright © 2018 Yasir Merchant. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var firstPrediction: UILabel!
    @IBOutlet weak var secondPrediction: UILabel!
    @IBOutlet weak var thirdPrediction: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.cameraImageView.image = image
            
            guard let ciImage = CIImage(image: image) else
            {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciImage)
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage)
    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else
        {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else
            {
                fatalError("Could not bind classification results")
            }
            
            let firstConfidence = results[0].confidence * 100
            let secondConfidence = results[1].confidence * 100
            let thirdConfidence = results[2].confidence * 100
            
            self.firstPrediction.text = "\(results[0].identifier) = \(firstConfidence)"
            self.secondPrediction.text = "\(results[1].identifier) = \(secondConfidence)"
            self.thirdPrediction.text = "\(results[2].identifier) = \(thirdConfidence)"
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do
        {
            try handler.perform([request])
        }
        catch
        {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any)
    {
        present(imagePicker, animated: true, completion: nil)
    }
}

