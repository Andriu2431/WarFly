//
//  Enemy.swift
//  WarFly
//
//  Created by Andriu on 11.04.2022.
//

import SpriteKit

class Enemy: SKSpriteNode {

    static var textureAtlas: SKTextureAtlas?
    var enemyTexture: SKTexture!
    
    //MARK: Ініціалізатор
    init(enemyTexture: SKTexture) {
        let texture = enemyTexture
        super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 224))
        //Міняємо маштаб
        self.xScale = 0.4
        self.yScale = -0.4
        self.zPosition = 9
        self.name = "sprite"
        
        //Створимо самольоту фізичне тіло та задамо якісь свойства:
        
        //Присвоюємо бітову маску
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        //Скажемо що ми будемо динамічні
        self.physicsBody?.isDynamic = true
        //Присвоїмо катигорію бітових масків
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemy.rawValue
        //Вказуємо бітові маски, та говоримо щоб дій не було ніяких а лише рейстрація доторкання
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        //Зарейструємо доторкання
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
    }
    
    //MARK: політ по спіралі
    //Метод який позволить літати по спіралі
    func flySpiral() {
        
        //Час за який буде пролітати всю ширену екрану
        let timeHorizontal: Double = 3
        let timeVertical: Double = 5
        
        //Наш самольот буде литіти не долітаючи 50 поентів до х та за 3 секунди пролітати еран
        let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
        //Зробимо дію яка буде призуминятись в кінці та швидко рухатись на початку
        moveLeft.timingMode = .easeInEaseOut
        //Проворуч
        let moveRight = SKAction.moveTo(x: UIScreen.main.bounds.width - 50, duration: timeHorizontal)
        //Зробимо дію яка буде призуминятись в кінці та швидко рухатись на початку
        moveRight.timingMode = .easeInEaseOut
        
        //Рандомне чило буде йти в енум
        let randomNumber = Int(arc4random_uniform(2))
        //Через тернарний оператор виберимо куда буде литіти самольот
        //це працює так - якщо randomNumber буде true(рандомне число прийде 0, та в енумі вибере left) тоді виконується перша умова якщо ні тоді друга
        let asideMovementSequense = randomNumber == EnemyDirection.left.rawValue ? SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([moveRight, moveLeft])
        //Скажемо щоб ця послідовність виконувалась безкінечно
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequense)
        //Створюємо рух в низ
        let forwardMovement = SKAction.moveTo(y: -105, duration: timeVertical)
        //Створюємо рух в низ та в бік
        let groupMovement = SKAction.group([foreverAsideMovement, forwardMovement])
        //Запускаємо їх
        self.run(groupMovement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//Для того щоб рандомно вибирати в яку сторону будуть литіти самольоти
enum EnemyDirection: Int {
    case left = 0
    case right
}
