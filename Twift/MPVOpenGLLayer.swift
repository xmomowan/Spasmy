//
// Created by Ryan Liang on 6/6/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import AppKit
import Foundation
import QuartzCore
import OpenGL.GL
import OpenGL.GL3

class MPVOpenGLLayer: NSOpenGLLayer {

    /// mpv handle, do not initialize OpenGL before passing in
    var mpvgl: OpaquePointer?
    
    var mpvglQueue = DispatchQueue(label: "io.ryanliang.twift.mpvopengl", qos: .userInteractive)

    func mpvInitOpenGLState(mpvgl: OpaquePointer?) {

        // @todo: move Unmanaged things to a standalone file
        self.update()
        self.mpvgl = mpvgl
        /// set up opengl
        mpv_opengl_cb_init_gl(mpvgl, nil, mpvGetOpenGLFunctionPointer, nil)

        // set up update callback
        mpv_opengl_cb_set_update_callback(mpvgl, mpvUpdate, UnsafeMutableRawPointer(Unmanaged<MPVOpenGLLayer>.passUnretained(self).toOpaque()))
    }

    override func openGLContext(for pixelFormat: NSOpenGLPixelFormat) -> NSOpenGLContext {
        let ctx = super.openGLContext(for: pixelFormat)

        CGLSetCurrentContext(ctx.cglContextObj)
        return ctx
    }

    override func canDraw(in context: NSOpenGLContext, pixelFormat: NSOpenGLPixelFormat, forLayerTime t: CFTimeInterval, displayTime ts: UnsafePointer<CVTimeStamp>) -> Bool {
        return true
    }

    override func draw(in context: NSOpenGLContext, pixelFormat: NSOpenGLPixelFormat, forLayerTime t: CFTimeInterval, displayTime ts: UnsafePointer<CVTimeStamp>) {

        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        if let mpvgl = mpvgl {

            // get currently bound fbo
            var fbo: GLint = 0
            glGetIntegerv(GLenum(GL_DRAW_FRAMEBUFFER_BINDING), &fbo)

            // get viewport size
            var viewport: [GLint] = [0, 0, 0, 0]
            glGetIntegerv(GLenum(GL_VIEWPORT), &viewport);

            // draw!
            mpv_opengl_cb_draw(mpvgl, fbo, viewport[2], -viewport[3])
            getGLError()
        } else {

            glClearColor(0, 0, 0, 1)
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        }
        glFlush()
    }

    func update() {

        super.display()
        CATransaction.flush()
    }

    override func display() {
        update()
    }

    func getGLError() {
        let error = glGetError()
        switch error {
        case GLenum(GL_NO_ERROR):
            break
        case GLenum(GL_INVALID_ENUM):
            print("GL_INVALID_ENUM")
            break
        case GLenum(GL_INVALID_VALUE):
            print("GL_INVALID_VALUE")
            break
        case GLenum(GL_INVALID_OPERATION):
            print("GL_INVALID_OPERATION")
            break
        case GLenum(GL_STACK_OVERFLOW):
            print("GL_STACK_OVERFLOW")
            break
        case GLenum(GL_STACK_UNDERFLOW):
            print("GL_STACK_UNDERFLOW")
            break
        case GLenum(GL_OUT_OF_MEMORY):
            print("GL_OUT_OF_MEMORY")
            break
        case GLenum(GL_INVALID_FRAMEBUFFER_OPERATION):
            print("GL_INVALID_FRAMEBUFFER_OPERATION")
            break
        case GLenum(GL_TABLE_TOO_LARGE):
            print("GL_TABLE_TOO_LARGE")
        default:
            break
        }
    }
}

/// Helper to get opengl functions, passed into mpv in mpv_opengl_cb_init_gl
fileprivate func mpvGetOpenGLFunctionPointer(_ ctx: UnsafeMutableRawPointer?, _ name: UnsafePointer<CChar>?) -> UnsafeMutableRawPointer? {
    let symbol: CFString = CFStringCreateWithCString(kCFAllocatorDefault, name, kCFStringEncodingASCII);
    guard let pointer = CFBundleGetFunctionPointerForName(CFBundleGetBundleWithIdentifier(CFStringCreateCopy(kCFAllocatorDefault, "com.apple.opengl" as CFString)), symbol) else {

        //@todo: add a logger or some error handle mechanism
        fatalError("OpenGL function pointer allocation failed.")
    }
    return pointer
}

/// Helper called by mpv when frame updates
fileprivate func mpvUpdate(_ ctx: UnsafeMutableRawPointer?) {

    guard let ctx = ctx else {
        fatalError("Update callback called without a context.")
    }

    let layer = Unmanaged<MPVOpenGLLayer>.fromOpaque(ctx).takeUnretainedValue()
    layer.mpvglQueue.async {
        layer.update()
    }
}
