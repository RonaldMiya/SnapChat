//
//  IniciarSesionViewController.swift
//  SocialMedia
//
//  Created by Ronald Miya on 10/31/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            
            print("Intentemos iniciar Sesion")
            if error != nil {
                print("Tenemos el siguiente error \(String(describing: error))")
                print("Intentemos crear un usuario")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
                    if error != nil {
                        print("Tenemos el siguiente error \(String(describing: error))")
                    } else {
                        print("El usuario fue creado exitosamente")
                        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("email").setValue(Auth.auth().currentUser?.email)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            } else {
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
            
        } )
    }
    

}

