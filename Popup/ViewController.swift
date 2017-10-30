//
//  ViewController.swift
//  Popup
//
//  Created by Maxim on 10/21/15.
//  Copyright © 2015 Maxim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var lastStatusLabel: NSTextField!
    @IBOutlet weak var bbUsername: NSTextField!
    @IBOutlet weak var bbPassword: NSSecureTextField!
    @IBOutlet weak var bbRepository: NSTextFieldCell!
    @IBOutlet weak var bbAPIUrl: NSTextField!
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        statusLabel?.stringValue = ""
        lastStatusLabel?.stringValue = ""
        
        readSettings()
	}
    
    @IBAction func saveSettings(_ sender: Any) {
        NSUserDefaultsController.shared.defaults.setValue(bbUsername.stringValue, forKey: "bbUsername")
        NSUserDefaultsController.shared.defaults.setValue(bbPassword.stringValue, forKey: "bbPassword")
        NSUserDefaultsController.shared.defaults.setValue(bbRepository.stringValue, forKey: "bbRepository")
        NSUserDefaultsController.shared.defaults.setValue(bbAPIUrl.stringValue, forKey: "bbAPIUrl")
        
        //performSegue(withIdentifier: NSStoryboardSegue.Identifier("showPullRequests"), sender: self)
        
        if let pullRequestViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PullRequestViewController")) as? NSViewController {
            
            
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.popover.contentViewController = pullRequestViewController
        }
        
    }
    
    private func readSettings() {
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbUsername")  {
            bbUsername.stringValue = u
        }
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbPassword")  {
            bbPassword.stringValue = u
        }
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbRepository")  {
            bbRepository.stringValue = u
        }
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbAPIUrl")  {
            bbAPIUrl.stringValue = u
        }
    }
    
    func setStatus(s: String) {
        statusLabel?.stringValue = s

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let someDateTime = formatter.string(from: Date())
        
        lastStatusLabel?.stringValue = "Updated at \(someDateTime)"
        
        readSettings()
    }

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func closeButtonAction(_ sender: NSButton) {
		NSApp.terminate(self)
	}

}

