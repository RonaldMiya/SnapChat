//
//  ImagenViewController.swift
//  SocialMedia
//
//  Created by Ronald Miya on 10/31/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descripcionTextField: UITextField!
    
    @IBOutlet weak var elegirContactoButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoButton.isEnabled = false
        let imagesFolder = Storage.storage().reference().child("images")
        let imagenData = imageView.image!.jpegData(compressionQuality: 0.1)
        
        imagesFolder.child("\(NSUUID().uuidString).jpg").putData(imagenData!, metadata: nil, completion: {(metadata, error) in
            print("Intentando subir imagen")
            if error != nil {
                print("Ocurrio un error: \(String(describing: error))")
            } else {
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
