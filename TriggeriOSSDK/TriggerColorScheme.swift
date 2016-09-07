//
//  TriggerColorScheme.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 8/31/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import UIKit

public enum TriggerColorScheme
{
    case Light
    case Dark
    
    func returnValueForProperty(option: TriggerSDK.ConfigurationOptions) -> AnyObject?
    {
        switch (option, self) {
        case (.DefaultFontColor, .Light):
             return UIColor.TriggerWarmGray()
        case (.DefaultFontColor, .Dark):
            return UIColor.TriggerOffWhite()
            
        case (.DefaultAccentTextColor, .Light):
            return UIColor.TriggerBlack()
        case (.DefaultAccentTextColor, .Dark):
            return UIColor.TriggerWhite()

        case (.DefaultBackgroundColor, .Light):
            return UIColor.TriggerWhite()
        case (.DefaultBackgroundColor, .Dark):
            return UIColor.TriggerBlack()

        case (.DefaultBorderColor, .Light):
            return UIColor.TriggerLightGray()
        case (.DefaultBorderColor, .Dark):
            return UIColor.TriggerOffWhite()

        case (.DefaultNavigationBarBackgroundColor, .Light):
            return nil
        case (.DefaultNavigationBarBackgroundColor, .Dark):
            return UIColor.TriggerBlack()
            
        case (.DefaultRegularFontType, .Light), (.DefaultRegularFontType, .Dark):
            if #available(iOS 8.2, *) {
                return UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
            } else {
                return UIFont.systemFontOfSize(16)
            }
        case (.DefaultAccentFontType, .Light), (.DefaultAccentFontType, .Dark):
            if #available(iOS 8.2, *) {
                return UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
            } else {
                return UIFont.boldSystemFontOfSize(20)
            }
        }
    }
    
    
    func returnNavbarIsTranslucent() -> Bool
    {
        switch self {
        case .Light: return true
        case .Dark: return false
        }
    }
    
}