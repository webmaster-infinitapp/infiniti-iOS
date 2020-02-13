//
//  SendInteractor.swift
//  PayPro
//
//  Created by jtordesillas on 05/11/2018.
//  Copyright © 2018 VectorMobile. All rights reserved.
//

import Foundation
import Contacts

class SendInteractor: SendInteractorProtocol {
    var dataSource: SendDataSourceProtocol?
    var presenter: SendPresenterProtocol?
    var contactStore = CNContactStore()
}

extension SendInteractor {
    
    func getContacts() -> [CNContact] {
        let allContacts = getAllContactsFromAddressBook()
        let contactsWithPhoneNumber = filterContactsWithPhoneNumber(from: allContacts)
        //dataSource... Enviar todos nuestros contactos y elaborar listas de los que tienen la App, los que no... 
        return contactsWithPhoneNumber
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
}
