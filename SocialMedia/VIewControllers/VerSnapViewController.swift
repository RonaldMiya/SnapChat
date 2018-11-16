//
//  VerSnapViewController.swift
//  SocialMedia
//
//  Created by Ronald Miya on 11/7/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    var audioPlayer : AVAudioPlayer?
    
    //Comentario
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text? = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL))
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRDatabase.database().reference().child("usuarios").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.id).removeValue()
        
        FIRStorage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete(completion: {(err) in
            print("Se elimino la imagen correctamente")
        })
        
        FIRStorage.storage().reference().child("audio").child("\(snap.audioID).m4p").delete(completion: {(err) in
            print("Se elimino el audio correctamente")
        })
        
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        
        do {
            
            let pathID = snap.audioID
            let storageReference = FIRStorage.storage().reference().child("audio").child("\(pathID).m4p")
            let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            guard let fileUrl = fileUrls.first?.appendingPathComponent(pathID) else {
                return
            }
            
            let downloadTask = storageReference.write(toFile: fileUrl)
            
            downloadTask.observe(.success) { _ in
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: fileUrl)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
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
