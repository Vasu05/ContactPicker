//
//  VHomePageVC.swift
//  Eventers
//
//  Created by Vasu Chand on 19/04/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit
import Contacts

class HomePageVC: UIViewController {
    private let store = CNContactStore()
    private var mContactModel = [contactModel]()
    @IBOutlet weak var mNextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mNextBtn.layer.cornerRadius = 4
        requestAccess { (success) in
            
            if success{
                print("permission taken")
                self.findContacts()
                print(self.mContactModel)
                
                //self.retrieveContactsWithStore(store: self.store)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func findContacts()  {
        
        let store = CNContactStore()
        
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactImageDataKey]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        
        var contacts = [CNContact]()
        
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact,  stop) -> Void in
                contacts.append(contact)
                
                print(contact.givenName)
                var phoneNumbers = [String]()
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber,
                        let _ = phoneNumber.label {
                       // let localizedLabel = CNLabeledValue<NSCopying & NSSecureCoding>.localizedString(forLabel: label)
                        //print("\(localizedLabel)  \(number.stringValue)")
                        if !phoneNumbers.contains(self.getMobileNumberAfterTrim(number: number.stringValue)){
                            phoneNumbers.append(self.getMobileNumberAfterTrim(number: number.stringValue))
                        }
                    }
                }
                var cnobj =  contactModel()
                cnobj.givenName = contact.givenName
                cnobj.phoneNumbers = phoneNumbers
                cnobj.contactObj = contact
                self.mContactModel.append(cnobj)
                
            }
            )}catch {
                print(error.localizedDescription)
        }
        
    }
    
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailPageVC") as? ContactDetailPageVC{
            vc.pDataSource = mContactModel
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailPageVC") as? ContactDetailPageVC{
//            vc.pDataSource = mContactModel
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
    }
}

extension HomePageVC {
    
    func getMobileNumberAfterTrim(number:String)->String{
        var numberWithoutCrap = number
        numberWithoutCrap =  numberWithoutCrap.replacingOccurrences(of: "(", with: "")//[aNumber stringByReplacingOccurrencesOfString:@"(" w
        numberWithoutCrap =  numberWithoutCrap.replacingOccurrences(of: ")", with: "")
        numberWithoutCrap =  numberWithoutCrap.components(separatedBy: NSCharacterSet.whitespaces).joined(separator: "")
        numberWithoutCrap =  numberWithoutCrap.replacingOccurrences(of: "-", with: "")
        numberWithoutCrap =  numberWithoutCrap.replacingOccurrences(of: "+", with: "")
        numberWithoutCrap =  String(numberWithoutCrap.suffix(10))
        return numberWithoutCrap
    }
}

