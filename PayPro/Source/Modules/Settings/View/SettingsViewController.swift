//
//  SettingsViewController.swift
//  Infinit
//
//  Created by Infinit on 2/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class SettingsViewController: ParentViewController {
    
    var presenter: SettingsPresenterProtocol?
    
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var keysLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var gasPriceLabel: UILabel!
    @IBOutlet weak var gasPriceNumber: UILabel!
    @IBOutlet weak var gasLimitLabel: UILabel!
    @IBOutlet weak var gasLimitNumber: UILabel!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var rateUsLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    init (presenter: SettingsPresenterProtocol) {
        super.init(nibName: "SettingsViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Button Actions
    @IBAction func didAddPhotoTouchUpInside(_ sender: Any?) {
        changeUserAvatar()
    }
    
    @IBAction func didPrivateKeyTouchUpInside(_ sender: Any) {
        presenter?.privateKeysButtonPressed(from: self)
    }
    
    @IBAction func didPasswordTouchUpInside(_ sender: Any?) {
        presenter?.passwordButtonPressed(from: self)
    }
    
    @IBAction func didGasPriceTouchUpInside(_ sender: Any?) {
        presenter?.gasPriceButtonPressed(from: self)
    }
    
    @IBAction func didGasLimitTouchUpInside(_ sender: Any?) {
        presenter?.gasLimitButtonPressed(from: self)
    }
    
    @IBAction func didAboutUsTouchUpInside(_ sender: Any?) {
        presenter?.aboutUsButtonPressed()
    }
    
    @IBAction func didRateUsTouchUpInside(_ sender: Any?) {
        presenter?.rateUsButtonPressed()
    }
    
    @IBAction func didInfoTouchUpInside(_ sender: Any?) {
        presenter?.infoButtonPressed(from: self)
    }
    
    @IBAction func didLogOutTouchUpInside(_ sender: Any) {
        presenter?.logOutButtonPressed()
    }
}

extension SettingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabBarHeightIfIosLessThan11(bottomConstraint: bottomConstraint, inverse: false)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingIndicator()
        presenter?.retrieveUserProfile()
    }
    
    private func configureView() {
        setTextsInLanguage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        showLoadingIndicator()
        presenter?.retrieveUserProfile()
    }
    
    private func setTextsInLanguage() {
        addPhotoLabel.text = NSLocalizedString("settings.addPhotoLabel", comment: "")
        keysLabel.text = NSLocalizedString("settings.keysLabel", comment: "")
        passwordLabel.text = NSLocalizedString("settings.passwordLabel", comment: "")
        gasPriceLabel.text = NSLocalizedString("settings.gasPriceLabel", comment: "")
        gasLimitLabel.text = NSLocalizedString("settings.gasLimitLabel", comment: "")
        aboutUsLabel.text = NSLocalizedString("settings.aboutUsLabel", comment: "")
        rateUsLabel.text = NSLocalizedString("settings.rateUs", comment: "")
        infoLabel.text = NSLocalizedString("settings.infoLabel", comment: "")
        logOutLabel.text = NSLocalizedString("settings.logOutLabel", comment: "")
    }
    
    func changeUserAvatar() {
        let alert = UIAlertController(title: NSLocalizedString("importImage.SelectImage", comment: ""), message: NSLocalizedString("importImage.importFrom", comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("importImage.Camera", comment: ""), style: .default, handler: { action in
            switch action.style {
            case .default:
                self.getimageFromCamera()
                print("default")
                
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("importImage.Gallery", comment: ""), style: .default, handler: { (_: UIAlertAction!) in
            self.getImageFromGallery()
        }))
        self.present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func getImageFromGallery() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.launchImagePicker(sourceType: .photoLibrary)
                } else {
                    self.showPhotoLibraryPermissionAlert()
                }
            }
        case .authorized:
            launchImagePicker(sourceType: .photoLibrary)
        case .denied:
            showPhotoLibraryPermissionAlert()
        case .restricted:
            showPhotoLibraryPermissionAlert()
        }
    }
    
    private func getimageFromCamera() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {granted in
                if granted {
                    self.launchImagePicker(sourceType: .camera)
                } else {
                    self.showCameraPermissionAlert()
                }
            }
        case .authorized:
            launchImagePicker(sourceType: .camera)
        case .denied:
            showCameraPermissionAlert()
        case .restricted:
            showCameraPermissionAlert()
        }
    }
    
    private func launchImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                imagePicker.modalPresentationStyle = .popover
                imagePicker.popoverPresentationController?.delegate = self
                imagePicker.popoverPresentationController?.sourceView = pictureImageView
                let bottomCenterOfImageView = CGPoint(x: pictureImageView.center.x, y: pictureImageView.center.y + pictureImageView.frame.height/2)
                imagePicker.popoverPresentationController?.sourceRect = CGRect(origin: bottomCenterOfImageView, size: .zero)
                imagePicker.popoverPresentationController?.permittedArrowDirections = .up
                view.alpha = 0.5
            }
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showCameraPermissionAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("settings.allowAccessToCameraAlertMessage", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("settings.allowAccessCancelButton", comment: ""), style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: NSLocalizedString("settings.allowAccessToSettingsButton", comment: ""), style: .default, handler: { (action) in
            self.presenter?.openSettings()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        alert.preferredAction = settingAction
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPhotoLibraryPermissionAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("settings.allowAccessToPhotoGalleryAlertMessage", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("settings.allowAccessCancelButton", comment: ""), style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: NSLocalizedString("settings.allowAccessToSettingsButton", comment: ""), style: .default, handler: { (action) in
            self.presenter?.openSettings()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        alert.preferredAction = settingAction
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: SettingsViewProtocol {
    func showToast(_ message: String) {
        view.showToast(toastMessage: message)
    }
    
    func setUserProfile(clientName: String, gasPrice: String, gasLimit: String, image: String) {
        self.nameLabel.text = clientName
        self.gasPriceNumber.text = gasPrice != "" ? gasPrice + " Gwei" : ""
        self.gasLimitNumber.text = gasLimit != "" ? gasLimit + " GAS" : ""
        hideLoadingIndicator()
        setUserImage(image)
    }
    
    func setUserImage(_ image: String) {
        
        //Backend gives us the image in image64 format, but it is codified twice
        let firstDecoding = image.base64ToString()
        pictureImageView.base64ToImage(image64: firstDecoding)
        pictureImageView.setRounded()
    }
    
    func onUpdatePhotoSuccess(newPhoto: String) {
        pictureImageView.base64ToImage(image64: newPhoto)
        hideLoadingIndicator()
    }
    
    func onUpdatePhotoError() {
        hideLoadingIndicator()
        self.view.showToast(toastMessage: NSLocalizedString("settings.updatePhotoError", comment: ""))
    }
    
    func onRetrieveUserProfileError(error: String) {
        hideLoadingIndicator()
        self.view.showToast(toastMessage: error)
    }
    
    func showURL(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func onLogOut() {
        self.hideLoadingIndicator()
            
        let alertTitle = NSLocalizedString("settings.logOut.alertTitle", comment: "")
        let alertMessage = NSLocalizedString("settings.logOut.alertMessage", comment: "")
        let okButtonText = NSLocalizedString("settings.logOut.okButtonText", comment: "")
        let cancelButtonText = NSLocalizedString("settings.logOut.cancelButtonText", comment: "")
            
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
            let keychainWrapper = KeychainWrapper.standard
            let statusToken = keychainWrapper.delete(forKey: KeychainValues.KeychainToken)
            let statusPassword = keychainWrapper.delete(forKey: KeychainValues.KeychainPassKey)
            print ("Deleted token status: \(statusToken)")
            print ("Deleted password status: \(statusPassword)")
            (UIApplication.shared.delegate as? AppDelegate)!.presentRootViewController()
        }))
        
        alert.addAction(UIAlertAction(title: cancelButtonText, style: UIAlertAction.Style.cancel, handler: nil))
        
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        view.alpha = 1.0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let pickedImage = info[.editedImage] as? UIImage
        if pickedImage != nil {
            let resizedImage = pickedImage?.resizeImage(targetSize: pictureImageView.frame.size)
            presenter?.newPhotoChosen(newPhoto: resizedImage!.imageToBase64())
        }
        view.alpha = 1.0
        picker.dismiss(animated: true)
        showLoadingIndicator()
    }
}

extension SettingsViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        view.alpha = 1.0
    }
}
