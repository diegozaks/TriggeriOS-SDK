//
//  HTTPService.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


internal class HTTPService
{
    
    static func authenticate(clientID: String, userID: String, callback: Bool -> ())
    {
        Alamofire.request(HTTPRouter.Authenticate(clientToken: clientID, uniqueIdentifier: userID)).validate().responseJSON() { response in
            // No network connection
            if response.response == nil { return }
            
            switch response.result {
            case .Success(let value):
                let responseJSON = JSON(value)
                if let authenticationToken = responseJSON["auth_token"].string
                {
                    Session.setInSecureSession(SessionKey.AuthToken, value: authenticationToken)
                    callback(true)
                } else {
                    callback(false)
                }
            case .Failure(let error):
                print(error)
                callback(false)
            }
        }
    }
    
    static func getPresetTriggersBySymbols(symbols: [String], callback: [Trigger] -> ())
    {
        var serverResponse: [Trigger] = []
        
        Alamofire.request(HTTPRouter.GetPresetTriggers(symbols: symbols)).validate().responseJSON() { response in
            if response.response == nil { return } // No network connection

            switch response.result {
            case .Success(let value):
                let jsonValue = JSON(value).arrayValue
                serverResponse = jsonValue.map { Trigger(json: $0) }
                callback(serverResponse)
                
            case .Failure(let error):
                TriggerSDK.sharedInstance.log("Error with GET Triggers: \(error)")
                callback(serverResponse)
            }
        }
    }
    
    static func updatePresetTrigger(trigger: Trigger, callback: Trigger? -> ())
    {
        guard let symbol = trigger.symbol else {
            return
        }
        
        Alamofire.request(HTTPRouter.UpdatePresetTrigger(symbol: symbol)).validate().responseJSON() { response in
            if response.response == nil { return }
            
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                callback(trigger)
                
            case .Failure(_):
                callback(nil)
            }
        }
        
        
    }
    
}