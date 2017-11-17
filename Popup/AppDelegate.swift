//
//  AppDelegate.swift
//  Popup
//
//  Created by Maxim on 10/21/15.
//  Copyright © 2015 Maxim. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	let popover = NSPopover()
	var eventMonitor: EventMonitor?
    var mainViewController: ViewController!
    var currentAmountOfPullRequests = -1

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let button = statusItem.button {
			button.action = #selector(AppDelegate.togglePopover(_:))
		}
		
        mainViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ViewControllerId")) as! ViewController
		popover.contentViewController = mainViewController
		
		eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
			if let popover = self?.popover {
				if popover.isShown {
					self?.closePopover(event)
				}
			}
		}
		eventMonitor?.start()
        showPopover(nil)
        
        let t = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (t) in
            self.timerTick()
        }

        t.fire()
	}
    
    func timerTick() {

        var repo = ""
        var user = ""
        var pass = ""
        var apiRepoUrl = "https://api.bitbucket.org/2.0/repositories/your_company"
        
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbUsername")  {
            user = u
        }
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbPassword")  {
            pass = u
        }
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbRepository")  {
            repo = u
        }
        if let u = NSUserDefaultsController.shared.defaults.string(forKey: "bbAPIUrl")  {
            apiRepoUrl = u
        }
        
        let url = apiRepoUrl + "/" + repo + "/pullrequests/?state=OPEN"
        
        let bearer =  Request.authorizationHeader(user: user, password: pass)!
        let headers : HTTPHeaders = [bearer.key : bearer.value]
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                print(json)
                if let result = json as? [String: Any], let prs = result["values"] as? [Any]  {
//                for case let pr as [String: Any] in prs {
//                    print("-----")
//
//                    if  let title = pr["title"] as? String {
//                        print("title: \(title)")
//                    }
//
//                    if let author = pr["author"] as? [String: Any], let display_name = author["display_name"] as? String {
//                        print("author: \(display_name)")
//                    }
//
//                    if let destination = pr["destination"] as? [String: Any],
//                        let branch = destination["branch"] as? [String: Any],
//                        let name = branch["name"] as? String {
//
//                        print("destination: \(name)")
//                    }
//                }

                if self.currentAmountOfPullRequests != -1 && self.currentAmountOfPullRequests < prs.count {
                    self.showNotification(amountOfPullRequests: prs.count)
                }

                self.currentAmountOfPullRequests = prs.count

                self.updateStatusToView(nil)
                
            }
                
            case .failure(let error):
                print(error.localizedDescription)
                
                self.updateStatusToView(error)
            }
            
        }
        
        //manager.get(url, parameters: nil, progress:nil, success: { (task, any) in
           
            //if let result = any as? [String: Any], let prs = result["values"] as? [Any]  {
//                for case let pr as [String: Any] in prs {
//                    print("-----")
//
//                    if  let title = pr["title"] as? String {
//                        print("title: \(title)")
//                    }
//
//                    if let author = pr["author"] as? [String: Any], let display_name = author["display_name"] as? String {
//                        print("author: \(display_name)")
//                    }
//
//                    if let destination = pr["destination"] as? [String: Any],
//                        let branch = destination["branch"] as? [String: Any],
//                        let name = branch["name"] as? String {
//
//                        print("destination: \(name)")
//                    }
//                }
                
//                if self.currentAmountOfPullRequests != -1 && self.currentAmountOfPullRequests < prs.count {
//                    self.showNotification(amountOfPullRequests: prs.count)
//                }
//
//                self.currentAmountOfPullRequests = prs.count
//
//                self.updateStatusToView(nil)
//            }
//
//        }, failure: { (task, error) in
//            self.updateStatusToView(error)
//        })
    }
    
    func showNotification(amountOfPullRequests: Int) -> Void {
        let notification = NSUserNotification()
        notification.title = "New pull request created."
        notification.informativeText = "There are now \(amountOfPullRequests) open pull requests."
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }

	@objc func togglePopover(_ sender: AnyObject?) {
		if popover.isShown {
			closePopover(sender)
		} else {
			showPopover(sender)
		}
	}
	
	func showPopover(_ sender: AnyObject?) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			eventMonitor?.start()
            updateStatusToView(nil)
		}
	}
	
	func closePopover(_ sender: AnyObject?) {
		popover.performClose(sender)
		eventMonitor?.stop()
	}
    
    private func updateStatusToView(_ error: Error?) {
        if let e = error {
            statusItem.title = "😢"
            self.mainViewController.setStatus(s: "😢 \(e.localizedDescription)")

            return
        }
        
        if self.currentAmountOfPullRequests > 0 {
            statusItem.title = "🤓 \(self.currentAmountOfPullRequests)"
            self.mainViewController.setStatus(s: "🤓 \(self.currentAmountOfPullRequests) open pull requests.")
        } else {
            statusItem.title = "🎉"
            self.mainViewController.setStatus(s: "🎉 No open pull requests! Go home.")
        }
    }
}

