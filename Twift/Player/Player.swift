//
//  Player.swift
//  Twift
//
//  Created by Ryan Liang on 6/7/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Cocoa

/// The controller for video related stuff
/// Holds a single reference to a private mpv handle, which means you have to create
/// another one if you are watching multiple videos
class Player {

    let mpv: MPVController

    init() {

        self.mpv = MPVController()
    }

    func mpvInitialize() throws {

        try mpv.initializeMpv()
    }

    func makePlayerView(asLastSubviewOf parent: NSView) -> NSView {

        let view = MPVOpenGLView(frame: parent.frame)
        parent.addSubview(view, positioned: .below, relativeTo: nil)
        view.initializeAsSubview(mpvgl: self.mpv.mpv_gl)
        return view
    }

    deinit {

        // @todo: do we actually need this? Or do we use mpv_detach_destroy()?
//        if let mpv = mpv_handle {
//
//            mpv_terminate_destroy(mpv)
//        }
    }
}
