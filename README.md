# TriggeriOS-SDK
TriggerIOS SDK is used to seamlessly integrate triggers into existing iOS applications. You can use it to embed actual UI provided by the SDK, or simply use to handle authentication and communication with the Trigger backend.

## SDK Installation
* TBD 

## Authentication 
The SDK needs to pieces of information to securely and uniquely identify each user: 1) a company secret, and 2) a unique identifier for that user. 

* For 1), someone from the Trigger team will supply you with this token out of band. If you do not have a token, please contact `support@triggerfinance.com`. Please keep this secret.

* For 2), this is ideally a UUID that is persisted on your backend, or any other identifier that is unique across all your users interacting with the SDK. If a UUID isn't handy, a hash of an email address or other identifier would suffice. 

Somewhere in your `AppDelegate`, authenticate the SDK user by calling: 
```
TriggerSDK.sharedInstance.authenticate(companySecretToken, userIdentifier: uniqueUserIdentifier)
```

Though the authentication state doesn't expire, we recommend calling `authenticate` at the beginning of your application's lifecycle, usually in `didFinishLaunchingWithOptions` application delegate callback. 

If you prefer to authenticate more often, you can also use the optional completionBlock to sychronize the authentication with other actions: 

```
TriggerSDK.sharedInstance.authenticate(companySecretToken, userIdentifier: uniqueUserIdentifier) { authenticationSucceeded in 
    if authenticationSucceeded 
    {
        // proceed  
    }
```

## Presenting Triggers
To simply present a list of Triggers modally, you can call from somewhere in your view controller: 

```
TriggerSDK.sharedInstance.displayTriggers(forSymbols: ["GOOG"], overViewController: self)
```

You can also feed in multiple symbols and present them in a single screen:
```
TriggerSDK.sharedInstance.displayTriggers(forSymbols: ["GOOG", "AAPL"], overViewController: self)
```

If you'd like more control over how the view controller is presented, you can also call: 
```
TriggerSDK.sharedInstance.displayTriggers(forSymbols: ["GOOG", "AAPL"]) { viewControllerToDisplay in 
    // customize and present view controller
}
```

## Customizing the look and feel
You can supply a dictionary of configuration options to customize various fields in the Trigger SDK UI. The options are presented in the enum `TriggerSDK.ConfigurationOptions`:

* `.DefaultAccentTextColor`: text color applied to the table header text, navigation title, and navigation left button text.
* `.DefaultBackgroundColor`: background color for the main Trigger table.
* `.DefaultFontColor`: text color applied to the Trigger text. 
* `.DefaultBorderColor`: color applied to the bottom border lines in the tableview.
* `.DefaultRegularFontType`: font applied to the trigger text itself. 

For example, if you'd like to make the TriggerSDK decidedly ugly, you could pass in these options (set prior to Triggers being displayed):

```
let configuration: [TriggerSDK.ConfigurationOptions: AnyObject] = [
      TriggerSDK.ConfigurationOptions.DefaultAccentTextColor: UIColor.brownColor(),
      TriggerSDK.ConfigurationOptions.DefaultBackgroundColor: UIColor.blueColor(),
      TriggerSDK.ConfigurationOptions.DefaultFontColor: UIColor.cyanColor(),
      TriggerSDK.ConfigurationOptions.DefaultBorderColor: UIColor.darkGrayColor(),
      TriggerSDK.ConfigurationOptions.DefaultRegularFontType: UIFont.systemFontOfSize(12)
                                                                  ]
                                                                  
TriggerSDK.sharedInstance.configurationOptions = configuration // set the options

TriggerSDK.sharedInstance.displayTriggers(forSymbols: symbols, overViewController: self) // display customized UI

TriggerSDK.sharedInstance.configurationOptions = [:] // clear the options

TriggerSDK.sharedInstance.displayTriggers(forSymbols: symbols, overViewController: self) // display default UI
```

## Fetching Triggers
Lastly, if you'd like to present the Triggers using your own UI, you can fetch the Triggers directly and pass them into your own view. 

```
var myTriggers: [Trigger] = []
TriggerSDK.sharedInstance.getTriggers(forSymbols: ["GOOG", "AAPL"], completionHandler: { triggers in
    myTriggers = triggers
    // proceed
})
```

If you need to interact directly with the Trigger object in your custom UI, you can use the following fields:
* `isOn`: whether the Trigger is on or off (reflective of the UISwitch state in the SDK UI).
* `fullDescription`: readable text description of the Trigger.
* `symbol`: Ticker symbol, like GOOG. 

If you present a custom UI and the user toggles the Trigger state, POST the changes very simply:
```
myTrigger.isOn = false // update the on / off state
myTrigger.saveChanges() // POST the updates to the backend.
```

That's it. 

## Coming Soon
We have features on the way, such as:
* Creating custom Triggers
* Greater UI customization
* Analytics

