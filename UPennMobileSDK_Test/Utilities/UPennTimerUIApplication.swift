//
//  UPennTimerUIApplication.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennTimerUIApplication : UIApplication {
    
    private enum IntervalSeconds : Double {
        case TwoMin  = 120.0
        case FiveMin = 300.0
        case TenMin  = 600.0
    }
    
    static let ApplicationDidTimeoutNotification = "AppTimeout"
    static private let timeoutKey = "timeoutKey"
    static private var timeoutIdxDict : Dictionary<Int,Double> = {
        let dict = [
            0 : IntervalSeconds.TwoMin.rawValue,
            1 : IntervalSeconds.FiveMin.rawValue,
            2 : IntervalSeconds.TenMin.rawValue
        ]
        return dict
    }()
    static private var timeoutIndices : Dictionary<Double,Int> = {
        let dict = [
            IntervalSeconds.TwoMin.rawValue  : 0,
            IntervalSeconds.FiveMin.rawValue : 1,
            IntervalSeconds.TenMin.rawValue  : 2
        ]
        return dict
    }()
    static var timeoutInSeconds: Double {
        // TODO: Return cached setting from UserDefaults
        guard let timeoutSeconds = UserDefaults.standard.value(forKey: self.timeoutKey) as? Double else { return self.timeoutIdxDict[2]! }
        return timeoutSeconds
    }
    static var timeoutIndex : Int {
        return self.timeoutIndices[self.timeoutInSeconds]!
    }
    static private var idleTimer: Timer?
    
    // Listen for any touch. If the screen receives a touch, the timer is reset.
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        if UPennTimerUIApplication.idleTimer != nil {
            UPennTimerUIApplication.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == .began {
                    UPennTimerUIApplication.resetIdleTimer()
                }
            }
        }
    }
    
    // Reset the timer because there was user interaction.
    static func resetIdleTimer() {
        
        // Only trigger timer logout-timer if User is logged-in
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate,
            delegate.userIsLoggedIn {
            self.invalidateActiveTimer()
            
            self.idleTimer = Timer.scheduledTimer(timeInterval: self.timeoutInSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
        }
    }
    
    static func invalidateActiveTimer() {
        if let idleTimer = self.idleTimer {
            idleTimer.invalidate()
        }
    }
    
    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc static func idleTimerExceeded() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.ApplicationDidTimeoutNotification), object: nil)
    }
    
    static func updateTimeoutInterval(index: Int) {
        let seconds = self.timeoutIdxDict[index]
        UserDefaults.standard.set(seconds, forKey: self.timeoutKey)
        self.resetIdleTimer()
    }
}
