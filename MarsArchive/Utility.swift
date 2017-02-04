//
//  Utility.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    static func date(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)!
    }
    
    
}

class StatusBarNotification: UILabel {
    
    let kNotificationHeight: CGFloat = 20
    let kNotificationFont: UIFont = UIFont(name: ".SFUIDisplay-Semibold", size: 14)!
    let kNotificationDuration: TimeInterval = 3.0
    var kLightStatusBar = false
    var notificationWindow: UIWindow
    
    required init?(coder aDecoder: NSCoder) {
        self.notificationWindow = UIWindow(frame: (App.shared.window!.frame))
        super.init(coder: aDecoder)
    }
    
    init(message: String, color: UIColor) {
        self.notificationWindow = UIWindow(frame: (App.shared.window!.frame))
        super.init(frame: CGRect(x: 0, y: -self.kNotificationHeight, width: UIScreen.main.bounds.width, height: kNotificationHeight))
        
        notificationWindow.windowLevel = UIWindowLevelAlert
        notificationWindow.isHidden = false
        notificationWindow.isUserInteractionEnabled = false
        
        let viewController = StatusBarNotificationViewController()
        viewController.view.frame = notificationWindow.frame
        viewController.view.backgroundColor = UIColor.clear
        viewController.setNeedsStatusBarAppearanceUpdate()
        notificationWindow.rootViewController = viewController
        
        self.backgroundColor = color
        self.font = kNotificationFont
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.text = message
        viewController.view.addSubview(self)
    }
    
    init(message: String, color: UIColor, lightStatusBar: Bool) {
        self.notificationWindow = UIWindow(frame: (App.shared.window!.frame))
        super.init(frame: CGRect(x: 0, y: -self.kNotificationHeight, width: UIScreen.main.bounds.width, height: kNotificationHeight))
        
        notificationWindow.windowLevel = UIWindowLevelAlert
        notificationWindow.isHidden = false
        notificationWindow.isUserInteractionEnabled = false
        
        var viewController: UIViewController
        if lightStatusBar {
            viewController = LightStatusBarNotificationViewController()
        } else {
            viewController = StatusBarNotificationViewController()
        }
        
        viewController.view.frame = notificationWindow.frame
        viewController.view.backgroundColor = UIColor.clear
        viewController.setNeedsStatusBarAppearanceUpdate()
        notificationWindow.rootViewController = viewController
        
        self.backgroundColor = color
        self.font = kNotificationFont
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.text = message
        viewController.view.addSubview(self)
    }
    
    
    func show() {
        self.notificationWindow.makeKeyAndVisible()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.kNotificationHeight)
        }, completion: { complete in
            self.hide()
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: kNotificationDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.frame = CGRect(x: 0, y: -self.kNotificationHeight, width: UIScreen.main.bounds.width, height: self.kNotificationHeight)
        }, completion: { complete in
            self.notificationWindow.isHidden = true
        })
    }
}

private class StatusBarNotificationViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

private class LightStatusBarNotificationViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


