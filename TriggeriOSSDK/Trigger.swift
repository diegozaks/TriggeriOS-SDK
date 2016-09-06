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
    public var isOn: Bool? {
        didSet {
            print("Setting Trigger state")
        }
    }
    public var fullDescription: String?
    public var symbol: String?
    var internalName: String?
    
    init(json: JSON)
    {
        self.fullDescription = json[JSONKeys.NameInClient.rawValue].string
        self.symbol = json[JSONKeys.Symbol.rawValue].string
        self.isOn = json[JSONKeys.EnabledForUsers.rawValue].bool
        self.internalName = json[JSONKeys.Name.rawValue].string
    }
    
    public init() {}
    
    public func saveChanges()
    {
        HTTPService.updatePresetTrigger(self, callback: nil)
    }
    
    // Keys for parsing JSON blobs
    enum JSONKeys: String
    {
        case NameInClient = "name_in_client"
        case Name = "name"
        case EnabledForUsers = "enabled_for_user"
        case Symbol = "symbol"
    }
    
}