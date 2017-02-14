//
//  ShakeDebug.swift
//  RxThings
//
//  Created by silly on 14/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import UIKit
import FLEX

extension UIViewController {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == UIEventSubtype.motionShake && FLEXManager.shared().isHidden {
            FLEXManager.shared().showExplorer()
        }
    }
}
