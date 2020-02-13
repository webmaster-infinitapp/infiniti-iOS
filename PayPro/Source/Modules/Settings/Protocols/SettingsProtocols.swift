//
//  SettingsProtocols.swift
//  Infinit
//
//  Created by Infinit on 25/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation

protocol SettingsRouterProtocol: class {
    
    func showPrivateKeysViewController(from: UIViewController, presenter: SettingsPresenter)
    func showPasswordViewController(from: UIViewController, presenter: SettingsPresenter)
    func showGasPriceViewController(from: UIViewController, presenter: SettingsPresenter)
    func showGasLimitViewController(from: UIViewController, presenter: SettingsPresenter)
    func showInfoViewController(from: UIViewController, presenter: SettingsPresenter)
}

protocol SettingsDataSourceProtocol: class {
    func retrieveUserProfile(handle: @escaping ServiceHandler)
    func retrieveChangePassword(_ newPassword: String, handle: @escaping ServiceHandler)
    func retrievePrivateKey(handle: @escaping ServiceHandler)
    func updateGasPrice(gasPrice: String, handle: @escaping ServiceHandler)
    func updateGasLimit(gasLimit: String, handle: @escaping ServiceHandler)
    func updatePhoto(image: String, handle: @escaping ServiceHandler)
}

protocol SettingsInteractorProtocol: class {
    var presenter: SettingsInteractorOutputProtocol? { get set }
    var dataSource: SettingsDataSourceProtocol? { get set }
    
    func retrieveUserProfile()
    func retrievePrivateKey()
    func retrieveChangePassword(_ newPassword: String)
    func updatePhoto(newPhoto: String)
    func updateGasPrice(newGasPrice: String)
    func updateGasLimit(newGasLimit: String)
}

protocol SettingsInteractorOutputProtocol: class {
    func onRetrieveUserProfileSuccess(userProfile: RetrieveUserProfileOutput)
    func onError(_ message: String)
    
    func onRetrievePrivateKeySuccess(_ privateKey: String)
    func onRetrievePrivateKeyError(_ error: String)
    
    func onRetrieveChangePasswordSuccess()
    func onRetrieveChangePasswordError(_ error: String)
    
    func onUpdateGasPriceSuccess(newGasPriceInMweis: String)
    func onUpdateGasPriceError(_ error: String)
    
    func onUpdateGasLimitSuccess(newGasLimit: String)
    func onUpdateGasLimitError(_ error: String)
    
    func onUpdatePhotoSuccess(_ newPhoto: String)
    func onUpdatePhotoError(_ error: String)

    func onTokenExpired()
}

protocol SettingsPresenterProtocol: class {
    var router: SettingsRouterProtocol? { get set }
    var interactor: SettingsInteractorProtocol? { get set }
    var settingsView: SettingsViewProtocol? { get set }
    
    func retrieveUserProfile()
    func setSettingsView()
    func openSettings()
    
    func newPhotoChosen(newPhoto: String)
    func privateKeysButtonPressed(from: UIViewController)
    func passwordButtonPressed(from: UIViewController)
    
    func gasPriceButtonPressed(from: UIViewController)
    func gasLimitButtonPressed(from: UIViewController)
    
    func aboutUsButtonPressed()
    func rateUsButtonPressed()
    func infoButtonPressed(from: UIViewController)
    
    func logOutButtonPressed()
}

protocol SettingsPrivateKeyPresenterProtocol: class {
    func confirmPasswordButtonPressed(password: String)
    func retrievePrivateKey()
    func copyPrivateKeyToClipboardButtonPressed()
}

protocol SettingsPasswordPresenterProtocol: class {
    func createNewPasswordButtonPressed(_ newPassword: String)
}

protocol SettingsGasPricePresenterProtocol: class {
    func getGasPrice() -> String
    func setGasPrice(gasPrice: String)
}

protocol SettingsGasLimitPresenterProtocol: class {
    func getGasLimit() -> String
    func setGasLimit(gasLimit: String)
}

protocol SettingsInfoPresenterProtocol: class {
    func termsOfServiceButtonPressed()
    func privacyPolicyButtonPressed()
    func websiteButtonPressed()
}

protocol SettingsViewProtocol: class {
    var presenter: SettingsPresenterProtocol? { get set }
    func setUserProfile(clientName: String, gasPrice: String, gasLimit: String, image: String)
    func onUpdatePhotoSuccess(newPhoto: String)
    func onUpdatePhotoError()
    func onRetrieveUserProfileError(error: String)
    func showURL(_ url: String)
    func showToast(_ message: String)
    func onLogOut()
}

protocol SettingsPrivateKeyViewProtocol: class {
    func passwordConfirmed()
    func setPrivateKey(_ privateKey: String)
    func copyPrivateKeyToClipboard()
    func showError(_ error: String)
}

protocol SettingsPasswordViewProtocol: class {
    func confirmNewPassword()
    func showError(_ error: String)
    func navigateBackToSettings()
}

protocol SettingsGasPriceViewProtocol: class {
    func onUpdateGasPriceSuccess()
    func onUpdateGasPriceError(error: String)
}

protocol SettingsGasLimitViewProtocol: class {
    func onUpdateGasLimitSuccess()
    func onUpdateGasLimitError(error: String)
}

protocol SettingsInfoViewProtocol: class {
    func showURL(_ url: String)
}
