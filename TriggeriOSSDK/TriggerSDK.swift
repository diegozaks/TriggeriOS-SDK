//
//  TriggerSDK.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import UIKit


public protocol TriggerSDKDelegate
{
    func willDisplayTriggers(forSymbols symbols: [String])
    func didDisplayTriggers(forSymbols symbols: [String])
    func didGetTriggers(forSymbols symbols: [String], triggers: [Trigger])
    func triggerUpdated(trigger: Trigger)
    
    // view display
}

public extension TriggerSDKDelegate
{
    func willDisplayTriggers(forSymbols symbols: [String]) {}
    func didDisplayTriggers(forSymbols symbols: [String]) {}
    
    func didGetTriggers(forSymbols symbols: [String], triggers: [Trigger]) {}
    func triggerUpdated(trigger: Trigger) {}
}

extension TriggerSDK
{
    public enum ConfigurationOptions: String, Hashable
    {
        case DefaultFontColor = "TriggerSDKDefaultFontColor"
        case DefaultAccentTextColor = "TriggerSDKDefaultAccentTextColor"
        case DefaultBackgroundColor = "TriggerSDKDefaultBackgroundColor"
        case DefaultBorderColor = "TriggerSDKDefaultBorderColor"
        case DefaultNavigationBarBackgroundColor = "TriggerSDKDefaultNavigationBarBackgroundColor"
        case DefaultRegularFontType = "TriggerSDKDefaultTextFontType"
        case DefaultAccentFontType = "TriggerSDKDefaultAccentFontType"
        
        func validate(againstValue value: AnyObject)
        {
            switch self {
            case .DefaultFontColor,.DefaultAccentTextColor, .DefaultBackgroundColor, .DefaultBorderColor, .DefaultNavigationBarBackgroundColor:
                if let _ = value as? UIColor
                {
                    return
                }

            case .DefaultRegularFontType, .DefaultAccentFontType:
                if let _ = value as? UIFont
                {
                    return
                }
            }
            
            fatalError("Wrong value type supplied for configuration option: \(self.rawValue)")
        }
    }
 
}

public class TriggerSDK: TriggerTableViewCellDelegate
{
    // singleton
    public static let sharedInstance = TriggerSDK()
    private init() {}
    
    // properties
    public var colorScheme: TriggerColorScheme = TriggerColorScheme.Light // default
    public var delegate: TriggerSDKDelegate?
    public var tableViewController: UITableViewController?
    
    // optional configuration options
    public var loggingOn: Bool = true
    public var configurationOptions: [TriggerSDK.ConfigurationOptions: AnyObject] = [:] {
        didSet {
            for (key, value) in self.configurationOptions
            {
                key.validate(againstValue: value)
            }
        }
    }
    
    // MARK: Sets Credentials
    public func setCredentials(apiToken: String, userIdentifier: String, wasAuthenticated: (Bool -> ())? = nil)
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
            if let authenticationCallback = wasAuthenticated
            {
                authenticationCallback(result)
            }
            
            if result
            {
                self.log("Authenticated User Successfully")
            } else {
                self.log("Unable to login with provided credentials")
            }
        })
    }
    
    // MARK: Display Trigger View
    public func displayTriggers(forSymbols symbols: [String], overViewController: UIViewController)
    {
        self.delegate?.willDisplayTriggers(forSymbols: symbols)
        let vc = TriggerTableViewController(triggerTableViewCellDelegate: self)
        let navVC = UINavigationController()
        navVC.pushViewController(vc, animated: false)
        
        vc.modalTransitionStyle = .CoverVertical
        vc.modalPresentationStyle = .CurrentContext
        overViewController.definesPresentationContext = true
        
        HTTPService.getPresetTriggersBySymbols(symbols) { triggers in
            vc.triggers = triggers
            self.delegate?.didGetTriggers(forSymbols: symbols, triggers: triggers)
            overViewController.presentViewController(navVC, animated: true, completion: nil)
            self.delegate?.didDisplayTriggers(forSymbols: symbols)
        }
    }
    
    public func displayTriggers(forSymbols symbols: [String], viewControllerToDisplay: (UIViewController -> ()))
    {
        self.delegate?.willDisplayTriggers(forSymbols: symbols)
        let vc = TriggerTableViewController(triggerTableViewCellDelegate: self)
        let navVC = UINavigationController()
        navVC.pushViewController(vc, animated: false)
        
        HTTPService.getPresetTriggersBySymbols(symbols) { triggers in
            self.delegate?.didGetTriggers(forSymbols: symbols, triggers: triggers)
            vc.triggers = triggers
        }
        
        viewControllerToDisplay(navVC)
    }
    
    public func returnSubviewWithTriggers(forSymbols symbols: [String]) -> UIView
    {
        return UIView()
    }
    
    public func getTriggers(forSymbols symbols: [String], completionHandler: ([Trigger] -> ()))
    {
        if symbols.count == 0
        {
            self.log("In getTriggers: No symbols passed in")
            return
        }
        
        HTTPService.getPresetTriggersBySymbols(symbols, callback: { response in
            self.delegate?.didGetTriggers(forSymbols: symbols, triggers: response)
            completionHandler(response)
        })
    }
    
    // MARK: Activating Triggers
    func activateAllTriggers(forSymbols symbols: [String])
    {
        fatalError()
    }
    
    func activateAllTriggers(forSymbol symbol: String)
    {
        fatalError()
    }
    
    // MARK: Deactivating Triggers
    func deactivateAllTriggers(forSymbols symbols: [String])
    {
        fatalError()
    }
    
    func deactivateAllTriggers(forSymbol symbol: String)
    {
        fatalError()
    }
    
    // MARK: Logging
    func log(message: String)
    {
        if self.loggingOn
        {
            print("TriggerSDK: \(message)")
        }
    }
    
    // MARK: Trigger TableView Cell Delegate
    func triggerWasToggled(trigger: Trigger)
    {
        HTTPService.updatePresetTrigger(trigger) { updatedTrigger in
            if let triggerWasUpdated = updatedTrigger
            {
                self.delegate?.triggerUpdated(triggerWasUpdated)
            }
        }
    }
    
    internal func propertyForConfigurationOption(option: TriggerSDK.ConfigurationOptions) -> AnyObject?
    {
        if let hasACustomValue = self.configurationOptions[option]
        {
            return hasACustomValue
        } else {
            return self.colorScheme.returnValueForProperty(option)
        }
    }
    
}

