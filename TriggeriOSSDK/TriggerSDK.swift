//
//  TriggerSDK.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import Foundation


public protocol TriggerSDKDelegate
{
    func willDisplayTriggers(forSymbols symbols: [String])
    func didDisplayTriggers(forSymbols symbols: [String])
    func didGetTriggers(forSymbols symbols: [String], triggers: [Trigger])
    func triggerUpdated(trigger: Trigger)
}

public extension TriggerSDKDelegate
{
    func willDisplayTriggers(forSymbols symbols: [String]) {}
    func didDisplayTriggers(forSymbols symbols: [String]) {}
    func didGetTriggers(forSymbols symbols: [String], triggers: [Trigger]) {}
    func triggerUpdated(trigger: Trigger) {}
}

public class TriggerSDK
{
    // singleton
    public static let sharedInstance = TriggerSDK()
    private init() {}
    
    // properties
    var colorScheme: TriggerColorScheme = TriggerColorScheme.Light // default
    var delegate: TriggerSDKDelegate?
    
    // optional configuration options
    var smallFont: UIFont?
    var mediumFont: UIFont?
    var largeFont: UIFont?
    var fontColor: UIColor?
    var backgroundColor: UIColor?
    var loggingOn: Bool = true
    
    
    
    // MARK: Sets Credentials
    public func setCredentials(apiToken: String, userIdentifier: String)
    {
        /**
         Sets the API Token and the Unique User Identifier.
         
         The API Token is supplied by Trigger Finance and should be kept secret.
         
         The Unique User Identifier needs to be unique across all your users and static across multiple sessions, and should be treated as sensitive.
         
         Both credentials are persisted locally across sessions in the device keychain.
         */
        Session.setInSecureSession(SessionKey.ClientToken, value: apiToken)
        Session.setInSecureSession(SessionKey.UserIdentifier, value: userIdentifier)
        
        HTTPService.authenticate(apiToken, userID: userIdentifier, callback: { result in
            if result
            {
                self.log("Authenticated User Successfully")
            } else {
                self.log("Unable to login with provided credentials")
            }
        })
    }
    
    // MARK: Display Trigger View
    public func displayTriggers(forSymbols symbols: [String])
    {
        self.delegate?.willDisplayTriggers(forSymbols: symbols)
        
    }
    
    public func returnSubviewWithTriggers(forSymbols symbols: [String]) -> UIView
    {
        return UIView()
    }
    
    public func getTriggers(forSymbols symbols: [String], completionHandler: ([Trigger] -> ()))
    {
        let result: [Trigger] = []
        
        self.delegate?.didGetTriggers(forSymbols: symbols, triggers: result)
        completionHandler(result)
    }
    
    // MARK: Activating Triggers
    public func activateAllTriggers(forSymbols symbols: [String])
    {
        
    }
    
    public func activateAllTriggers(forSymbol symbol: String)
    {
        
    }
    
    // MARK: Deactivating Triggers
    public func deactivateAllTriggers(forSymbols symbols: [String])
    {
        
    }
    
    public func deactivateAllTriggers(forSymbol symbol: String)
    {
        
    }
    
    // MARK: Logging
    private func log(message: String)
    {
        if self.loggingOn
        {
            print("TriggerSDK: \(message)")
        }
    }
    
}
