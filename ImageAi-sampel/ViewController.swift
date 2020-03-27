//
//  ViewController.swift
//  ImageAi-sampel
//
//  Created by JONGWOO JIN on 2020/03/27.
//  Copyright © 2020 JONGWOO JIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var photoDisplay: UIImageView!
    @IBOutlet weak var photoInfoDisplay: UITextView!
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
    }

    @IBAction func takePhoto(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoDisplay.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

