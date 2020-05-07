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
import SceneKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARSCNViewDelegate {
    
    @IBOutlet var arView: ARSCNView!
    
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
    
    @IBAction func randomPic(_ sender: Any) {
        let service = BaseService()

        service.loadPhotos(onComplete: { [weak self] (photo) in
            self?.photo = photo
            self?.imageValue.image = self?.image
            }
            , onError: { error in
            dump(error)
            })
    }
    
    
    var grids = [Grid]()
    var image: UIImage?
    var photo: PhotoModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let scene = SCNScene()
        
        //ARView.Image = imageValue
        
        //let anchor = AnchorEntity(plane: .vertical)
        //arView?.scene.addAnchor(anchor)
        
        //var ARFrame: Entity = try! ARScene.loadBox().frameAndImage!
        
        //anchor.addChild(ARFrame)
        
        
        //let anchor = try? ARScene.loadBox()
        //arView?.scene.anchors.append(anchor!)
    }
   
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageValue.image = image
        picker.dismiss(animated: true, completion: nil)
    }
 
}

extension UIImageView {
    func loadImage(by imageURL: String) {
        let url = URL(string: imageURL)!
        let data = try! Data(contentsOf: url)
        self.image = UIImage(data: data)
    }
}
