//
//  Island.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, GameBackgroundSpriteable {
    
    //MARK: настройка островів
    //Щоб острова не плили один до другого
    static func populate(at point: CGPoint?) -> Island {
        let islandImageName = configureName()
        //Створюємо остів:
        let island = Island(imageNamed: islandImageName)
        //Викликаєм свойство рандомного острова:
        island.setScale(randomScaleFactor)
        island.position = point ?? randomPoint()
        //zPosition - величина відносно батька(тобто ми вище ніж фон):
        island.zPosition = 1
        island.name = "sprite"
        island.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        //Запускаємо екшин:
        island.run(rotateForRandomAngle())
        //Запускаєм екшин:
        island.run(move(from: island.position))
        
        return island
    }
    
    //MARK: рандомне число
    //Будем брати рандомне число для вибору острова:
   fileprivate static func configureName() -> String {
        //Створюємо рандомне число:
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        //Берем число яке випало та добавляємо назву фоток:
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    //MARK: рандомний маштаб
    //Рандомний маштаб острова:
    fileprivate static var randomScaleFactor: CGFloat {
        //Створюємо рандомне число:
        let distribution = GKRandomDistribution(lowestValue: 3, highestValue: 10)
        //Згенероване число ділимо на 10
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    //MARK: поворот острова
    //Функція яка буде повертати островом:
    fileprivate static func rotateForRandomAngle() -> SKAction {
        //Створюємо рандомне число:
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        //Згенероване число переводим в CGFloat:
        let randomNumber = CGFloat(distribution.nextInt())
        
        //Як буде повертатись наш острів(в радіанах):
        return SKAction.rotate(toAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
    }
    
    //MARK: рух островів по руху самольота
    //Будемо реалізовувати рух островів по руху самольота:
    fileprivate static func move(from point: CGPoint) -> SKAction {
        //Точка в яку буде рух:
        let movePoint = CGPoint(x: point.x, y: -200)
        //Шукаємо дистанцію:
        let moveDostance = point.y + 200
        //Початкова швидкість:
        let movementSpeed: CGFloat = 100.0
        //Шукаємо час:
        let duration = moveDostance / movementSpeed
        
        return SKAction.move(to: movePoint, duration: duration)
    }
}
