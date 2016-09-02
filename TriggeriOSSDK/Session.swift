//
//  Session.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import Foundation
import KeychainAccess

internal class Session
{
    
    static func setInSecureSession(key: SessionKey, value: String)
    {
        let keychain = Keychain(service: NSBundle.mainBundle().bundleIdentifier!)
        
        do {
            try keychain
                .accessibility(.WhenUnlocked)
                .synchronizable(true)
                .set(value, key: key.rawValue)
        } catch {
            return
        }
    }
    
    static func getFromSecureSession(key: SessionKey) -> String?
    {
        let keychain = Keychain(service: NSBundle.mainBundle().bundleIdentifier!)
        
        do {
            let value = try keychain.get(key.rawValue)
            return value
        } catch {
            return nil
        }
    }
    
    static var authToken: String? {
        get {
            return Session.getFromSecureSession(SessionKey.AuthToken)
        }
        set(token) {
            if let rawString = token
            {
                return Session.setInSecureSession(SessionKey.AuthToken, value: rawString)
            }
        }
    }
    
}

internal enum SessionKey: String
{
    case ClientToken = "apiToken"
    case UserIdentifier = "userIdentifier"
    case AuthToken = "authToken"
}