//
//  UIView+StatusBarHeight.swift
//  Infinit
//
//  Created by Infinit on 22/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addStatusBarHeightIfIosLessThan11(topConstraint: NSLayoutConstraint) {
        let version = OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 0)
        if ProcessInfo.processInfo.isOperatingSystemAtLeast(version) {
        } else {
            addSpaceAccordingToOrientation(topConstraint: topConstraint)
        }
    }
    
    private func addSpaceAccordingToOrientation(topConstraint: NSLayoutConstraint) {
        if UIApplication.shared.statusBarOrientation.isLandscape && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad {
            //let addedSpace = UIApplication.shared.statusBarFrame.size.height + 33
            topConstraint.constant += 33
        } else {
            //let addedSpace = UIApplication.shared.statusBarFrame.size.height + 45
            topConstraint.constant += 65
        }
    }
    
    func addTabBarHeightIfIosLessThan11(bottomConstraint: NSLayoutConstraint, inverse: Bool) {
        let version = OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 0)
        if ProcessInfo.processInfo.isOperatingSystemAtLeast(version) {
        } else {
            if inverse {
                bottomConstraint.constant -= 49
            } else {
                bottomConstraint.constant += 49
            }
        }
    }
}
