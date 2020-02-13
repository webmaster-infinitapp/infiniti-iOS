//
//  Constants.swift
//  Infinit
//
//  Created by Infinit on 14/12/2017.
//  Copyright © 2017 Infinit. All rights reserved.
//

import UIKit
import Foundation

final class PayproEndpoints {
    
    static let login = Endpoints.login.rawValue
    static let register = Endpoints.register.rawValue
    static let checkUserId = Endpoints.checkUserId.rawValue
    static let otp = Endpoints.otp.rawValue
    static let verifyOtp = Endpoints.verifyOtp.rawValue
    static let balance = Endpoints.balance.rawValue
    static let addNewToken = Endpoints.addNewToken.rawValue
    static let transactionHistory = Endpoints.transactionHistory.rawValue
    static let transactionDetail = Endpoints.transactionDetail.rawValue
    static let checkContacts = Endpoints.checkContacts.rawValue
    static let transferToken = Endpoints.transferToken.rawValue
    static let transaction = Endpoints.transaction.rawValue
    static let profile = Endpoints.profile.rawValue
    static let privateKey = Endpoints.privateKey.rawValue
    static let changePassword = Endpoints.changePassword.rawValue
    static let updateGasPrice = Endpoints.updateGasPrice.rawValue
    static let updateGasLimit = Endpoints.updateGasLimit.rawValue
    static let updatePhoto = Endpoints.updatePhoto.rawValue
    static let publicKey = Endpoints.publicKey.rawValue
}

enum Endpoints: String {
    case login = "/login"
    case register = "/registro"
    case checkUserId = "/checkUserId?idUsuario="
    case otp = "/otp"
    case verifyOtp = "/otp?otp="
    case balance = "/balance"
    case addNewToken = "/addNewToken"
    case transactionHistory = "/transacHist"
    case transactionDetail = "/transaccion?idTransaccion="
    case checkContacts = "/contactos"
    case transferToken = "/transferToken"
    case transaction = "/transaccion"
    case profile = "/profile"
    case privateKey = "/getPrivKey"
    case updatePhoto = "/updatePhoto"
    case changePassword = "/changepass"
    case updateGasPrice = "/updateGasPrice?newGasPrice="
    case updateGasLimit = "/updateGasLimit?newGasLimit="
    case publicKey = "/getPubKey"
}

final class Urls {
    static let aboutUs = "https://drive.google.com/file/d/15XW4Vuqlb-jM4WZVdsHiBQGBgYY3yJFh/view?usp=sharing"
    static let termsOfService = "https://drive.google.com/file/d/1IwysbLq-8SeuvS6bt9Y_-KfiVBw0d5jN/view?usp=sharing"
    static let privacyPolicy = "https://drive.google.com/file/d/1rXNnYRxJPldrAfi-rJ1rbcVY155hC8ct/view?usp=sharing"
    static let website = "http://www.infinit.app/"
}

struct SpecificErrors {
    static let userBlockedError = "Authentication Failed: User blocked"
    static let credentialsError = "Authentication Failed: Invalid username/password"
    static let secondCredentialsError = "Authentication Failed: No AuthenticationProvider found for org.springframework.security.authentication.UsernamePasswordAuthenticationToken"
    static let expiredToken = "io.jsonwebtoken.ExpiredJwtException"
}

struct KeychainValues {
    static let KeychainName = "Infinit"
    static let KeychainUserKey = "Infinit-User"
    static let KeychainPassKey = "Infinit-Pass"
    static let KeychainToken = "Infinit-token"
}
