//
//  TriggerTableViewController.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 9/2/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import UIKit

public class TriggerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    // MARK: View References
    weak var tableView: UITableView?
    public weak var customTableHeaderView: UIView?
    
    // MARK: Properties
    var cellDelegate: TriggerTableViewCellDelegate?
    var triggers: [Trigger] = [] {
        didSet {
            self.tableView?.TriggerReloadDataWithAnimation()
            self.setNavigationTitle()
        }
    }

    let defaultBackgroundColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultBackgroundColor) as! UIColor
    let defaultTextColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultFontColor) as! UIColor
    let defaultAccentTextColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultAccentTextColor) as! UIColor
    let defaultBorderColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultBorderColor) as! UIColor
    let defaultNavbarColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultNavigationBarBackgroundColor) as? UIColor
    
    var hasSetHeaderView: Bool = false
    let triggerCellIdentifier = "triggerCell"
    var numberOfSections: Int {
        get {
            return self.returnSections().count
        }
    }
    var willNeedToDisplayNavbarOnDismissal: Bool = false
    var triggersBySymbols: [String: [Trigger]] {
        get {
            var result = [String: [Trigger]]()
            for each in self.triggers
            {
                if let symbol = each.symbol
                {
                    if result[symbol] == nil
                    {
                        result[symbol] = [each]
                    } else {
                        result[symbol]!.append(each)
                    }
                }
            }
            return result
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navBar = self.navigationController?.navigationBar
        {
            if !navBar.hidden
            {
                self.willNeedToDisplayNavbarOnDismissal = true
            }
        }
        
        if let navBar = self.presentingViewController?.navigationController?.navigationBar
        {
            if !navBar.hidden
            {
                self.willNeedToDisplayNavbarOnDismissal = true
            }
        }
        
        self.navigationController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.presentingViewController?.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.willNeedToDisplayNavbarOnDismissal
        {
            self.navigationController?.navigationController?.setNavigationBarHidden(false, animated: true)
            self.presentingViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: Inits
    init(triggerTableViewCellDelegate delegate: TriggerTableViewCellDelegate)
    {
        self.cellDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initCustomNavigationBar()
        self.initTableView()
        self.initConstraints()
        self.viewDidLayoutSubviews()
    }
    
    func initCustomNavigationBar()
    {
        self.navigationController?.title = ""
        let button = UIButton(frame: CGRectMake(0, 0, 60, 50))
        button.setTitle("Dismiss", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .Left
        button.setTitleColor(self.defaultAccentTextColor, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(TriggerTableViewController.dismissViewController), forControlEvents: UIControlEvents.TouchUpInside)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        if let navVC = self.navigationController
        {
            navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.defaultAccentTextColor]
            navVC.navigationBar.barTintColor = self.defaultNavbarColor
            navVC.navigationBar.backgroundColor = UIColor.clearColor()
            navVC.navigationBar.translucent = TriggerSDK.sharedInstance.colorScheme.returnNavbarIsTranslucent()
        }
    }
    
    func setNavigationTitle()
    {
        if self.numberOfSections > 1
        {
            self.title = "All Triggers"
        } else {
            if let tickerSymbol = self.triggers.first?.symbol
            {
                self.title = "\(tickerSymbol.uppercaseString)"
            } else {
                self.title = "All Triggers"
            }
        }
    }
    
    // MARK: Action
    func dismissViewController()
    {
        self.dismissViewControllerAnimated(true, completion: nil)

//        if let navVC = self.navigationController
//        {
//            navVC.dismissViewControllerAnimated(true, completion: nil)
//        } else {
//        }
    }
    
    func initTableView()
    {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView!.registerClass(TriggerTableViewCell.self, forCellReuseIdentifier: self.triggerCellIdentifier)
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.estimatedRowHeight = 80
        self.tableView!.backgroundColor = self.defaultBackgroundColor
        self.tableView!.separatorStyle = .None
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sectionSymbol = self.returnSections()[safe: section]
        {
            return self.returnTriggersInSection(sectionSymbol: sectionSymbol).count
        }
        
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.triggerCellIdentifier) as! TriggerTableViewCell
        cell.delegate = self.cellDelegate
        
        cell.trigger = self.triggers[indexPath.row]
        return cell
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return self.numberOfSections
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let ticker = self.returnSections()[safe: section]
        {
            let container = UIView()
            let label = UILabel()

            if #available(iOS 8.2, *) {
                label.font = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
            } else {
                label.font = UIFont.boldSystemFontOfSize(20)
            }
            
            label.adjustsFontSizeToFitWidth = true
            label.textColor = self.defaultAccentTextColor
            if self.returnSections().count > 1
            {
                label.text = ticker.uppercaseString
            } else {
                label.text = "Triggers"
            }
            container.addSubview(label)
            label.snp_makeConstraints { (make) -> Void in
                make.centerY.equalTo(container)
                make.left.equalTo(container).offset(25)
            }
            
            let bottomBorder = UIView()
            bottomBorder.backgroundColor = self.defaultBackgroundColor
            container.addSubview(bottomBorder)
            bottomBorder.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(container).offset(5)
                make.right.equalTo(container).offset(-5)
                make.bottom.equalTo(container)
                make.height.equalTo(1)
            }
            
            return container
        }
        
        return nil
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func returnSections() -> [String]
    {
        return self.triggersBySymbols.keys.sort { $0 > $1 }
    }
    
    func returnTriggersInSection(sectionSymbol symbol: String) -> [Trigger]
    {
        var result: [Trigger] = []
        if let triggers = self.triggersBySymbols[symbol]
        {
            result = triggers.filter { $0.fullDescription != nil }
            return result.sort { $0.fullDescription! > $1.fullDescription! }
        }
        
        return result
    }
    
    
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableView!.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableView!.tableHeaderView = header
    }
    
    func initConstraints()
    {
        self.tableView?.snp_makeConstraints { (make) -> Void in
            make.left.top.right.bottom.equalTo(self.view)
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let header = self.customTableHeaderView, let tableView = self.tableView
        {
            let existingTableViewFrame = tableView.frame
            let headerFrame = header.frame
            self.tableView!.frame = CGRectMake(existingTableViewFrame.minX, header.frame.height, existingTableViewFrame.width, existingTableViewFrame.height)
        }
    }
    
    
}

internal extension UITableView
{
    func TriggerReloadDataWithAnimation(duration: Double = 0.35) {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.transitionWithView(self,
                duration: duration,
                options: .TransitionCrossDissolve,
                animations:
                { () -> Void in
                    self.reloadData()
                },
                completion: nil);
        })
    }
}


