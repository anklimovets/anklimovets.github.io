//
//  ViewController.swift
//  JScript
//
//  Created by Andrey Klimovets on 21.01.2020.
//  Copyright © 2020 Rosbank. All rights reserved.
//

import UIKit
import WebKit
import Contacts
import ContactsUI

class ViewController: UIViewController, WKScriptMessageHandler, CNContactPickerDelegate {
    
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        //userContentController.add(self, name: "test")
        userContentController.add(self, name: "observer")
        config.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        
        view.addSubview(webView)
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        if let url = URL(string: "https://anklimovets.github.io") {
            webView.load(URLRequest(url: url))
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "observer", let messageBody = message.body as? String {
            
            if messageBody == "openPhoneBook" {
                self.openVCard()
                print(messageBody)
            }
            else {
                self.evaluateNow()
            }
        }
    }
    
    func evaluateNow(){
        webView.evaluateJavaScript("document.getElementById('email').value") {(result, error) in
            if error != nil {
                return
            }
            let value = String.init(result as! String)
            self.webView.evaluateJavaScript("document.getElementById('name').value='\(value)'"){(aresult, berror) in
                if berror != nil {
                    
                }
            }
        }
        
    }
    
    func openVCard() {
        let contactPickerViewController:CNContactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.modalPresentationStyle = .overCurrentContext
        contactPickerViewController.delegate = self
        contactPickerViewController.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        self.present(contactPickerViewController, animated: true, completion: nil)
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        let thePhoneNumber = (contactProperty.value as AnyObject).stringValue
        evaluatePhone(phone: thePhoneNumber ?? "no phone")
    }
    
    func evaluatePhone ( phone : String ) {
        
        self.webView.evaluateJavaScript("document.getElementById('phone').value='\(phone)'"){(result, error) in
            if error != nil {
                
            }
        }
    }
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    //
    //
    //        if let phone = contact.phoneNumbers.first?.value as? CNPhoneNumber {
    //
    //            print(phone.stringValue)
    //            self.webView.evaluateJavaScript("document.getElementById('phone').value='\(phone.stringValue)'"){(aresult, berror) in
    //                if berror != nil {
    //
    //                }
    //            }
    //        }
    //
    //    }
    
}
