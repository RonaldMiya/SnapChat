//
//  ImagenViewController.swift
//  SocialMedia
//
//  Created by Ronald Miya on 10/31/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descripcionTextField: UITextField!
    
    @IBOutlet weak var elegirContactoButton: UIButton!
    
        var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    var aUrlDown = ""
    var iUrlDown = ""
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playTapped: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioURL : URL?
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoButton.isEnabled = false
        setupRecorder()
        playTapped.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    //Audio
    func setupRecorder() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "Audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("****************")
            print(audioURL!)
            print("****************")
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
            
        } catch {
            print(error)
        }
    }
    
    
    //Imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        //imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        
        elegirContactoButton.isEnabled = false
        let imagesFolder = FIRStorage.storage().reference().child("images")
        let audiosFolder = FIRStorage.storage().reference().child("audio")
        
        let imagenData = imageView.image!.jpegData(compressionQuality: 0.1)
        let audioData = NSData(contentsOf: audioURL!) as Data?
        
        audiosFolder.child("\(audioID).m4p").put(audioData!, metadata: nil, completion: {(metadata, err) in
            
            if (err != nil){
                print("Error : \(String(describing: err))")
            }else{
                print("Audio subido correctamente!")
                self.aUrlDown = (metadata?.downloadURL()?.absoluteString)!
            }
            
        })
        
        imagesFolder.child("\(imagenID).jpg").put(imagenData!, metadata: nil, completion: {(metadata, error) in
            print("Intentando subir imagen")
            if error != nil {
                print("Ocurrio un error: \(String(describing: error))")
            } else {
                self.iUrlDown = (metadata?.downloadURL()?.absoluteString)!
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: [self.iUrlDown, self.aUrlDown])
            }
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        //siguienteVC.imagenURL = sender as! String
        siguienteVC.imagenURL = iUrlDown
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.audioURL = aUrlDown
        siguienteVC.audioID = audioID
    }
    
    @IBAction func recordButton(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            playTapped.isEnabled = true
            //addButton.isEnabled = true
        } else {
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    @IBAction func playButton(_ sender: Any) {
        
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }
        catch {
            
        }
        
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
