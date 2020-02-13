//
//  LoadingIndicator.swift
//  Infinit
//
//  Created by Infinit on 19/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoadingIndicator() {
        
        if let parent = parent {
            let overlay = UIView(frame: parent.view.bounds)
            overlay.tag = 99
            let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
            loadingIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            view.addSubview(overlay)
            overlay.center = parent.view.center
            overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            overlay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            overlay.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            overlay.addSubview(loadingIndicator)
            loadingIndicator.center = overlay.center
            loadingIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true

            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.startAnimating()
            
            overlay.alpha = 0.0
            UIView.animate(withDuration: 0.2, animations: {
                overlay.alpha = 0.7
                loadingIndicator.alpha = 1.0
            })
        }
    }
    
    func hideLoadingIndicator() {
        view.viewWithTag(99)?.removeFromSuperview()
    }
}
