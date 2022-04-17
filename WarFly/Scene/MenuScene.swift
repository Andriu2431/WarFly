//
//  MenuScene.swift
//  WarFly
//
//  Created by Andriy on 17.04.2022.
//

import SpriteKit

//Типу меню перед запуском ігри, в GameViewController запустимо цю сцену першою
class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        //Колір сцени
        self.backgroundColor = SKColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
        //Фото кнопки
        let texture = SKTexture(imageNamed: "play")
//      Кнопка, при нажиманні якої ігра буде запускатись
        let button = SKSpriteNode(texture: texture)
        //Розміщення кнопки(середина по х, середина по у)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        button.name = "runButton"
        self.addChild(button)
    }
    
//    Спрацьовує при доторканні на екран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Беремо точку доторкання(first - перше доторкання, self - координати відносно цієї сцени)
        let location = touches.first!.location(in: self)
        //Получаємо нод по тій точці де натиснули
        let node = self.atPoint(location)
        
        //Перевіримо чи прийшов нед нашої кнопки
        if node.name == "runButton" {
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.crossFade(withDuration: 1)
            //Створимо ту сцену на яку будемо переходити
            let gameScene = GameScene(size: self.size)
            //Як вона буде відтворюватись
            gameScene.scaleMode = .aspectFit
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene?.view?.presentScene(gameScene, transition: transition)
        }
    }
}
