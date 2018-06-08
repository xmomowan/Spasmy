//
//  StreamWindowController.swift
//  Twift
//
//  Created by Ryan Liang on 6/8/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Cocoa

class StreamWindowController: NSWindowController {

    override var windowNibName: NSNib.Name {
        return NSNib.Name(rawValue: "StreamWindowController")
    }

    let player: Player

    required init() {

        self.player = Player()
        super.init(window: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        do {
            try self.player.mpvInitialize()
        } catch {

            // @todo: display something and close the window?
            return
        }

        guard let wi = self.window else { return }
        guard let content = wi.contentView else { return }
        let _ = self.player.makePlayerView(asLastSubviewOf: content)
    }

    static func open(url: String) {
        DispatchQueue.main.sync {
            let controller = StreamWindowController()
            controller.showWindow(controller)
            // @todo: wrap this up
            let loadfile = "loadfile"
            let array1 = [loadfile, url, nil]
            var array2 = array1.map { $0.flatMap { UnsafePointer<Int8>(strdup($0)) } }
            
            mpv_command(controller.player.mpv.mpv_handle, &array2)
        }
        

        
    }
}
