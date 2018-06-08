//
//  AppDelegate.swift
//  Twift
//
//  Created by Ryan Liang on 5/29/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Cocoa
import Twitchy

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWC: MainWindowController = MainWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        Twitchy.Keys.shared = Keys(auth: "", clientID: "ueyc1gpxiqlue0ozni3n8bfxjlycya")
        mainWC.showWindow(nil)
    }
    
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
