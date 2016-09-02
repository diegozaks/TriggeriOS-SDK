//
//  HTTPRouter.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//


import Foundation
import Alamofire

internal enum HTTPRouter: URLRequestConvertible {
    
    static let baseURL = "https://staging.triggerfinance.com/"
    static var URLRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "")!)
    
    // Authentication
    case Authenticate(clientToken: String, uniqueIdentifier: String) // Authentication
    
    var URLRequest: NSMutableURLRequest {
        let (method, path, parameters, encoding): (Alamofire.Method, String, [String: AnyObject]?, Alamofire.ParameterEncoding) = {
            switch self {
                
            // MARK: Authentication API calls
            case .Authenticate(let clientID, let userID):
                let params = ["token": clientID, "identifier_in_client": userID]
                let method = Alamofire.Method.POST
                let encoding = Alamofire.ParameterEncoding.JSON
                return (method, "v1/authenticate", params, encoding)
                
            } // Add more cases here
        }()
        
        // Builds URL request with appropriate path
        let URL: NSURL = NSURL(string: HTTPRouter.baseURL)!
        let URLRequest: NSMutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        // Sets the Auth Header
        if let token = Session.authToken {
            switch self {
            case .Authenticate(_, _):
                break
            default:
                URLRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        // Sets HTTP method
        URLRequest.HTTPMethod = method.rawValue
        
        // Encodes request
        return encoding.encode(URLRequest, parameters: parameters).0
    }
    
}