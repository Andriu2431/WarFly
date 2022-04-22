//
//  BestScene.swift
//  WarFly
//
//  Created by Andriy on 21.04.2022.
//

import SpriteKit

class BestScene: ParentScene {

    //Вказуємо самі найкращі результати
    var places: [Int]!
    
    override func didMove(to view: SKView) {
        
        //Підгружаємо дані з GameSettings
        gameSettings.loadScores()
        //Передаємо їх в масив
        places = gameSettings.highscore
        
        //MARK: Заголовок
        //Робимо заголовок(передаємо текст та фото)
        setHeader(withName: "best", endBackground: "header_background")
        
        //MARK: 3 Кнопки
        //Створимо масив titles
        let titles = ["back"]
        
        for(index, title) in titles.enumerated() {
            //Фото(кнопка) - titled(це текст кнопки), backgroundName - це фон.
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            //Позиція
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200 + CGFloat(100 * index))
            //Для позначаня її
            button.name = title
            //Імя ярлика всередині кнопки
            button.label.name = title
            addChild(button)
        }
        
        
        for (index, value) in places.enumerated() {
            
            let l = SKLabelNode(text: value.description)
            //Задамо колір шрифту
            l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
            //Шрифт
            l.fontName = "AmericanTypewriter-Bold"
            //Розмір шрифту
            l.fontSize = 30
            //Розташування
            l.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 60))
            addChild(l)
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
        if node.name == "back" {
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.crossFade(withDuration: 1)
            guard let backScene = backScene else { return }
            //Як вона буде відтворюватись
            backScene.scaleMode = .aspectFit
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
}
