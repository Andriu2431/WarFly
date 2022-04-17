//
//  BitMaskCategory.swift
//  WarFly
//
//  Created by Andriy on 17.04.2022.
//

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        set {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

//Створили бітові маски для зіткнення обєктів
struct BitMaskCategory: OptionSet {
    let rawValue: UInt32
    
    static let none    = BitMaskCategory(rawValue: 0 << 0)
    static let player  = BitMaskCategory(rawValue: 1 << 0)
    static let enemy   = BitMaskCategory(rawValue: 1 << 1)
    static let powerUp = BitMaskCategory(rawValue: 1 << 2)
    static let shot    = BitMaskCategory(rawValue: 1 << 3)
    static let all     = BitMaskCategory(rawValue: UInt32.max)
}
//Присвоїмо їх нашим компонентам


//Можемо просто записати так але тоді обєднувати не зможемо їх(в GameScene також будуть зміни тоді)
/*
//Створили бітові маски для зіткнення обєктів
struct BitMaskCategory {
    static let player: UInt32 = 0x1 << 0
    static let enemy: UInt32 = 0x1 << 1
    static let powerUp: UInt32 = 0x1 << 2
    static let shot: UInt32 = 0x1 << 3
}
//Присвоїмо їх нашим компонентам
*/
