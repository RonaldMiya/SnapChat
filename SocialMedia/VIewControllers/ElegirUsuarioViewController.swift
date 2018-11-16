//
//  ElegirUsuarioViewController.swift
//  SocialMedia
//
//  Created by Ronald Miya on 10/31/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var usuarios : [Usuario] = []
    
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    var audioID = ""
    var audioURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        FIRDatabase.database().reference().child("usuarios").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.tableView.reloadData()
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        print(usuario.email)
        let snap = [
                        "from": FIRAuth.auth()!.currentUser!.email,
                        "descripcion": descrip, "imagenURL": imagenURL, "imagenID": imagenID,
                        "audioURL": audioURL, "audioID": audioID
                    ]
        FIRDatabase.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popToRootViewController(animated: true)
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
