//
//  Shot.swift
//  WarFly
//
//  Created by Andriy on 16.04.2022.
//

import SpriteKit

class Shot: SKSpriteNode {
    //Розмір екрану
    let screanSize = UIScreen.main.bounds

    //Розмір картинки 
    fileprivate let initialSize = CGSize(width: 187, height: 237)
    fileprivate let textureAtlas: SKTextureAtlas!
    fileprivate var textureNameBeginsWith = ""
    fileprivate var animationSpriteArray = [SKTexture]()
    
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
        self.setScale(0.3)
        self.name = "shotSprite"
        self.zPosition = 7
    }
    
    //Метод який реалізує рух з верху до низу
    func startMovment() {
         performRotation()
        //На 100 поінтів вище екрану
        let moveForward = SKAction.moveTo(y: screanSize.height + 100, duration: 2)
        self.run(moveForward)
    }
    
    
    //Метод який реалізує анімацію
   fileprivate func performRotation() {
        //Перебераємо наші фото та поміщаємо їх в масив
        for i in 1...32 {
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

