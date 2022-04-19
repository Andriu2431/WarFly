//
//  ButtonNode.swift
//  WarFly
//
//  Created by Andriy on 19.04.2022.
//

import SpriteKit

//Це буде типу кнопка(31 відео) - реалізованна вона як текст по верх картинки
class ButtonNode: SKSpriteNode {
    
    //Створюємо ярлик
    let label: SKLabelNode = {
        //Клоужер просто потрібен для того щоб потім задати якісь настройки лейблу)
        let l = SKLabelNode(text: "whatever")
        //Задамо колір шрифту
        l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
        //Шрифт
        l.fontName = "AmericanTypewriter-Bold"
        //Розмір шрифту
        l.fontSize = 30
        //Як будемо центруватись по горизонталі
        l.horizontalAlignmentMode = .center
        //Як будемо центруватись по вертикалі
        l.verticalAlignmentMode = .center
        l.zPosition = 2
        return l
    }()
    
    init(titled title: String, backgroundName: String) {
        //Створюємо текстуру, фото візьмемо те яке передамо сюди
        let texture = SKTexture(imageNamed: backgroundName)
        super.init(texture: texture, color: .clear, size: texture.size())
        //Текст буде на текстурі той, який передамо в лейбел(Всі букви будуть великі)
        label.text = title.uppercased()
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
