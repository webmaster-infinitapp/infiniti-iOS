//
//  SendStep1ViewController.swift
//  Infinit
//
//  Created by Infinit on 3/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class SendStep1ViewController: SendViewController {
    
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    init (presenter: SendPresenterProtocol) {
        super.init(nibName: "SendStep1ViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Cyclelife
extension SendStep1ViewController: SendStep1ViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        addTabBarHeightIfIosLessThan11(bottomConstraint: bottomConstraint, inverse: false)
        showLoadingIndicator()
        configureView()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = NSLocalizedString("send.step1.title", comment: "")
        presenter!.getContacts()
        if presenter?.isAuthorizedToAccessContacts() == false {
            showContactsPermissionAlert()
        }
    }
    
    func showContactsPermissionAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("send.step1.allowAccessToContactsAlertMessage", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("send.step1.allowAccessToContactsCancelButton", comment: ""), style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: NSLocalizedString("send.step1.allowAccessToContactsSettingsButton", comment: ""), style: .default, handler: { (action) in
            self.presenter?.openSettings()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        alert.preferredAction = settingAction
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureView() {
        setContactsTable()
        setSearchBar()
    }
    
    func onCheckContactsSuccess(updateWith contacts: [Contact]) {
        self.contacts = contacts
        self.filteredContacts = contacts
        contactsTable.reloadData()
        hideLoadingIndicator()
    }
    
    func onCheckContactsError() {
        self.contacts = []
        self.filteredContacts = []
        contactsTable.reloadData()
        hideLoadingIndicator()
        showCheckContactsError()
    }
    
    private func showCheckContactsError() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("send.step1.checkContactsErrorMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("send.step1.checkContactsErrorOkButton", comment: ""), style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.preferredAction = okAction
        self.present(alert, animated: true, completion: nil)
    }
}

extension SendStep1ViewController: UITableViewDelegate, UITableViewDataSource {
    private func setContactsTable() {
        contactsTable.dataSource = self
        contactsTable.delegate = self
        contactsTable.register(UINib.init(nibName: "CustomButtonCell", bundle: nil), forCellReuseIdentifier: "CustomButtonCell")
        contactsTable.register(UINib.init(nibName: "CustomContactsCell", bundle: nil), forCellReuseIdentifier: "CustomContactsCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count + 1 //Taking in account the cell for "Not in my contacts" button
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomButtonCell", for: indexPath) as? CustomButtonCell
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomContactsCell", for: indexPath) as? CustomContactsCell
            
            let contact = filteredContacts[indexPath.row - 1]
            cell?.fullNameLabel.text = contact.userContact.givenName + " " + contact.userContact.familyName
            cell?.publicKeyLabel.text = contact.publicAddress
            
            if let imageData = contact.userContact.thumbnailImageData {
                cell?.thumbnail.image = UIImage(data: imageData)
            } else {
                cell?.thumbnail.image = UIImage(named: "Account")
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchBar.resignFirstResponder()
        if indexPath.row == 0 {
            presenter?.resetAddress()
            presenter?.resetName()
            presenter?.goToSendStep2ViewController(from: self)
        } else {
            presenter?.selectedContact(contact: filteredContacts[indexPath.row - 1])//Taking in account the cell for "Not in my contacts"
            presenter?.goToSendStep3ViewController(from: self)
        }
    }
}

extension SendStep1ViewController: UISearchBarDelegate {
    
    private func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("send.step1.searchBarPlaceholder", comment: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredContacts = searchText.isEmpty ? contacts : contacts.filter { (contact: Contact) -> Bool in
            let name = contact.userContact.givenName + " " + contact.userContact.familyName
            return name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        contactsTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        filteredContacts = contacts
        contactsTable.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

class CustomButtonCell: UITableViewCell {

    @IBOutlet weak var notInContactsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notInContactsLabel.text = NSLocalizedString("send.step1.notInContactsButton", comment: "")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class CustomContactsCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.setRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
