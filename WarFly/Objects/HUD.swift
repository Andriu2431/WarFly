//
//  HUD.swift
//  WarFly
//
//  Created by Andriy on 19.04.2022.
//

import SpriteKit

//Тут буде UI
class HUD: SKNode {

    //Створимо всі елементи для UI
    let scoreBackground = SKSpriteNode(imageNamed: "scores")
    let scoreLabel = SKLabelNode(text: "0")
    var score: Int = 0 {
        //Як тільки ця властивість буде мінятись виконається код в наглядачі
        didSet {
            //Ми беремо текст scoreLabel, та в нього поміщаємо значення score в текстовому форматі
            scoreLabel.text = score.description
        }
    }
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let life1 = SKSpriteNode(imageNamed: "life")
    let life2 = SKSpriteNode(imageNamed: "life")
    let life3 = SKSpriteNode(imageNamed: "life")
    
    //MARK: UI
    //Настройка юай, в метод передамо розмір нашого дисплею
    func configureUI(screenSize: CGSize) {
        
        //Задамо де буде появлятись scoreBackground
        scoreBackground.position = CGPoint(x: scoreBackground.size.width - 50, y: screenSize.height - scoreBackground.size.height / 2 - 16)
        //Точка привязки
        scoreBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        //Задаємо zPosition
        scoreBackground.zPosition = 99
        //Змінемо маштаб
        scoreBackground.setScale(0.7)
        addChild(scoreBackground)
        
        //Налаштуємо сам ярлик - він повинен знаходитись всередині scoreBackground
        //Вирівнюємось по правій частині нашого батька
        scoreLabel.horizontalAlignmentMode = .right
        //По вертикалі - в центрі
        scoreLabel.verticalAlignmentMode = .center
        //Позиція тексту
        scoreLabel.position = CGPoint(x: -10, y: 3)
        scoreLabel.zPosition = 100
        //Задаємо шрифт ярлику
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        //Розмір шрифта
        scoreLabel.fontSize = 30
        //На scoreBackground додаємо scoreLabel
        scoreBackground.addChild(scoreLabel)
        
        //Настройки кнопки меню
        //Розташування кнопки
        menuButton.position = CGPoint(x: 20, y: 20)
        //Розташування точки привязки
        menuButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        menuButton.zPosition = 100
        menuButton.name = "pause"
        addChild(menuButton)
        
        //Добавляємо зірочки(життя) на екран
        let lifes = [life1, life2, life3]
        //enumerated() - Вертає елемент масива та його індекс
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: screenSize.width - CGFloat(index + 1) * (life.size.width + 3), y: 20)
            life.zPosition = 100
            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(life)
        }
    }
}
