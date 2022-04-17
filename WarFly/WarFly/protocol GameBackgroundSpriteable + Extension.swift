//
//  protocol GameBackgroundSpriteable + Extension.swift
//  WarFly
//
//  Created by Ivan Akulov on 27/04/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import SpriteKit
import GameplayKit


protocol GameBackgroundSpriteable {
    static func populate(at point: CGPoint?) -> Self
    static func randomPoint() -> CGPoint
}

extension GameBackgroundSpriteable {
    static func randomPoint() -> CGPoint {
        let screen = UIScreen.main.bounds
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 400, highestValue: Int(screen.size.height) + 500)
        let y = CGFloat(distribution.nextInt())
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        return CGPoint(x: x, y: y)
    }
}
