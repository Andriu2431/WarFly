//
//  PauseScene.swift
//  WarFly
//
//  Created by Andriy on 19.04.2022.
//

import SpriteKit

class PauseScene: SKScene {

    override func didMove(to view: SKView) {
        
        //MARK: Заголовок
        //Колір сцени
        self.backgroundColor = SKColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
        //Кнопка
        let heder = ButtonNode(titled: "pause", backgroundName: "header_background")
        //Розміщення кнопки(середина по х, середина по у + 150)
        heder.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(heder)
        
        //MARK: 3 Кнопки
        //Створимо масив titles
        let titles = ["restart", "options", "resume"]
        
        for(index, title) in titles.enumerated() {
            //Фото(кнопка) - titled(це текст кнопки), backgroundName - це фон.
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            //Позиція
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            //Для позначаня її
            button.name = title
            //Імя ярлика всередині кнопки
            button.label.name = title
            addChild(button)
        }
        
    }
    
    //MARK: touchesBegan
    //    Спрацьовує при доторканні на екран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Беремо точку доторкання(first - перше доторкання, self - координати відносно цієї сцени)
        let location = touches.first!.location(in: self)
        //Получаємо нод по тій точці де натиснули
        let node = self.atPoint(location)
        
        //Перевіримо чи прийшов нод нашої кнопки
        if node.name == "restart" {
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

