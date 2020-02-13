//
//  RegisterInteractor.swift
//  Infinit
//
//  Created by Infinit on 29/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Alamofire
import Intercom

class RegisterInteractor: RegisterInteractorProtocol {
    
    var presenter: RegisterInteractorOutputProtocol?
    var dataSource: RegisterDataSourceProtocol?
    
    func requestRegisterApp() {
        dataSource?.registerApp(with: RegisterAppInput().getAsParameters()!, handle: { (onSuccess, response) in
            if onSuccess {
                PayproRequest.setCookie(response: response!)
                PayproRequest.setToken(from: response!.response)
                self.presenter?.onRegisterAppSuccess()
            } else {
                 if response!.response != nil {
                    if let data = response!.data {
                        do {
                            let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                            self.presenter?.onError(serverResponse.desc ?? NSLocalizedString("general.error", comment: ""))
                        } catch {
                            self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                        }
                    } else {
                        self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                    }
                 } else {
                    self.presenter?.onLoginError(NSLocalizedString("general.conectivityError", comment: ""))
                }
            }
        })
    }
    
    func requestOTP(username: String, telephoneNumber: String, countryCode: String) {
        dataSource?.requestOTP(with: RequestOTPInput(telephone: telephoneNumber, countryCode: countryCode).getAsParameters()!, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data!)
                    if let desc = serverResponse.desc, serverResponse.num != 0 {
                        self.presenter?.onError(desc)
                    } else {
                        self.presenter?.onRequestOTPSuccess()
                    }
                } catch {
                    self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                self.presenter?.onError(error!)
            }
        })
    }
    
    func checkUserId(userId: String) {
        dataSource?.checkUserId(userId: userId, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data!)
                    if let desc = serverResponse.desc, serverResponse.num != 0 {
                        self.presenter?.onError(desc)
                    } else {
                        self.presenter?.onCheckUserIdSuccess()
                    }
                } catch {
                    self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                self.presenter?.onError(error!)
            }
        })
    }
      
    func requestSignInWithOTP(otp: String) {
        dataSource?.signInWithOTP(otp: otp, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data!)
                    if let desc = serverResponse.desc, serverResponse.num != 0 {
                        self.presenter?.onError(desc)
                    } else {
                        self.presenter?.onRequestSignInWithOTPSuccess()
                    }
                } catch {
                    self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                self.presenter?.onError(error!)
            }
        })
    }
    
    func requestSignInWithPassword(userId: String, username: String, codPais: String, telephone: String, password: String) {
        let data = PasswordStep2InputData(codPais: codPais, telefono: telephone, idUsuario: userId, nombre: username, password: password)
        dataSource?.registerWithPassword(with: data.getAsParameters()!, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data!)
                    if let desc = serverResponse.desc, serverResponse.num != 0 {
                        self.presenter?.onError(desc)
                    } else {
                        self.presenter?.onRequestSignInWithPasswordSuccess()
                    }
                } catch {
                   self.presenter?.onError(NSLocalizedString("general.error", comment: ""))
                }
            } else {
                self.presenter?.onError(error!)
            }
        })
    }
    
    func requestLogin(username: String, password: String) {
        let data = LoginInputData(username: username, password: password)
        dataSource?.login(with: data.getAsParameters()!, handle: { (onSuccess, response) in
            if onSuccess {
                PayproRequest.setCookie(response: response!)
                PayproRequest.setToken(from: response!.response)
                self.presenter?.onLoginSuccess()
            } else {
                if response!.response != nil {
                    if let data = response!.data {
                        do {
                            let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                            
                            if  serverError.message == SpecificErrors.userBlockedError {
                                self.presenter?.onLoginError(NSLocalizedString("login.userBlockedError", comment: ""))
                            } else if serverError.message == SpecificErrors.credentialsError || serverError.message == SpecificErrors.secondCredentialsError {
                                self.presenter?.onLoginError(NSLocalizedString("login.credentialsError", comment: ""))
                            } else {
                                self.presenter?.onLoginError(NSLocalizedString("general.error", comment: ""))
                            }
                        } catch {
                            self.presenter?.onLoginError(NSLocalizedString("general.error", comment: ""))
                        }
                    } else {
                        self.presenter?.onLoginError(NSLocalizedString("general.error", comment: ""))
                    }
                } else {
                    self.presenter?.onLoginError(NSLocalizedString("general.conectivityError", comment: ""))
                }
            }
        })
    }
    
    func registerUserOnIntercom(withId userId: String) {
        Intercom.registerUser(withUserId: userId)
    }
}

extension RegisterInteractor: RegisterDataSourceOutputProtocol {
   
    func onError(_ error: Error) {
        presenter?.onError(error.localizedDescription)
    }
}
