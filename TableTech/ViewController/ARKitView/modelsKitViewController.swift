//
//  modelsKitViewController.swift
//  TableTech
//
//  Created by Apple on 19/05/21.
//

import UIKit
import SceneKit
import ARKit


class modelsKitViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    private var hud :MBProgressHUD!
    
    private var newAngleY :Float = 0.0
    private var currentAngleY :Float = 0.0
    private var localTranslatePosition :CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.hud = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
        self.hud.label.text = "Detecting Plane..."
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
//        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
//        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector
            (longPressed))
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
        
        
        
    }
    
    @objc func longPressed(recognizer :UILongPressGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResults = self.sceneView.hitTest(touch, options: nil)
        
        if let hitTest = hitTestResults.first {
            
            if let parentNode = hitTest.node.parent {
                
                if recognizer.state == .began {
                    localTranslatePosition = touch
                } else if recognizer.state == .changed {
                    
                    let deltaX = Float(touch.x - self.localTranslatePosition.x)/700
                    let deltaY = Float(touch.y - self.localTranslatePosition.y)/700
                    
                    parentNode.localTranslate(by: SCNVector3(deltaX,0.0,deltaY))
                    self.localTranslatePosition = touch
                    
                }
                
            }
            
        }
    }
    
    @objc func panned(recognizer :UIPanGestureRecognizer) {
        
        if recognizer.state == .changed {
            
            guard let sceneView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            let translation = recognizer.translation(in: sceneView)
            
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
                
                if let parentNode = hitTest.node.parent {
                    
                    self.newAngleY = Float(translation.x) * (Float) (Double.pi)/180
                    self.newAngleY += self.currentAngleY
                    parentNode.eulerAngles.y = self.newAngleY
                    
                }
                
            }
            
        }
        else if recognizer.state == .ended {
            self.currentAngleY = self.newAngleY
        }
    }
    
    @objc func pinched(recognizer :UIPinchGestureRecognizer) {
        
        if recognizer.state == .changed {
            
            guard let sceneView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
                
                let chairNode = hitTest.node
                
                let pinchScaleX = Float(recognizer.scale) * chairNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * chairNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * chairNode.scale.z
                
                chairNode.scale = SCNVector3(pinchScaleX,pinchScaleY,pinchScaleZ)
                
                recognizer.scale = 1
                
            }
        }
        
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlaneUsingExtent)
        
        
        if let hitTest = hitTestResults.first {
            
            let chairScene = SCNScene(named: "Table.dae")!
            guard let chairNode = chairScene.rootNode.childNode(withName: "SketchUp", recursively: true) else {
                return
            }
            

            print("chairNode.name-------\(chairNode.name)")
            
//            chairNode.position =
//                SCNVector3(hitTest.worldTransform.columns.1.x,hitTest.worldTransform.columns.1.y,hitTest.worldTransform.columns.1.z)
          //  chairNode.position = SCNVector3(hitTest.worldTransform.columns.3.x,hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
            
            chairNode.scale = SCNVector3(0.02, 0.02, 0.02)
            //chairNode.position = SCNVector3Zero

            chairNode.position = SCNVector3(x: -0.11610305, y: -0.6530078, z: 0.7852024)

            print("chairNode.position-------\(chairNode.position)")
            
            
            self.sceneView.scene.rootNode.addChildNode(chairNode)
            
//
            if chairNode.name == "SketchUp" {




//                let objScene = SCNScene(named: "chair.dae")!
//                guard let objNode = objScene.rootNode.childNode(withName: "parentNode", recursively: true) else {
//                    return
//                }
//
//              let height = chairNode.boundingBox.max.y - chairNode.boundingBox.min.y
//              let position2ndNode = SCNVector3Make(chairNode.worldPosition.x, (chairNode.worldPosition.y + height), chairNode.worldPosition.z)
//
//                objNode.position = position2ndNode
//
//                self.sceneView.scene.rootNode.addChildNode(objNode)

                let tapTblGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappOnTable))
                self.sceneView.addGestureRecognizer(tapTblGestureRecognizer)

            } else {
                 return
            }

        }
        
        
        
        


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    @objc func tappOnTable(recognizer :UITapGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        
        let touch = recognizer.location(in: sceneView)
        
        let tappedNode = self.sceneView.hitTest(touch, options: [:])
        let node = tappedNode[0].node
        
            
            if node.name == "group_3" {
                
                let objScene = SCNScene(named: "Concrete+pot.dae")!
                guard let objNode = objScene.rootNode.childNode(withName: "SketchUp", recursively: true) else {
                    return
                }

              let height = node.boundingBox.max.y - node.boundingBox.min.y
                let vaseHeight = objNode.boundingBox.max.y - objNode.boundingBox.min.y
//              let position2ndNode = SCNVector3Make(node.worldPosition.x, (node.worldPosition.y + height), 0)
//
//                //objNode.scale = SCNVector3(0.01, 0.01, 0.01)
//                objNode.position = position2ndNode
                
                objNode.position = SCNVector3(0, (height + vaseHeight) / 2, 0)

                node.addChildNode(objNode)

               // self.sceneView.scene.rootNode.addChildNode(objNode)
                
                
              //  let offsetY = 0.5
                
//                let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
//
//                let material = SCNMaterial()
//                material.diffuse.contents = UIColor.red
//
//                let node = SCNNode()
//                node.name = "BOX"
//                node.geometry = box
//                node.geometry?.materials = [material]
//                node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box, options: [:]))
//                //node.physicsBody?.categoryBitMask = BodyType.box.rawValue
//
//                let height = node.boundingBox.max.y - node.boundingBox.min.y
//                let position2ndNode = SCNVector3Make(node.worldPosition.x, (node.worldPosition.y + height), node.worldPosition.z)
//
//
//
//                node.position = position2ndNode
//
//
//                self.sceneView.scene.rootNode.addChildNode(node)
//
                
                
                
                DispatchQueue.main.async {
                    
                    self.hud = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
                     self.hud.label.text = "Added Object above Object..."
                    self.hud.hide(animated: true, afterDelay: 1.0)
                }


            } else {
                 return
            }
    }
}

extension modelsKitViewController : ARSCNViewDelegate
{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        DispatchQueue.main.async {
            self.hud.label.text = "Plane Detected"
            self.hud.hide(animated: true, afterDelay: 1.0)
        }
    }
}
