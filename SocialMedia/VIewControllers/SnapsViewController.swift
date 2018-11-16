//
//  SnapsViewController.swift
//  SocialMedia
//
//  Created by Ronald Miya on 10/31/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        FIRDatabase.database().reference().child("usuarios").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let snap = Snap()
            
            
            
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.form = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            snap.audioURL = (snapshot.value as! NSDictionary)["audioURL"] as! String
            snap.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
            self.snaps.append(snap)
            print(snap)
            self.tableView.reloadData()
        })
        
        FIRDatabase.database().reference().child("usuarios").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.snaps {
                if snap.id == snapshot.key {
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "No tienes SNAPS 😪"
        } else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.form
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
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
