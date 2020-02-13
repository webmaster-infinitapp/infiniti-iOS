//
//  SendInteractor.swift
//  Infinit
//
//  Created by Infinit on 05/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import Contacts

class SendInteractor: SendInteractorProtocol {
    
    var presenter: SendInteractorOutputProtocol?
    var dataSource: SendDataSourceProtocol?
    var contactStore = CNContactStore()
    
    func checkContacts(phoneNumbers: [String]) {
        dataSource?.checkContacts(with: CheckContactsInput(phoneNumbers: phoneNumbers).getAsParameters()!, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode([CheckContactsOutputData].self, from: data!)
                    self.presenter?.onCheckContactsSuccess(response: serverResponse)
                } catch {
                    self.presenter?.onCheckContactsError(NSLocalizedString("send.step1.checkContactsErrorMessage", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onCheckContactsError(error!)
            }
        })
    }
    
    func getTokensList() {
        dataSource?.getTokensList(handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode([RetrieveTokenListOutputData].self, from: data!)
                    self.presenter?.onGetTokensListSuccess(response: serverResponse)
                } catch {
                    self.presenter?.onTransferTokenError(NSLocalizedString("send.step5.transactionErrorMessage", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onGetTokensListError(error!)
            }
        })
    }
    
    func transferToken(message: String, amount: Double, address: String, tokenAddress: String) {
        dataSource?.transferToken(with: TransferTokenInput(descripcion: message, valor: amount, destino: address, origen: tokenAddress).getAsParameters()!, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode(TransferTokenOutputData.self, from: data!)
                    self.presenter?.onTransferTokenSuccess(response: serverResponse)
                } catch {
                    self.presenter?.onTransferTokenError(NSLocalizedString("send.step5.transactionErrorMessage", comment: ""))
                }
            } else {
               error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onTransferTokenError(error!)
            }
        })
    }
    
    func transaction(message: String, amount: Double, address: String) {
        let keychainWrapper = KeychainWrapper.standard
        var passwordFromKeychainWrapper: String?
        if let pin: String = keychainWrapper.read(forKey: KeychainValues.KeychainPassKey, reason: "Reason") as? String {
            passwordFromKeychainWrapper = pin
        }
        
        dataSource?.transaction(with: TransactionInput(descripcion: message, valor: amount, destino: address, password: passwordFromKeychainWrapper!).getAsParameters()!, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let serverResponse = try JSONDecoder().decode(TransactionOutputData.self, from: data!)
                    self.presenter?.onTransactionSuccess(response: serverResponse)
                } catch {
                    self.presenter?.onTransactionError(NSLocalizedString("send.step5.transactionErrorMessage", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onTransactionError(error!)
            }
        })
    }
}

extension SendInteractor {
    
    func getUserContacts() -> [CNMutableContact] {
        let allContacts = getAllContactsFromAddressBook()
        let contactsWithPhoneNumber = filterContactsWithPhoneNumber(from: allContacts)
        let contactsMutableCopy = makeMutableCopy(of: contactsWithPhoneNumber)
        return contactsMutableCopy
    }
    
    private func getAllContactsFromAddressBook() -> [CNContact] {
        
        let keysToFetch = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor]
        
        var results: [CNContact] = []
        
        let contactsContainers = getContactsContainers()
        
        results = retrieveContactsFromContainers(containers: contactsContainers, keysToFetch: keysToFetch)
        
        return results
    }
    
    private func getContactsContainers() -> [CNContainer] {
        let contactStore = CNContactStore()
        var allContainers: [CNContainer] = []
        
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {}
        
        return allContainers
    }
    
    private func retrieveContactsFromContainers(containers: [CNContainer], keysToFetch: [CNKeyDescriptor]) -> [CNContact] {
        var contacts: [CNContact] = []
        
        for container in containers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                contacts.append(contentsOf: containerResults)
            } catch {}
        }
        
        return contacts
    }
    
    private func filterContactsWithPhoneNumber(from contacts: [CNContact]) -> [CNContact] {
        var filteredContacts: [CNContact] = []
        
        for contact in contacts where !contact.phoneNumbers.isEmpty {
                filteredContacts.append(contact)
        }
        
        return filteredContacts
    }
    
    private func makeMutableCopy(of contacts: [CNContact]) -> [CNMutableContact] {
        var mutableCopy: [CNMutableContact] = []
        for contact in contacts {
            mutableCopy.append((contact.mutableCopy() as? CNMutableContact)!)
        }
        return mutableCopy
    }
}
