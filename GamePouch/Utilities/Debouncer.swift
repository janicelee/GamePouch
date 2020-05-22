//
//  Debouncer.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-05-20.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

func debounce(interval: Int, action: @escaping (() -> Void)) -> () -> Void {
    var lastFireTime = DispatchTime.now()
    let dispatchDelay = DispatchTimeInterval.milliseconds(interval)
    
    return {
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now = DispatchTime.now()
            
            if now.rawValue >= when.rawValue {
                action()
            }
        }
    }
}
