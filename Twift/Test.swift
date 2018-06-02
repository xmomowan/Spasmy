//
//  Test.swift
//  Twift
//
//  Created by Ryan Liang on 6/2/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Cocoa

class Test: NSViewController {
    
    @IBOutlet var button: NSButton!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func pushed(_ sender: Any) {
        
        let loadfile = "loadfile"
        let location = ""
        let array1 = [loadfile, location, nil]
        var array2 = array1.map { $0.flatMap { UnsafePointer<Int8>(strdup($0)) } }
        
        let mpv = mpv_create()
        print(mpv_initialize(mpv))
        print(mpv_set_property_string(mpv, UnsafePointer<Int8>(strdup("vo")), UnsafePointer<Int8>(strdup("opengl-cb"))))
        print(mpv_set_property_string(mpv, UnsafePointer<Int8>(strdup("opengl-hwdec-interop")), UnsafePointer<Int8>(strdup("auto"))))
        
        setenv("http_proxy", "http://192.168.1.10:8123", 1)
        setenv("https_proxy", "http://192.168.1.10:8123", 1)
        
        let video = VideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.view.addSubview(video)
        video.videoLayer.display()
        let mpvGL = mpv_get_sub_api(mpv, MPV_SUB_API_OPENGL_CB);
        video.mpvGLContext = OpaquePointer(mpvGL)
        
        mpv_command(mpv, &array2)
    }
    
    
}
