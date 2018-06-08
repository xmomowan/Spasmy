//
// Created by Ryan Liang on 6/8/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// This class works as a wrapper around mpv APIs, and controls the mpv instance, including
/// passing commands and manage the life cycle.
class MPVController {

    var isCoreInitialized: Bool = false

    var isGlInitialized: Bool = false

    var mpv_handle: OpaquePointer!

    var mpv_gl: OpaquePointer!

    init() { }

    func initializeMpv() throws {

        guard let mpv = mpv_create() else {

            throw TwiftError.mpv(reason: .coreInitializationFailure)
        }

        self.mpv_handle = mpv

        // @todo: error handling
        mpv_initialize(mpv_handle)
        // @todo: wrap the strings up
        mpv_set_property_string(mpv_handle, UnsafePointer<Int8>(strdup("vo")), UnsafePointer<Int8>(strdup("opengl-cb")))
        mpv_set_property_string(mpv_handle, UnsafePointer<Int8>(strdup("opengl-hwdec-interop")), UnsafePointer<Int8>(strdup("auto")))

        self.isCoreInitialized = true

        try self.makeMpvGlHandle()
    }

    private func makeMpvGlHandle() throws {

        guard let mpv = mpv_handle,
              let gl = mpv_get_sub_api(mpv, MPV_SUB_API_OPENGL_CB) else {

            // @todo: add error
            throw TwiftError.mpv(reason: .openglInitializationFailure)
        }

        self.mpv_gl = OpaquePointer(gl)

        self.isGlInitialized = true
    }
}