//
//  SceneManager.swift
//  WarFly
//
//  Created by Andriy on 20.04.2022.
//

//Для того щоб можна було після паузи продовжити ігру - передамо сюди сцену а потім візьмене її після паузи
class SceneManager {
    static let shared = SceneManager()
    
    var gameScene: GameScene?
}
