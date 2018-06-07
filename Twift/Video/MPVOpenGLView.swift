//
// Created by Ryan Liang on 6/6/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation
import AppKit

class MPVOpenGLView: NSView {

    /// mpv handler
    private var mpvgl: OpaquePointer?

    /// mpv OpenGL layer
    private let mpvlayer: MPVOpenGLLayer

    override init(frame: CGRect) {

        let layer = MPVOpenGLLayer()
        self.mpvlayer = layer

        super.init(frame: frame)
        self.layer = layer
        self.wantsLayer = true
    }

    /// MUST call this AFTER add the view as some other view's subview
    func initializeAsSubview(mpvgl: OpaquePointer) {

        self.mpvgl = mpvgl
        self.mpvlayer.mpvgl = mpvgl
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
