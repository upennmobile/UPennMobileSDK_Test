//
//  UPennSettingsViewController.swift
//  Unable To Scan
//
//  Created by Rashad Abdul-Salam on 6/21/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennSettingsViewController : UITableViewController {
    private enum Sections : Int {
        case Settings
        
        static var count : Int {
            return Settings.rawValue+1
        }
        
        enum Rows : Int {
            case Timeout
            case Biometrics
            case Logout
            
            static var count : Int {
                return Logout.rawValue+1
            }
        }
    }
    
    private enum SectionTitles : String {
        case Settings = "Settings"
    }
    
    private enum Identifiers : String {
        case Timeout = "TimeoutCell"
        case Biometrics = "BiometricsCell"
        case Logout = "LogoutCell"
    }
    
    var appDelegate : AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var biometricsService = UPennBiometricsAuthService()
    
    override func viewDidLoad() {
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func setup() {
        super.navBarSetup()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _section = Sections(rawValue: section) else { return 0 }
        
        switch _section {
        case .Settings:
            return Sections.Rows.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Sections(rawValue: indexPath.section), let row = Sections.Rows(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch section {
        case .Settings:
            switch row {
            case .Timeout:
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Timeout.rawValue) as! UPennAutoLogoutCell
                return cell
            case .Biometrics:
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Biometrics.rawValue) as! UPennBiometricsEnableCell
                cell.configure(with: self, biometricsService: self.biometricsService)
                return cell
            case .Logout:
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Logout.rawValue) as! UPennLogoutCell
                cell.configure()
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section), let row = Sections.Rows(rawValue: indexPath.row) else { return }
        // Logout User if Logout Cell pressed
        switch section {
        case .Settings:
            switch row {
            case .Logout: self.appDelegate?.logout()
            default: return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionTitles.Settings.rawValue
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Create View
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UPennScreenGlobals.Width, height: 30))
        view.backgroundColor = UIColor.upennRlyLightGray
        // Create Label
        let versionStr = UPennConfigurationsService.CurrentAppVersion
        
        let titleLabel = UPennLabel(frame: CGRect(x: UPennScreenGlobals.Padding, y: 20, width: UPennScreenGlobals.Width - (UPennScreenGlobals.Padding*2), height: 20))
        titleLabel.textColor = UIColor.upennBlack
        titleLabel.textAlignment = .right
        titleLabel.setFontHeight(size: 10)
        let appname = UPennConfigurationsService.AppDisplayName
        let versionText = "\(appname) Version \(versionStr)"
        titleLabel.text = versionText.localize
        view.addSubview(titleLabel)
        return view
    }
}

extension UPennSettingsViewController : UPennBiometricsToggleDelegate {
    func toggledBiometrics(_ enabled: Bool) {
        self.biometricsService.toggleBiometrics(enabled)
        // If biometrics is enabled, toggle 'Remember Me' on in LoginVC
        if enabled {
            self.appDelegate?.toggleShouldAutoFill(enabled)
        }
    }
}

