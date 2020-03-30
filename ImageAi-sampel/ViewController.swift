//
//  ViewController.swift
//  ImageAi-sampel
//
//  Created by JONGWOO JIN on 2020/03/27.
//  Copyright © 2020 JONGWOO JIN. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

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
        self.imageInference(image: ( info[UIImagePickerController.InfoKey.originalImage] as? UIImage) )
    }
    
    func imageInference(image: UIImage?){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("モデルをロードできません")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            
            guard let results = request.results as? [VNClassificationObservation],
                let firstReult = results.first else {
                    fatalError("判定ができません")
            }
            
            DispatchQueue.main.async {
                self?.photoInfoDisplay.text = "Accruacy = (\(firstReult.confidence * 100))% \n\n Text Label:→ \(firstReult.identifier)"
                
                let utterWords = AVSpeechUtterance(string: (self?.photoInfoDisplay.text!)!)
                utterWords.voice = AVSpeechSynthesisVoice(language: "en-us")
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterWords)
                
                print(results)
            }
        }
        
        guard let ciImage = CIImage(image: image!) else {
            fatalError("画像が変換できません")
        }
        
        let imageHandler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                try imageHandler.perform([request])
            }catch{
                print("エラー\(error)")
            }
        }
        
    }
    
}

