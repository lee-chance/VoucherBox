//
//  CustomUIAlert.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/12/10.
//

import UIKit

struct CustomAlert {
    static func loginAlert(perform: @escaping (String, String) -> Void) {
        let alert = UIAlertController(title: "Login", message: nil, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "email"
        }
        
        alert.addTextField { field in
            field.isSecureTextEntry = true
            field.placeholder = "password"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
            let email = alert.textFields?[0].text ?? ""
            let password = alert.textFields?[1].text ?? ""
            
            perform(email, password)
        }))
        
        rootController().present(alert, animated: true)
    }
    
    static func loginErrorAlert(description: String) {
        let alert = UIAlertController(title: "Login Error", message: description, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        rootController().present(alert, animated: true)
    }
    
    static func signupAlert(perform: @escaping (String, String) -> Void) {
        let alert = UIAlertController(title: "Add Account", message: nil, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "email"
        }
        
        alert.addTextField { field in
            field.isSecureTextEntry = true
            field.placeholder = "password"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Register", style: .default, handler: { _ in
            let email = alert.textFields?[0].text ?? ""
            let password = alert.textFields?[1].text ?? ""
            
            perform(email, password)
        }))
        
        rootController().present(alert, animated: true)
    }
    
    static func signupErrorAlert(description: String) {
        let alert = UIAlertController(title: "Register Error", message: description, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        rootController().present(alert, animated: true)
    }
    
    static func signupSuccessAlert(email: String) {
        let alert = UIAlertController(title: "Register Succeess", message: "You can login with \(email)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        rootController().present(alert, animated: true)
    }
    
    private static func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        
        return root
    }
}
