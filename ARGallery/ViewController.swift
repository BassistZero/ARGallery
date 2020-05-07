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
    
    @IBOutlet weak var imageValueUIView: UIImageView!
    
    
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
    
    
    var grids = [Grid]()
    var image: UIImage?
    var photo: PhotoModel?
    var imageValue: UIImage? = UIImage(named: "mona-lisa")!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        arView?.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView?.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView?.delegate = self
        arView?.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        let scene = SCNScene()
        
        arView?.scene = scene
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        arView?.addGestureRecognizer(gestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
   
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any],_ imageValue: inout UIImage?) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageValue = image
        picker.dismiss(animated: true, completion: nil)
    }
 
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = Grid(anchor: planeAnchor)
        grids.append(grid)
        node.addChildNode(grid)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == planeAnchor.identifier
            }.first
        
        guard let foundGrid = grid else {
            return
        }
        
        foundGrid.update(anchor: planeAnchor)
    }

    @objc func tapped(gesture: UITapGestureRecognizer) {
           // Get 2D position of touch event on screen
           let touchPosition = gesture.location(in: arView)
           
           // Translate those 2D points to 3D points using hitTest (existing plane)
           let hitTestResults = arView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
           
           // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
        guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.firstIndex(where: { $0.anchor == anchor }) else {
               return
           }
        addPainting(hitTest, grids[gridIndex], imageValue: &imageValue)
       }

    func addPainting(_ hitResult: ARHitTestResult, _ grid: Grid, imageValue: inout UIImage?) {
        // 1.
        let planeGeometry = SCNPlane(width: 0.2, height: 0.35)
        let material = SCNMaterial()
        material.diffuse.contents = imageValue
        planeGeometry.materials = [material]
        
        // 2.
        let paintingNode = SCNNode(geometry: planeGeometry)
        paintingNode.transform = SCNMatrix4(hitResult.anchor!.transform)
        paintingNode.eulerAngles = SCNVector3(paintingNode.eulerAngles.x + (-Float.pi / 2), paintingNode.eulerAngles.y, paintingNode.eulerAngles.z)
        paintingNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        arView.scene.rootNode.addChildNode(paintingNode)
        grid.removeFromParentNode()
    }
}

extension UIImageView {
    func loadImage(by imageURL: String) {
        let url = URL(string: imageURL)!
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                DispatchQueue.main.async {
                    guard let data = data, let response = response else {
                        return
                    }
                    let cacheResponse = CachedURLResponse(response: response, data: data)
                }
            }.resume()
        }
        
        //let data = try! Data(contentsOf: url)
        //self.image = UIImage(data: data)
    }
}
