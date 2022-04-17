//
//  YellowShot.swift
//  WarFly
//
//  Created by Ivan Akulov on 15/05/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import SpriteKit

class YellowShot: Shot {
    
    init() {
        let textureAtlas = Assets.shared.yellowShotAtlas
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
