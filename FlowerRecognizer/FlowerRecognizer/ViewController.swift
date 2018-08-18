//
//  ViewController.swift
//  FlowerRecognizer
//
//  Created by Yasir Merchant on 2018-08-17.
//  Copyright © 2018 Yasir Merchant. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var cameraImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.cameraImageView.image = image
            
            guard let ciImage = CIImage(image: image) else
            {
                fatalError("Could not convert to ciImage")
            }
            
            detect(image: ciImage)
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage)
    {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else
        {
            fatalError("Could not load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else
            {
                fatalError("Could not load results")
            }
            
            self.navigationItem.title = results.first?.identifier.capitalized
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
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem)
    {
        present(imagePicker, animated: true, completion: nil)
    }
}

