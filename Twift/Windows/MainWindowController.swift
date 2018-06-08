//
//  MainWindowController.swift
//  Twift
//
//  Created by Ryan Liang on 6/8/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Cocoa
import Twitchy

class MainWindowController: NSWindowController {

    override var windowNibName: NSNib.Name {
        return NSNib.Name(rawValue: "MainWindowController")
    }

    @IBOutlet var goButton: NSButton!
    @IBOutlet var channelText: NSTextField!

    init() {

        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @IBAction func goToStream(_ sender: Any) {

        Private.getStreamAccessToken(forChannel: self.channelText.stringValue) {

            [unowned self] result in

            let result = result.value!
            // @todo: make Twitchy return channel name along
            DispatchQueue.main.sync {
                Private.getStreamPlaylist(forChannel: self.channelText.stringValue,
                        token: result.token,
                        signature: result.signature) {

                    let stream = try! M3UParser.parseTwitchStreamPlaylist(fromData: $0.value!)
                    print(stream)

                    let url = stream.transcodes[0].url.absoluteString

                    StreamWindowController.open(url: url)
                }
            }
        }
    }
    
}
