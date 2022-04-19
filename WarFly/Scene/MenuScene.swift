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
        
        //Зробимо так щоб атласи загружались лише один раз при запуску, а не кожного разу коли відкриваємо меню
        if !Assets.shared.isLoaded {
            //Підгружаємо всі атласи - якщо не було б цієї сцени то підгружали б в AppDelegate
            Assets.shared.preloadAssets()
            //Змінимо на true, для того щоб ми більше сюди не попали
            Assets.shared.isLoaded = true
        }
        
        //MARK: Заголовок
        //Колір сцени
        self.backgroundColor = SKColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
        //Фото1
        let heder = SKSpriteNode(imageNamed: "header1")
        //Розміщення кнопки(середина по х, середина по у + 150)
        heder.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(heder)
        
        //MARK: 3 Кнопки
        //Створимо масив titles
        let titles = ["play", "options", "best"]
        
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
    //Спрацьовує при доторканні на екран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Беремо точку доторкання(first - перше доторкання, self - координати відносно цієї сцени)
        let location = touches.first!.location(in: self)
        //Получаємо нод по тій точці де натиснули
        let node = self.atPoint(location)
        
        //Перевіримо чи прийшов нод нашої кнопки
        if node.name == "play" {
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
