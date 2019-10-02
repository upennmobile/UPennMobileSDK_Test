//
//  UPennCameraImagePreviewViewController.swift
//  Unable To Scan
//
//  Created by Rashad Abdul-Salam on 7/1/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennCameraImagePreviewViewController : UIViewController {
    @IBOutlet weak var photo: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissModal()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
}
