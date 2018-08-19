//
//  ViewController.swift
//  ARRuler
//
//  Created by Yasir Merchant on 2018-08-19.
//  Copyright © 2018 Yasir Merchant. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var sceneSpheres = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let firstTouchLocation = touches.first?.location(in: sceneView)
        {
            let firstTouchResults = sceneView.hitTest(firstTouchLocation, types: .featurePoint)
            
            if let firstTouchResult = firstTouchResults.first
            {
                addSphere(at: firstTouchResult)
            }
        }
    }
    
    @IBAction func deleteNodesClicked(_ sender: Any)
    {
        for sphere in sceneSpheres
        {
            sphere.removeFromParentNode()
        }
        
        sceneSpheres = [SCNNode]()
        textNode.removeFromParentNode()
    }
    
    private func addSphere(at hitResult: ARHitTestResult)
    {
        if(sceneSpheres.count < 2)
        {
            let sceneSphereMaterial = SCNMaterial()
            sceneSphereMaterial.diffuse.contents = UIColor.red
            
            let sceneSphere = SCNSphere(radius: 0.005)
            sceneSphere.materials = [sceneSphereMaterial]
            
            let sceneSphereNode = SCNNode(geometry: sceneSphere)
            sceneSphereNode.position = SCNVector3(
                hitResult.worldTransform.columns.3.x,
                hitResult.worldTransform.columns.3.y,
                hitResult.worldTransform.columns.3.z
            )
            
            sceneSpheres.append(sceneSphereNode)
            sceneView.scene.rootNode.addChildNode(sceneSphereNode)
            
            if(sceneSpheres.count == 2)
            {
                calculateDistance()
            }
        }
    }
    
    private func calculateDistance()
    {
        let startPoint = sceneSpheres[0]
        let endPoint = sceneSpheres[1]
        
        print(startPoint.position)
        print(endPoint.position)
        
        let a = endPoint.position.x - startPoint.position.x
        let b = endPoint.position.y - startPoint.position.y
        let c = endPoint.position.z - startPoint.position.z
        let distance = sqrt(
            pow(a, 2) +
            pow(b, 2) +
            pow(c, 2)
        )
        
        updateText(text: "\(distance * 100) cm", endPoint: endPoint.position)
    }
    
    private func updateText(text: String, endPoint: SCNVector3)
    {
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode.geometry = textGeometry
        textNode.position = SCNVector3(endPoint.x, endPoint.y + 0.01, endPoint.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
