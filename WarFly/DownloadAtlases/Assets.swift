//
//  Assets.swift
//  WarFly
//
//  Created by Andriy on 16.04.2022.
//

import UIKit
import SpriteKit

//Тут будемо загружати наші атласи, та роздавати їх
class Assets {

    static let shared = Assets()
    var isLoaded = false
    let yellowAmmoAtlas = SKTextureAtlas(named: "YellowAmmo")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    
    //Функція яка буде підгружати атласи, викличимо її в AppDelegate
    func preloadAssets() {
        yellowAmmoAtlas.preload { print("yellowAmmoAtlas preload") }
        enemy_2Atlas.preload { print("enemy_2Atlas preload") }
        enemy_1Atlas.preload { print("enemy_1Atlas preload") }
        bluePowerUpAtlas.preload { print("bluePowerUpAtlas preload") }
        greenPowerUpAtlas.preload { print("greenPowerUpAtlas preload") }
        playerPlaneAtlas.preload { print("playerPlaneAtlas preload") }
    }
}
