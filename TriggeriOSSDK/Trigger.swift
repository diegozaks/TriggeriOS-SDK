//
//  Trigger.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Trigger
{
    
    // MARK: Properties
    var isOn: Bool? {
        didSet {
            print("Setting Trigger state")
        }
    }
    var fullDescription: String?
    var symbol: String?
    var fullName: String?
    
    public init(json: JSON)
    {
        
    }
    
}