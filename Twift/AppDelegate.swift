//
//  AppDelegate.swift
//  Twift
//
//  Created by Ryan Liang on 5/29/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Cocoa
import Twitchy

fileprivate func mpvGetOpenGL(_ ctx: UnsafeMutableRawPointer?, _ name: UnsafePointer<CChar>?) -> UnsafeMutableRawPointer? {
    let symbolName: CFString = CFStringCreateWithCString(kCFAllocatorDefault, name, kCFStringEncodingASCII);
    guard let addr = CFBundleGetFunctionPointerForName(CFBundleGetBundleWithIdentifier(CFStringCreateCopy(kCFAllocatorDefault, "com.apple.opengl" as CFString)), symbolName) else {
        fatalError("Cannot get OpenGL function pointer!")
    }
    return addr
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var controller: Test!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        controller = Test(nibName: nil, bundle: nil)
        window.contentView?.addSubview(controller.view)
        
        
//        let loadfile = "loadfile"
//        let location = "https://video-weaver.lhr03.hls.ttvnw.net/v1/playlist/CsoD0BLUts8_KODLC64hMk48JwZf3Gsfa8iVY_dheLz_9NhGNUwSl09AEVwvfAkA1EuafS3Je9JlIX9wPCthL88Y_Ni7w6wr2dcXeaOUOE2anySrGHCBMudeioVdvhOUqDRoAyvEVI6T38_y9ZODkY71vr7X4a-igm_ZRCSvU_8dPeoVCwOBB2J_aQ0WyPjseTCJAKsf-DeYmWxKT-wrsoXXNAHoKOrzQtnjr3WlIamOCA3ishv0lsssM7IwVkv5b34D2a6KaxO4hClp3d9efj5TnZdG5HRIXeSbyPHsn8paB93_eom-tUX6F9v7dUlf6PjUGiF6atKoRrtP9Pl02qXHeq0uSWbAvsCn8foIlZcTBi49e8rhbIbeTXZSAI18wHbg1FnVYBoFyzYp0HKxMh0THjeeGzBBzIiWIagepTUmWQ96Rr7xa8nBqdoYxlTmNnSItjxr33f8kC13EP9IXIufKBBe5GRkEnbiqwfrPYQVzzxu4e5ZCq1TAfCsudGvjJj3aKzWWk64yjheh2yKL9WeMHRH3zRnLFwm2hU2cgW4Jw2-giz6cox68egwteTbNzlMDzA1lG1YBIjm-0UCkdBkssATvOaH9ph-OdwSEITWsuvXj5xkBtj0W-eRMBoaDPjzrcuvnRPdAypmYw.m3u8"
//        let array1 = [loadfile, location, nil]
//        var array2 = array1.map { $0.flatMap { UnsafePointer<Int8>(strdup($0)) } }
//
//
//        let mpv = mpv_create()
//        print(mpv_initialize(mpv))
//        print(mpv_set_property_string(mpv, UnsafePointer<Int8>(strdup("vo")), UnsafePointer<Int8>(strdup("opengl-cb"))))
//        print(mpv_set_property_string(mpv, UnsafePointer<Int8>(strdup("opengl-hwdec-interop")), UnsafePointer<Int8>(strdup("auto"))))
//
//        mpv_command(mpv, &array2)
//        let mpvGL = mpv_get_sub_api(mpv, MPV_SUB_API_OPENGL_CB);
//
//        let video = VideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
//        video.mpvGLContext = OpaquePointer(mpvGL)
        
        
    }
    
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

func mutableRawPointerOf<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

fileprivate func mpvUpdateCallback(_ ctx: UnsafeMutableRawPointer?) {
    let layer = unsafeBitCast(ctx, to: CAOpenGLLayer.self)
    layer.display()
}
