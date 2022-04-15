//
//  GameBackgroundSpritable + Extension.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//

import SpriteKit
import GameplayKit

//Підпишемо цей протокол під наш клас:
protocol GameBackgroundSpriteable {
    static func populate(at point: CGPoint?) -> Self
    static func randomPoint() -> CGPoint
}
//Пишемо розширення для протоколу для того щоб наші острова та хмари створювались за нашим екраном:
extension GameBackgroundSpriteable {
    static func randomPoint() -> CGPoint {
        //Дізнаємось розмір екрану:
        let screen = UIScreen.main.bounds
        //Рандомно за розмірами екрану будемо генерувати(від 100 до 200 поінтів вище екрану):
        let destributton = GKRandomDistribution(lowestValue: Int(screen.size.height) + 400,
                                                highestValue: Int(screen.size.height) + 500)
        let y = CGFloat(destributton.nextInt())
        //Від нуля до ширини екрану по горизонталі:
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        return CGPoint(x: x, y: y)
    }
}
