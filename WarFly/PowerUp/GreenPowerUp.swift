//
//  GreenPowerUp.swift
//  WarFly
//
//  Created by Andriu on 13.04.2022.
//

import SpriteKit

class GreenPowerUp: PowerUp {
    init() {
        //Створили атлас
        let textureAtlas = Assets.shared.greenPowerUpAtlas //SKTextureAtlas(named: "GreenPowerUp")
        //Передали його в ініціалізатор батька
        super.init(textureAtlas: textureAtlas)
        name = "greenPowerUp"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

