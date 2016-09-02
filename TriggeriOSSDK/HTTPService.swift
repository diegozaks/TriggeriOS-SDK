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
            
            // fails silently
            if response.response == nil { return }
            
            switch response.result {
            case .Success(let value):
                let responseJSON = JSON(value)
                print("ResponseJSON: \(responseJSON)")
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
    
}