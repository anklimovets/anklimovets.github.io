//
//  ViewController.swift
//  JScript
//
//  Created by Andrey Klimovets on 21.01.2020.
//  Copyright © 2020 Rosbank. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()

        //userContentController.add(self, name: "test")
        userContentController.add(self, name: "observer")
        config.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
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
         if message.name == "test", let messageBody = message.body as? String {
             print(messageBody)
         }
     }
}

