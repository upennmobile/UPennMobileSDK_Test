//
//  UPennRootViewController.swift
//  Phone Book
//
//  Created by Rashad Abdul-Salam on 6/6/18.
//  Copyright © 2018 UPenn. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class UPennRootViewController : UIViewController {
    
    var appDelegate : AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var tabController: UITabBarController?
    // NavControllers
    var loginNavController: UIViewController!
    var timelineNavController: UIViewController!
    var settingsNavController: UIViewController!
    var pushedGUID: String?
    
    fileprivate var checkedForVersion = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigationControllers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkAppVersionForLaunch()
    }
    
    func resetToLogin() {
        if let _ = self.presentedViewController {
            self.dismiss(animated: true) {
                self.showLogin()
            }
            return
        }
        self.showLogin()
    }
    
    func dismissAndPresentLogout() {
        // Check if a viewController is presented, if not, show Auto-logout alert
        guard let presentedVC = self.presentedViewController else {
            self.showLogoutAlert()
            return
        }
        
        // Check if the LoginViewController is presented, if not, show Auto-logout alert
        guard let _ = presentedVC as? UPennLoginViewController else {
            self.dismiss(animated: true) {
                self.showLogoutAlert()
            }
            return
        }
    }
    
    func goToSection(_ section: TabSection, with data: Any?=nil) {
        switch section {
        default: break
        }
    }
}

// MARK: - UITablBarControllerDelegate

extension UPennRootViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
//        if let contactsVC = viewController.childViewControllers.first as? ChangeRequestListViewController, let _ = contactsVC.view {
//            if let delegate = self.appDelegate, !delegate.isLoggedIn {
//                delegate.logout()
//            } else {
//                contactsVC.reloadView()
//            }
//            return
//        }
//
        if let tlVC = viewController.children.first as? UTSSubmitItemViewController, let _ = tlVC.view {
            tlVC.reloadView()
            return
        }

        // If clicking Accounts Tab, check if logged-out, if so, present login

        if let accountsVC = viewController.children.first as? UPennSettingsViewController, let _ = accountsVC.view {
            if let delegate = self.appDelegate, !delegate.userIsLoggedIn {
                delegate.logout()
            }
        }
    }
}

// MARK: - Private

fileprivate extension UPennRootViewController {
    
    var mainTabViewController: UITabBarController {
        // If there's already a tabController on the stack, remove it then create a fresh one to avoid cluttering the stack
        if let tabVC = self.tabController {
            tabVC.view.removeFromSuperview()
        }
        self.tabController = self.appDelegate?.storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController
        self.tabController?.delegate = self
        return self.tabController!
    }
    
    var logoutAlertController : UIAlertController {
        let alertController = UIAlertController(title: "You've Been Logged-out", message: "For security purposes you've been automatically logged-out due to inactivity. Please log back in.", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Login", style: .cancel, handler: {
            alert -> Void in
            if let delegate = self.appDelegate { delegate.logout() }
        })
        alertController.addAction(logoutAction)
        return alertController
    }
    
    var optionalUpdateAlert : UIAlertController {
        let alertCtrl = UIAlertController(
            title: "App Update Available",
            message: "Version \(UPennConfigurationsService.LatestAppVersion) of the UPHS CR Viewer App is available. If you want to update, press 'Get Update' and follow the instructions.",
            preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(
            title: "Get Update",
            style: .cancel,
            handler: nil))
        alertCtrl.addAction(UIAlertAction(
            title: "Skip Update",
            style: .default,
            handler: { (action) in
                self.appDelegate?.skipUpdate()
                self.showLoginVsMainTabViewController()
        }))
        return alertCtrl
    }
    
    var mandatoryUpdateAlert : UIAlertController {
        let alertCtrl = UIAlertController(
            title: "App Update Available (MANDATORY)",
            message: "To continue using the UPHS CR Viewer App, you MUST update to version \(UPennConfigurationsService.LatestAppVersion). Press 'Get Update' and follow the instructions.",
            preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(
            title: "Get Update",
            style: .cancel,
            handler: nil))
        return alertCtrl
    }
    
    var userLoggedIn : Bool {
        return self.appDelegate?.userIsLoggedIn ?? false
    }
    
    // MARK: - VC Factory Methods
    
    func makeNavigationController(identifier: String) -> UIViewController? {
        let navVC = self.appDelegate?.storyboard.instantiateViewController(withIdentifier: identifier) as? UINavigationController
        return navVC
    }
    func makeNavigationControllers() {
        self.loginNavController = self.makeNavigationController(identifier: "LoginNav")
        self.timelineNavController = self.makeNavigationController(identifier: "TakePhotoNav")
        self.settingsNavController = self.makeNavigationController(identifier: "SettingsNav")
    }
    
    func makeParentViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func swapParentViewController(fromVC: UIViewController, toVC: UIViewController) {
        addChild(toVC)
        toVC.view.frame = view.bounds
        view.addSubview(toVC.view)
        toVC.didMove(toParent: self)
        fromVC.willMove(toParent: nil)
        fromVC.view.removeFromSuperview()
        fromVC.removeFromParent()
    }
    
    var updateViewController: UIViewController {
        return self.appDelegate!.storyboard.instantiateViewController(withIdentifier: "UpdateViewVC")
    }
    
    func checkAppVersionForLaunch() {
        if !self.checkedForVersion {
            UPennConfigurationsService.checkLatestAppVersion { (isUpdatable, updateRequired, errorMessage) in
                self.checkedForVersion = true
                // If errorMessage show it
                // TODO: Commented For Testing
//                if let message = errorMessage {
//                    SVProgressHUD.showError(withStatus: message)
//                    self.showLoginVsMainTabViewController()
//                    return
//                }
//                // If updateRequired show mandatory alert
//                if updateRequired {
//                    self.showUpdateViewController()
//                    self.present(self.mandatoryUpdateAlert, animated: true, completion: nil)
//                    return
//                }
//                // If isUpdatable show optional update alert
//                if
//                    let skippedUpdate = self.appDelegate?.didSkipThisUpdate,
//                    isUpdatable && !skippedUpdate {
//                    self.showUpdateViewController()
//                    self.present(self.optionalUpdateAlert, animated: true, completion: nil)
//                    return
//                }
                self.showLoginVsMainTabViewController()
            }
        }
    }
    // TODO: Not Needed?
