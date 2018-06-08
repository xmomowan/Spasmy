//
// Created by Ryan Liang on 6/8/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

enum TwiftError: Error {

    enum MPVFailure {

        case coreInitializationFailure
        case openglInitializationFailure
    }

    case mpv(reason: MPVFailure)
}
