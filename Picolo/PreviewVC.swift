//
//  PreviewVC.swift
//  Picolo
//
//  Created by Filip Mazic on 9/29/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {
    
    
    @IBOutlet weak var previewImg: UIImageView!
    var img: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        previewImg.image = img
    }   

    override var shouldAutorotate: Bool {
        return false
    }

}
