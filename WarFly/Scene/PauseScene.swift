//
//  PauseScene.swift
//  WarFly
//
//  Created by Andriy on 19.04.2022.
//

import SpriteKit

class PauseScene: ParentScene {
    
    
    override func didMove(to view: SKView) {
        
        //MARK: Заголовок
        //Робимо заголовок(передаємо текст та фото)
        setHeader(withName: "pause", endBackground: "header_background")
        
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
    
    //MARK: update
    override func update(_ currentTime: TimeInterval) {
        //Перевіряємо, якщо сцена не на паузі то ставимо її на паузу
        if let gameScene = sceneManager.gameScene {
            if gameScene.isPaused == false {
                gameScene.isPaused = true
            }
        }
    }
    
    //MARK: touchesBegan
    //Спрацьовує при доторканні на екран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Беремо точку доторкання(first - перше доторкання, self - координати відносно цієї сцени)
        let location = touches.first!.location(in: self)
        //Получаємо нод по тій точці де натиснули
        let node = self.atPoint(location)
        
        //Перевіримо чи прийшов нод нашої кнопки
        if node.name == "restart" {
            //Перед тим видаляємо сцену з менеджера
            sceneManager.gameScene = nil
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.crossFade(withDuration: 1)
            //Створимо ту сцену на яку будемо переходити
            let gameScene = GameScene(size: self.size)
            //Як вона буде відтворюватись
            gameScene.scaleMode = .aspectFit
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene?.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "options" {
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.crossFade(withDuration: 1)
            //Розмір нової сцени буде такий який і в нашої сцени
            let optionsScene = OptionsScene(size: self.size)
            //Сцена на на яку зможемо вернутись, буде тою на якій ми натиснули на options(ця сцена)
            optionsScene.backScene = self
            //Як вона буде відтворюватись
            optionsScene.scaleMode = .aspectFit
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene!.view?.presentScene(optionsScene, transition: transition)
            
        } else if node.name == "resume" {
            
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.crossFade(withDuration: 1)
            //Робимо повернення до сцени на якій були, але через гуард бо вона опціональна
            guard let gameScene = sceneManager.gameScene else { return }
            //Як вона буде відтворюватись
            gameScene.scaleMode = .aspectFit
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
}

