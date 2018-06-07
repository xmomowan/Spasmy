//
// Created by Ryan Liang on 6/6/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import AppKit
import Foundation
import QuartzCore
import OpenGL.GL
import OpenGL.GL3

class MPVOpenGLLayer: CAOpenGLLayer {

    // MARK: Fields

    /// mpv handle, do not initialize OpenGL before passing in
    var mpvgl: OpaquePointer? {

        // update self once before assigning, or mpv would be unhappy during OpenGL initialization
        willSet {
            self.update()
        }

        didSet {
            self.initializeMPVOpenGL()
        }
    }

    /// A queue to update our layer asynchronously
    var mpvglQueue = DispatchQueue(label: "io.ryanliang.twift.mpvopengl", qos: .userInteractive)

    private func initializeMPVOpenGL() {
        
        /// set up OpenGL
        mpv_opengl_cb_init_gl(mpvgl, nil, mpvGetOpenGLFunctionPointer, nil)

        // set up update callback
        // @todo: move Unmanaged things to a standalone file
        mpv_opengl_cb_set_update_callback(mpvgl, mpvUpdate, UnsafeMutableRawPointer(Unmanaged<MPVOpenGLLayer>.passUnretained(self).toOpaque()))
    }

    // MARK: Draw

    override func copyCGLContext(forPixelFormat pf: CGLPixelFormatObj) -> CGLContextObj {
        let ctx = super.copyCGLContext(forPixelFormat: pf)

        CGLSetCurrentContext(ctx)
        return ctx
    }

    override func canDraw(inCGLContext ctx: CGLContextObj, pixelFormat pf: CGLPixelFormatObj, forLayerTime t: CFTimeInterval, displayTime ts: UnsafePointer<CVTimeStamp>?) -> Bool {
        return true
    }

    override func draw(inCGLContext ctx: CGLContextObj, pixelFormat pf: CGLPixelFormatObj, forLayerTime t: CFTimeInterval, displayTime ts: UnsafePointer<CVTimeStamp>?) {

        // when updating for the first time after setting mpvgl, the mpvgl is not
        // yet initialized by init_gl, and the draw would fail because of an assertion of ctx->renderer
        // so we only try drawing after that.
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

            // clear to black
            glClearColor(0, 0, 0, 1)
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        }

        glFlush()
    }

    func update() {

        // https://stackoverflow.com/questions/7610117
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

// MARK: MPV Callbacks

/// Helper to get OpenGL functions, passed into mpv in mpv_opengl_cb_init_gl
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

    // cast pointer back to the layer
    let layer = Unmanaged<MPVOpenGLLayer>.fromOpaque(ctx).takeUnretainedValue()
    layer.mpvglQueue.async {
        layer.update()
    }
}
