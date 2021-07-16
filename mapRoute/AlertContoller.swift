//
//  AlertContoller.swift
//  mapRoute
//
//  Created by Артем Хребтов on 16.07.2021.
//

import UIKit

extension UIViewController {
    func alertAddPlace (complitionHandler: @escaping(String) -> Void ) {
        let alertController = UIAlertController(title: "Enter address", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { text in
            let addressTyped = alertController.textFields?.first
            guard let text = addressTyped?.text else {return}
            complitionHandler(text)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField { text in
            text.placeholder = "Enter Address"
        }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertError () {
        let alertError = UIAlertController(title: "Error", message: "Something wrong", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertError.addAction(okButton)
        present(alertError, animated: true, completion: nil)
    }
   
}
