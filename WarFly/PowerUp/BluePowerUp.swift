//
//  BluePowerUp.swift
//  WarFly
//
//  Created by Andriu on 13.04.2022.
//

import SpriteKit

class BluePowerUp: PowerUp {
    init() {
        //Створили атлас
        let textureAtlas = SKTextureAtlas(named: "BluePowerUp")
        //Передали його в ініціалізатор батька
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
