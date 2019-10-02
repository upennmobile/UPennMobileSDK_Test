//
//  UPennLoginViewController.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/12/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class UPennLoginViewController: UPennBasicViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: PrimaryCTAButton!
    @IBOutlet weak var autoFillButton: PrimaryCTAButtonText!
    @IBOutlet weak var titleLabel: BannerLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rememberMeLabel: ContactDepartmentLabel!
    
    fileprivate var validationService: UPennValidationService!
    fileprivate var keyboardService: UPennKeyboardService!
    fileprivate var biometricsService: UPennBiometricsAuthService!
    fileprivate var appDelegate : AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    fileprivate lazy var touchIDAlertController : UIAlertController = {
        let alertController = UIAlertController(
            title: self.biometricsService.touchIDOptInTitle,
            message: self.biometricsService.touchIDOptInMessage,
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: self.biometricsService.touchIDDeclined, style: .cancel, handler: {
            alert -> Void in
            // Force biometrics off, and complete login flow to close-out LoginVC
            self.biometricsService.toggleBiometrics(false)
            self.sendLoginNotification()
        })
        let useTouchIDAction = UIAlertAction(title: self.biometricsService.touchIDConfirmed, style: .default, handler: {
            alert -> Void in
            // Turn on Biometrics Settings & complete Touch ID registration to ensure no repeat launches of Touch ID alert
            self.turnOnBiometricAuthSettings()
            self.biometricsService.completeTouchIDRegistration()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(useTouchIDAction)
        return alertController
    }()
    
    fileprivate lazy var rememberMeAlertController : UIAlertController = {
        let alertController = UIAlertController(
            title: self.biometricsService.biometricOptOutMessage,
            message: "",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil)
        let disableRememberMe = UIAlertAction(title: "OK".localize, style: .default, handler: {
            alert -> Void in
            self.biometricsService.toggleBiometrics(false)
            self.toggleRememberMe()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(disableRememberMe)
        return alertController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppear()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDidDisappear()
    }
    
    func setup() {
        // General
        self.appDelegate?.setLoginDelegate(loginDelegate: self)
        self.biometricsService = UPennBiometricsAuthService(biometricsDelegate: self)
        self.titleLabel.text = UPennConfigurationsService.AppDisplayName.localize
        
        // Set up textFields
        self.emailField.delegate = self
        self.emailField.placeholder = "username".localize
        self.emailField.autocorrectionType = .no
        self.emailField.returnKeyType = .next
        self.passwordField.autocorrectionType = .no
        self.passwordField.placeholder = "password".localize
        self.passwordField.delegate = self
        self.passwordField.returnKeyType = .done
        self.passwordField.isSecureTextEntry = true
        self.validationService = UPennValidationService(textFields: [ self.emailField, self.passwordField ])
        
        // Set up Buttons
        self.autoFillButton.adjustsImageWhenHighlighted = false
        self.autoFillButton.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        self.autoFillButton.setImage(#imageLiteral(resourceName: "un_checked"), for: .normal)
        
        // Set up Touch Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleLoginAutoFill))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.rememberMeLabel.isUserInteractionEnabled = true
        self.rememberMeLabel.addGestureRecognizer(tap)
        self.rememberMeLabel.textColor = UIColor.upennDarkBlue
    }
    
    @IBAction func pressedLogin(_ sender: Any) {
        self.login()
    }
    
    @IBAction func pressedAutoFillButton(_ sender: UIButton) {
        self.toggleLoginAutoFill()
    }
    
}

// MARK: - UITextFieldDelegate

extension UPennLoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.advanceTextfields(textfield: textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

// MARK: - LoginService Delegate

extension UPennLoginViewController : UPennLoginServiceDelegate {
    
    func didSuccessfullyLoginUser(_ username: String) {
        SVProgressHUD.dismiss()
        
        /*
         * 1. Trigger Logout timer
         * 2. Send username & PN deviceToken to server
         * 2. Check for 1st Launch & register Biometrics opt-in
         */
        self.appDelegate?.resetLogoutTimer()
        UPennPushNotificationService().updateBackendForPushNotifications(with: username)
        if let isFirstLogin = self.appDelegate?.isFirstLogin, isFirstLogin {
            self.appDelegate?.setFirstLogin()
            self.biometricsService.registerForBiometricAuthentication()
            return
        }
        
        /*
         * Check if biometrics where enabled in Accounts before being properly registered
         */
        if self.biometricsService.enabledBiometricsBeforeRegistered {
            self.biometricsService.registerForBiometricAuthentication()
            return
        }
        self.sendLoginNotification()
        
        // Analytics
        //        AnalyticsService.trackLoginEvent() TODO: Not Needed?
    }
    
    func didReturnAutoFillCredentials(username: String, password: String) {
        self.emailField.text = username
    }
    
    func didFailToLoginUser(errorStr: String) {
        SVProgressHUD.showError(withStatus: errorStr)
    }
}

// MARK: - BiometricsDelegate

extension UPennLoginViewController : UPennBiometricsDelegate {
    func registerForTouchIDAuthentication() {
        self.present(self.touchIDAlertController, animated: true, completion: nil)
    }
    
    func registerForFaceIDAuthentication() {
        self.biometricsService.utilizeBiometricAuthentication(turnOnBiometrics: true)
    }
    
    func biometricsSuccessfullyAuthenticated(turnOnBiometrics: Bool) {
        // Check if isFirstLogin - indicates user has opted-in to use biometrics, so must trigger settings updates
        if turnOnBiometrics {
            self.turnOnBiometricAuthSettings()
            return
        }
        SVProgressHUD.show(withStatus: "Logging in.....")
        self.appDelegate?.attemptSilentLogin()
    }
    
    func biometricsDidError(with message: String?, shouldContinue: Bool) {
        // Check if isFirstLogin - indicates user has canceled opt-in to biometrics, so complete login and push to ChangeRequestVC
        if shouldContinue {
            self.sendLoginNotification()
            return
        }
        guard let m = message else { return }
        SVProgressHUD.showError(withStatus: m)
    }
}

// MARK: - Private

private extension UPennLoginViewController {
    
    func verifyFields() {
        self.loginButton.isEnabled = validationService.loginFieldsAreValid
    }
    
    func viewDidAppear() {
        self.appDelegate?.authenticationAutoFillCheck()
        verifyFields()
        self.attemptBiometricsPresentation()
        self.autoFillButton.isSelected = self.appDelegate?.shouldAutoFill ?? false
    }
    
    func viewDidDisappear() {
        self.validationService.resetTextFields()
    }
    
    func login() {
        SVProgressHUD.show(withStatus: "Logging in.....")
        self.appDelegate?.makeLoginRequest(username: self.emailField.text!, password: self.passwordField.text!)
    }
    
    @objc func toggleLoginAutoFill() {
        if autoFillButton.isSelected && self.biometricsService.biometricsEnabled {
            self.present(self.rememberMeAlertController, animated: true, completion: nil)
            return
        }
        self.toggleRememberMe()
    }
    
    @objc func textFieldDidChange(_ sender: Any) {
        verifyFields()
    }
    
    func toggleRememberMe(_ enabled: Bool = false) {
        if enabled {
            self.autoFillButton.isSelected = enabled
            self.appDelegate?.toggleShouldAutoFill(enabled)
            return
        }
        self.autoFillButton.isSelected = !self.autoFillButton.isSelected
        self.appDelegate?.toggleShouldAutoFill(self.autoFillButton.isSelected)
    }
    
    func advanceTextfields(textfield: UITextField) {
        let nextTag: NSInteger = textfield.tag + 1
        if let nextResponder: UIResponder = textfield.superview!.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textfield.resignFirstResponder()
            self.login()
        }
    }
    
    func attemptBiometricsPresentation() {
        if let shouldAutoFill = self.appDelegate?.shouldAutoFill, shouldAutoFill {
            self.biometricsService.attemptBiometricsAuthentication()
        }
    }
    
    func turnOnBiometricAuthSettings() {
        /*
         * 1. Toggle biometrics enabled On
         * 2. Toggle 'Remember Me' On
         * 3. Cache login credentials
         * 4. Trigger login notification
         */
        self.biometricsService.toggleBiometrics(true)
        self.toggleRememberMe(true)
        self.appDelegate?.cacheLoginCredentials(username: emailField.text!, password: passwordField.text!)
        self.sendLoginNotification()
    }
    
    func sendLoginNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPennLoginService.IsLoggedInNotification), object: nil)
    }
}

extension UPennLoginViewController : UIGestureRecognizerDelegate { }

