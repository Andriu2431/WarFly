//
//  Cloud.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//

import SpriteKit
import GameplayKit

final class Cloud: SKSpriteNode, GameBackgroundSpriteable {
    
    //MARK: створення хмари рандомного розміру
   //Цей метод викличемо в GameScene та там ініціалізуємо його:
    static func populate(at point: CGPoint?) -> Cloud {
       let cloudImageName = configureName()
       //Створюємо хмару:
       let cloud = Cloud(imageNamed: cloudImageName)
       //Викликаєм свойство рандомної хмари:
       cloud.setScale(randomScaleFactor)
       cloud.position = point ?? randomPoint()
       //zPosition - величина відносно батька(тобто ми вище ніж фон):
       //Тут ми зробили так щоб одні йшли під самольотом а другі над:
       let randomCloud = GKRandomDistribution(lowestValue: 18, highestValue: 21)
       let randomCloudCGFloat = CGFloat(randomCloud.nextInt())
       cloud.zPosition = randomCloudCGFloat
       cloud.name = "sprite"
       cloud.anchorPoint = CGPoint(x: 0.5, y: 1.0)
       //Запускаєм екшин:
       cloud.run(move(from: cloud.position))
       
       return cloud
   }
    
    //MARK: рандомне число
   //Будем брати рандомне число для вибору хмари:
    fileprivate static func configureName() -> String {
       //Створюємо рандомне число:
       let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
       let randomNumber = distribution.nextInt()
       //Берем число яке випало та добавляємо назву фоток:
       let imageName = "cl" + "\(randomNumber)"
       
       return imageName
   }
    
    //MARK: рандомний маштаб
   //Рандомний маштаб хмари:
    fileprivate static var randomScaleFactor: CGFloat {
       //Створюємо рандомне число:
       let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
       //Згенероване число ділимо на 10
       let randomNumber = CGFloat(distribution.nextInt()) / 10
       
       return randomNumber
   }
    
    //MARK: рух хмар
    //Будемо реалізовувати рух хмар по руху самольота:
    fileprivate static func move(from point: CGPoint) -> SKAction {
        //Точка в яку буде рух:
        let movePoint = CGPoint(x: point.x, y: -200)
        //Шукаємо дистанцію:
        let moveDostance = point.y + 200
        //Початкова швидкість:
        let movementSpeed: CGFloat = 150.0
        //Шукаємо час:
        let duration = moveDostance / movementSpeed
        
        return SKAction.move(to: movePoint, duration: duration)
    }
}
