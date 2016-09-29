//
//  DrawVC.swift
//  Picolo
//
//  Created by Filip Mazic on 9/28/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit

class DrawVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func backPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPreview" {
            let pvc = segue.destination as! PreviewVC
            pvc.img = imageView.image
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.imageView)
            self.lastPoint = point
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.imageView)
            
            self.drawBetweenPoints(firstPoint: self.lastPoint, secondPoint: point)
            
            self.lastPoint = point
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.imageView)
            
            self.drawBetweenPoints(firstPoint: self.lastPoint, secondPoint: point)
        }
    }
    
    func drawBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
        
        context?.move(to: firstPoint)
        context?.addLine(to: secondPoint)
        
        context?.setLineCap(.round)
        context?.setLineWidth(5)
        
        
        context?.strokePath()
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    /*
     override var shouldAutorotate: Bool {
     
     /*
     if (UIDevice.current.orientation.isLandscape == UIDeviceOrientation.landscapeLeft.isLandscape || UIDeviceOrientation.landscapeRight.isLandscape) {
     return true
     } else {
     return false
     }*/
     return true
     
     
     }*/
    
    
    /*
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
     return UIInterfaceOrientationMask.landscapeLeft
     }*/
    
}
