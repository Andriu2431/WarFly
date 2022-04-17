//
//  PowerUp.swift
//  WarFly
//
//  Created by Andriu on 11.04.2022.
//

import SpriteKit

class PowerUp: SKSpriteNode {

    fileprivate let initialSize = CGSize(width: 52, height: 52)
    fileprivate let textureAtlas: SKTextureAtlas!
    fileprivate var textureNameBeginsWith = ""
    fileprivate var animationSpriteArray = [SKTexture]()
    
    //MARK: Ініціалізатор
    init (textureAtlas: SKTextureAtlas) {
        //То що прийде сюди присвоюємо свойству
        self.textureAtlas = textureAtlas
        //Беремо перший атлас
        let textureName = textureAtlas.textureNames.sorted()[0]
        //Фото з атласу по імені
        let texture = textureAtlas.textureNamed(textureName)
        //Від імені відкидуємо 6 останніх букв
        textureNameBeginsWith = String(textureName.dropLast(6))
        super.init(texture: texture, color: .clear, size: initialSize)
        //Змінимо маштаб
        self.setScale(0.7)
        self.name = "sprite"
        self.zPosition = 11
        
        //Створимо самольоту фізичне тіло та задамо якісь свойства:
        
        //Присвоюємо бітову маску
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        //Скажемо що ми будемо динамічні
        self.physicsBody?.isDynamic = true
        //Присвоїмо катигорію бітових масків
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp.rawValue
        //Вказуємо бітові маски катигорій з якими ми будемо доторкатись
        self.physicsBody?.collisionBitMask = BitMaskCategory.player.rawValue
        //Зарейструємо доторкання
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
    }
    
    //MARK: Реалізація руху
    //Метод який реалізує рух з верху до низу
    func startMovment() {
         performRotation()
        //Від верху до точки -100 за 5 сек
        let moveForward = SKAction.moveTo(y: -100, duration: 5)
        self.run(moveForward)
    }
    
    
    //MARK: Анімація
   //Метод який реалізує анімацію
   fileprivate func performRotation() {
        //Перебераємо наші фото та поміщаємо їх в масив
        for i in 1...15 {
            let number = String(format: "%02d", i)
            //Добавляємо в масив нове значення
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith + number.description))
        }
        //робимо загрузку текстур
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
