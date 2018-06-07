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

    var mpv_handle: OpaquePointer?
    var mpv_gl: OpaquePointer?

    init() {

        self.mpv_handle = mpv_create()
        mpv_initialize(self.mpv_handle)
        self.mpv_gl = OpaquePointer(mpv_get_sub_api(mpv_handle, MPV_SUB_API_OPENGL_CB))
    }

    func makePlayerView(asSubviewOf parent: NSView) -> NSView {

        guard let mpv_gl = mpv_gl else {

            // @todo: better error handling
            fatalError("mpv OpenGL failed")
        }

        let view = MPVOpenGLView(frame: parent.frame)
        parent.addSubview(view)
        view.initializeAsSubview(mpvgl: mpv_gl)
        return view
    }

    deinit {

        // @todo: do we actually need this? Or do we use mpv_detach_destroy()?
        if let mpv = mpv_handle {

            mpv_terminate_destroy(mpv)
        }
    }
}
