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
    @IBOutlet weak var mInputField: UITextField!
    
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
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
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
        
        guard mInputField.text?.count ?? 0 > 5 else {
            showToast("Please Enter Details of Length 5 characters")
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailPageVC") as? ContactDetailPageVC{
            vc.pDataSource = mContactModel
            vc.pEnterText = mInputField.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
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



//-------------------------TOAST MSG-----------------------------
class ToastLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension UIViewController {
    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0
    
    func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
        let label = ToastLabel()
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.alpha = 0
        label.text = text
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        label.numberOfLines = 0
        label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let saveArea = view.safeAreaLayoutGuide
        label.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(greaterThanOrEqualTo: saveArea.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: saveArea.trailingAnchor, constant: -15).isActive = true
        label.bottomAnchor.constraint(equalTo: saveArea.bottomAnchor, constant: -30).isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
}


