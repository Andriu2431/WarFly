//
//  Background.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//
import SpriteKit

class Background: SKSpriteNode {

    //Цей метод викличемо в GameScene та там ініціалізуємо його:
    static func populateBackground(at point: CGPoint) -> Background {
        //Задаємо background фон:
        let background = Background(imageNamed: "background")
        //розмір фону
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //Де він буде знаходитись:
        background.position = point
        //Це для того щоб нижній обєкт не був зверху:
        background.zPosition = 0
        
        return background
    }
}
