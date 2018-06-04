//
// Created by Ryan Liang on 6/6/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation
import AppKit

class MPVOpenGLView: NSView {

    var mpvgl: OpaquePointer?

    override init(frame: CGRect) {

        self.mpvgl = nil
        super.init(frame: frame)

        self.layer = MPVOpenGLLayer()
        self.wantsLayer = true
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
