//
//  ParentScene.swift
//  WarFly
//
//  Created by Andriy on 21.04.2022.
//

import SpriteKit

//Батьківський клас, просто для того щоб не повторювався код
class ParentScene: SKScene {

    //Получаємо силку на наш екземпляр класу
    let sceneManager = SceneManager.shared
    //Попередня сцена
    var backScene: SKScene?
    
    //Напишемо метод який буде робити заголовок
    func setHeader(withName name: String?, endBackground backgroundName: String) {
        //Заголовок
        let header = ButtonNode(titled: name, backgroundName: backgroundName)
        //Розміщення заголовка(середина по х, середина по у + 150)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(header)
    }
    
    //Передамо в ініціалізатор колір сцени
    override init(size: CGSize) {
        super.init(size: size)
        //Задаємо колір сцени
        backgroundColor = SKColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
