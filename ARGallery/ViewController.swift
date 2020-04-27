//
//  ViewController.swift
//  ARGallery
//
//  Created by Bassist Zero on 4/16/20.
//  Copyright © 2020 Bassist_Zero. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var arView: ARView?
    
    @IBOutlet weak var imageValue: UIImageView!
    
    @IBAction func takePhotoButton(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageValue.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
