//
//  BluePowerUp.swift
//  WarFly
//
//  Created by Ivan Akulov on 13/05/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import SpriteKit

class BluePowerUp: PowerUp {
    
    init() {
        let textureAtlas = Assets.shared.bluePowerUpAtlas
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
