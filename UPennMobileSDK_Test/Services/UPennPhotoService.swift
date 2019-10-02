//
//  UPennPhotoService.swift
//  Unable To Scan
//
//  Created by Rashad Abdul-Salam on 6/21/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerDelegate {
    func didSelect(image: UIImage?)
}

class UPennPhotoService : NSObject {
    
    private var presentationController : UIViewController
    private let pickerController = UIImagePickerController()
    private var imagePickerDelegate: ImagePickerDelegate?
    
    init(_ viewController: UIViewController, delegate: ImagePickerDelegate) {
        self.presentationController = viewController
        self.imagePickerDelegate = delegate
        super.init()
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    func pickPhoto() {
        self.pickerController.sourceType = .photoLibrary
        self.presentationController.present(self.pickerController, animated: true)
    }
    
    func takePhoto() {
        self.pickerController.sourceType = .camera
        self.presentationController.present(self.pickerController, animated: true)
    }
}

extension UPennPhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.selectedImage(nil, for: picker)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let image = info[.editedImage] as? UIImage else {
            return self.selectedImage(nil, for: picker)
        }
        self.selectedImage(image, for: picker)
    }
}

private extension UPennPhotoService {
    func selectedImage(_ image: UIImage?, for controller: UIImagePickerController) {
        controller.dismiss(animated: true, completion: nil)
        
        self.imagePickerDelegate?.didSelect(image: image)
    }
}
