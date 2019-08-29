//
//  UIViewController+ImageSelector.swift
//  Rely
//
//  Created by Ryan Auger on 7/10/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var user: User!
    @IBOutlet weak var profilePicImageView: RoundImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User(defaults: true)
        
        //
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.profilePictureSelected))
        self.profilePicImageView.isUserInteractionEnabled = true
        self.profilePicImageView.addGestureRecognizer(gesture)
    }
    
    // SELECT IMAGE
    @objc func profilePictureSelected(sender : UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionsheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: {(
            action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(actionsheet, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default , handler: {(
            action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .overCurrentContext
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    // Image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("method called")
        
        guard let pickedImage = info[.editedImage] as? UIImage else { return }
        
        uploadAndSaveImage(image: pickedImage)
        dismiss(animated: true, completion: nil)
    }
    public enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // UPLOAD IMAGE
    
    func uploadAndSaveImage(image: UIImage) {
//        let base64String = convertImageTobase64(format: .png, image: image) ?? ""
        guard let base64String = image.toBase64() else {return}
        user.uploadProfileImage(imgStr: base64String){ (json, code, error) in
            guard
                code == 200,
                let data = json?["data"] as? [String: Any],
                let url = data["profile_img_url"] as? String
                else {return}
            
            self.user.profileImgUrl = url
            self.user.profileImgBase64 = base64String
            self.profilePicImageView.image = image
            
            updateDefaults(data: ["profile_img": base64String as Any, "profile_img_url": url as Any])
            self.alert(title: "Success", message: "Updated profile!", completion: nil)
        }
    }
    
}