//    func showTabMainController() {
//        if
//            let navVC = self.tabController?.selectedViewController as? UINavigationController,
//            let tlVC = navVC.children.first as? UPennTimelineViewController,
//            let _ = tlVC.view
//        {
//          self.presentLoginViewController()
//          tlVC.reloadView()
//        }
//        self.makeParentViewController(self.mainTabViewController)
//    }
    
    func showLogin() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.swapLoginFromMainTabViewController), name: NSNotification.Name.init(UPennLoginService.IsLoggedInNotification), object: nil)
        self.swapParentViewController(fromVC: self.mainTabViewController, toVC: self.loginNavController)
    }
    
    func presentLoginViewController() {
        self.present(self.loginNavController, animated: true, completion: nil)
    }
    
    func showUpdateViewController() {
        self.makeParentViewController(self.updateViewController)
    }
    
    func showLogoutAlert() {
        self.appDelegate?.invalidateAuthToken()
        self.present(self.logoutAlertController, animated: true, completion: nil)
    }
    
    /**
     * Determine whether user is logged-in or not to decide to launch LoginVC vs. MainTabBarVC -- avoid wasteful search of CRs by MainTabBar before User logged-in
     * If not logged in, show LoginViewController as ParentVC
     * Else show TabBarController as ParentVC & launch
     */
    func showLoginVsMainTabViewController() {
        // TODO: TESTING!!!
//        self.makeParentViewController(self.mainTabViewController)
        
        if self.userLoggedIn {
            //self.showTabMainController()
            self.makeParentViewController(self.mainTabViewController)
        } else {
            self.resetToLogin()
        }
    }
    
    @objc func swapLoginFromMainTabViewController() {
        /*
         * 1. Swap MainTabController in for LoginVC
         * 2. Remove Login Observer
         * 3. If logging-in following PN tap, push to Timeline section passing GUID data
         */
        // 1.
        self.swapParentViewController(fromVC: self.loginNavController, toVC: self.mainTabViewController)
        // 2.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: UPennLoginService.IsLoggedInNotification), object: nil)
        // 3.
        guard let guid = self.pushedGUID else { return }
        self.goToSection(.Timeline, with: guid)
    }
    
    func resetTabControllerStack() {
        // Re-create TabController Stack
        let vcStack = [
            self.timelineNavController,
            self.settingsNavController
        ]
        self.tabController?.setViewControllers(vcStack as? [UIViewController], animated: false)
        self.pushedGUID = nil
    }
}


