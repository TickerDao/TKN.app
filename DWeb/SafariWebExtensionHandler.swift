//
//  SafariWebExtensionHandler.swift
//  DWeb
//
//  Created by Oak on 4/29/23.
//  Copyright © 2023 Superadditive. All rights reserved.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

//    func beginRequest(with context: NSExtensionContext) {
//        let item = context.inputItems[0] as! NSExtensionItem
//        let message = item.userInfo?[SFExtensionMessageKey]
//        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
//
//        let response = NSExtensionItem()
//        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]
//
//        context.completeRequest(returningItems: [response], completionHandler: nil)
//    }
    
    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)

        if message as! String == "example.eth detected" {
            let response = NSExtensionItem()
            response.userInfo = [ SFExtensionMessageKey: "Hello world" ]

            context.completeRequest(returningItems: [response], completionHandler: nil)
        }
    }

}
