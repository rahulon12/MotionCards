//
//  MotionManager.swift
//  MotionCards
//
//  Created by Rahul on 1/25/24.
//

import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    var pitch = 0.0
    var roll = 0.0
    var yaw = 0.0
    var handler: (Double, Double, Double) -> () = { _, _, _ in }
    
    init() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
            self.yaw = motion.attitude.yaw
            
            handler(self.pitch, self.roll, self.yaw)
            
            print("pitch: \(self.pitch), roll: \(self.roll), yaw: \(self.yaw)")
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
