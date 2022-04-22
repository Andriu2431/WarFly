//
//  GameScene.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene {
    
    fileprivate var player: PlayerPlane!
    //Екземпляр
    fileprivate let hud = HUD()
    //Створимо розмір екрану
    fileprivate let screenSize = UIScreen.main.bounds.size
    
    //Життя ігрока
    fileprivate var lives = 3 {
        didSet {
            //Коли буде мінятись свойство то зробимо конструкцію switch
            switch lives {
                //Буде 3 зірки відображатись
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
                //2
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
                //1
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
                
            default: break
            }
        }
    }
    
    //MARK: при запуску апп
    override func didMove(to view: SKView) {
        //Знімаємо паузу всіх обєктів
        self.scene?.isPaused = false
        
        //Робимо перевірку чи ця сцена вже створена
        guard sceneManager.gameScene == nil else { return }
        
        //Зберігаємо нашу сцену в SceneManager
        sceneManager.gameScene = self
        
        //Протокол який рейструє доторкання, реалізуємо в розширенні
        physicsWorld.contactDelegate = self
        //Силу гравітації прирівнюємо до нуля
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnClouds()
        spawnIslands()
        //Викликаєм метод який відповідає за польот
        player.performFly()
        
        spawnPowerUp()
        //spawnEnemy(count: 5)
        spawnEnemys()
        createHUD()
    }
    
    //MARK: метод для UI
    fileprivate func createHUD() {
        //Добавимо на сцену
        addChild(hud)
        //В екземпляр передамо розмір екрану
        hud.configureUI(screenSize: screenSize)
    }
    
    //MARK: спавнимо крутилку в центрі
    fileprivate func spawnPowerUp() {
        //Запускаємо блок коду
        let spawnAction = SKAction.run {
            //Створимо рандомне число
            let randomNumber = Int(arc4random_uniform(2))
            //Якщо наш randomNumber == 1 тоді буде BluePowerUp якщо 0 тоді GreenPowerUp
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            //Оприділяємо рандомну позицію по осі x
            let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
            
            //Де буде створюватись наш powerUp
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovment()
            
            self.addChild(powerUp)
        }
        //Час на спавн буде рандомний
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        //Задамо час через який вони будуть спавнитись
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        
        //Запускаємо послідовність з цих 2 дій
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
        
    }
    
    //MARK: спавнимо ворогів кожні 3 секунти
    //Зррбимо щоб наші вороги спавниличь кожні 3 секунди
    fileprivate func spawnEnemys() {
        //Заставимо очікувати
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnSpiralOfEnemis()
        }
        //Запускаємо їх
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    //MARK: спавнимо ворогів, кількість
    fileprivate func spawnSpiralOfEnemis() {
        //Загружаємо атлас1 картинок ворогів
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas //SKTextureAtlas(named: "Enemy_1")
        //Загружаємо атлас2 картинок ворогів
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas //SKTextureAtlas(named: "Enemy_2")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            //Беремо рандомне число
            let randomNumber = Int(arc4random_uniform(2))
            //Створюємо масив атласів
            let arrayOfAtlass = [enemyTextureAtlas1, enemyTextureAtlas2]
            //Скажемо щоб з масиву атлсів бралось значення по індексу яке прийде з рандомного числа
            let textureAtlas = arrayOfAtlass[randomNumber]
            
            //Час який буде чекати самольот для спавну
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run { [unowned self] in
                //Спочатку відсортируємо масив
                let textureNames = textureAtlas.textureNames.sorted()
                //Створюємо текстуру по числу з папки з фото
                let texture = textureAtlas.textureNamed(textureNames[12])
                //Створюємо вогора
                let enemy = Enemy(enemyTexture: texture)
                //його координати
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
                //Добавляємо на сцену
                self.addChild(enemy)
                enemy.flySpiral()
            }
            
            //Створюємо послідовність
            let spawnAction = SKAction.sequence([waitAction, spawnEnemy])
            //Скільки раз повторити його
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
    }
    
    //MARK: генеруємо хмари
    //Метод який позволяє генерувати хмари:
    fileprivate func spawnClouds() {
        //Кожну секунду буде генеруватись хмара:
        let spawnCloudWait = SKAction.wait(forDuration: 1)
        //В середині коду буде створюватись хмара:
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        //Говоримо що це буде безкінечно:
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
        
    }
    
    //MARK: генеруємо острови
    //Метод який позволяє генерувати острови:
    fileprivate func spawnIslands() {
        //Кожні 2 сек буде генеруватись острів:
        let spawnIslandsWait = SKAction.wait(forDuration: 2)
        //В середині коду буде створюватись хмара:
        let spawnIslandsAction = SKAction.run {
            let islands = Island.populate(at: nil)
            self.addChild(islands)
        }
        //Говоримо що це буде безкінечно:
        let spawnCloudSequence = SKAction.sequence([spawnIslandsWait, spawnIslandsAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
        
    }
    
    //MARK: настройка фону
    fileprivate func configureStartScene() {
        
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        //Викликаємо функцію яку створили та ініціалізуємо її:
        let backgroung = Background.populateBackground(at: screenCenterPoint)
        //Добавляємо беграунд нам на екран:
        self.addChild(backgroung)
        
        //Оприділимо розмір нашого ерану:
        let screen = UIScreen.main.bounds
        
        //Створюємо остров1:
        let island1 = Island.populate(at: CGPoint(x: 100, y: 200))
        self.addChild(island1)
        
        //Створюємо остров2:
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
        self.addChild(island2)
        
        
        //Де будемо розміщати самольот:
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
        self.addChild(player)
    }
    
    //MARK: Видаляє ноди
    //Метод відпрацьовується після того коли вся фізика закінчилась:
    override func didSimulatePhysics() {
        //Викликаємо метод який перевіряє позицію
        player.checkPosition()
        
        //Перебирає ноди з іменем(зробим перевірку, якщо ноди по у = менше -50 то просто будем їх видаляти):
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -50 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= -50 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
            if node.position.y <= -50 {
                node.removeFromParent()
            }
        }
        
        //Перебирає ноди з іменем(зробим перевірку, якщо ноди по у = більше 100 поінтів то просто будем їх видаляти):
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    //MARK: Вистріл
    //Метод який буде створювати вистріл
    fileprivate func playerFire() {
        let shot = YellowShot()
        //Вистріл співпадатиме з позицією ігрока
        shot.position = self.player.position
        shot.startMovment()
        self.addChild(shot)
    }
    
    //MARK: touchesBegan
    //Спрацьовує при доторканні на екран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Беремо точку доторкання(first - перше доторкання, self - координати відносно цієї сцени)
        let location = touches.first!.location(in: self)
        //Получаємо нод по тій точці де натиснули
        let node = self.atPoint(location)
        
        //Перевіримо чи прийшов нод нашої кнопки
        if node.name == "pause" {
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.doorway(withDuration: 1.0)
            //Створимо ту сцену на яку будемо переходити
            let pauseScene = PauseScene(size: self.size)
            //Як вона буде відтворюватись
            pauseScene.scaleMode = .aspectFit
            //Зберігаємо стан нашої сцени в менеджер, для того щоб потім викликати цю сцену
            sceneManager.gameScene = self
            //Ставимо на паузу всю сцену
            self.scene?.isPaused = true
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene?.view?.presentScene(pauseScene, transition: transition)
        } else {
            //При доторканні до екрану викликаємо вистріл
            playerFire()
        }
    }
}

//MARK: Розширення для дотиків
//SKPhysicsContactDelegate - рейструє доторкання
extension GameScene: SKPhysicsContactDelegate {
    
    //MARK: didBegin
    //Початок доторкання
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Створюємо взрив
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        //Шукаємо точку доторку, пулі та ворога, або ми та ворог
        let contectPoint = contact.contactPoint
        //Взрив створюємо в точці доторку
        explosion?.position = contectPoint
        explosion?.zPosition = 12
        //Чекаємо 1 сек
        let waitForExplosionAction = SKAction.wait(forDuration: 1.0)
        
        //Оприділяємо катигорію
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
            
        case [.enemy, .player]:

            //Зробимо так щоб при доторканні до нас, вороги пропадали. Шукаємо ворога, під яким body він буде
            if contact.bodyA.node?.name == "sprite" {
                
                //Якщо батько ще не == nil то заходимо в цикл
                if contact.bodyA.node?.parent != nil {
                    //Якщо це ворог то видаляємо його з екрану
                    contact.bodyA.node?.removeFromParent()
                    //Зменшуємо життя на 1
                    lives -= 1
                }
            } else {
                if contact.bodyB.node?.parent != nil {
                    contact.bodyB.node?.removeFromParent()
                    lives -= 1
                }
            }
            
            //Добавляємо взрив коли буде торкання
            addChild(explosion!)
            //Робимо затримку та видаляємо explosion
            self.run(waitForExplosionAction) {
                //Видаляємо наш explosion
                explosion?.removeFromParent()
            }
            
            //Якщо життя буде дорівнювати 0, то буде нова сцена
            if lives == 0 {
                //Створимо екземпляр класу
                let gameOverScene = GameOverScene(size: self.size)
                //Як вона буде відтворюватись
                gameOverScene.scaleMode = .aspectFit
                //Створимо перехід
                let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
                //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
                self.scene!.view?.presentScene(gameOverScene, transition: transition)
            }
            
        case [.powerUp, .player]:
            
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives = 3
                    player.greenPoweUp()
                } else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives = 3
                    player.greenPoweUp()
                }
                
                if contact.bodyA.node?.name == "bluePowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives += 1
                    player.bluePoweUp()
                } else if contact.bodyB.node?.name == "bluePowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives += 1
                    player.bluePoweUp()
                }
            }
                      
        case [.enemy, .shot]:
            
            //Якщо батько ще не == nil то заходимо в цикл
            if contact.bodyA.node?.parent != nil {
                //Якщо попадаємо по ворогові то пуля та ворог пропадають
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                //Додаємо до очків 5
                hud.score += 5
                
                //Добавляємо взрив коли буде торкання
                addChild(explosion!)
                //Робимо затримку та видаляємо explosion
                self.run(waitForExplosionAction) {
                    //Видаляємо наш explosion
                    explosion?.removeFromParent()
                }
            }
            
        default: preconditionFailure("Unable to detect collision category")
        }
    }
    
    //Кінець доторкання
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}



//anchorPoint - початкові координати
//OperationQueue.current! - це про багатопоточність

/* ось ці зміни з масками в методі didBegin
 //Перевіряємо які бітові маски доторкаються
 let bodyA = contact.bodyA.categoryBitMask
 let bodyB = contact.bodyB.categoryBitMask
 let player = BitMaskCategory.player
 let enemy = BitMaskCategory.enemy
 let shot = BitMaskCategory.shot
 let powerUp = BitMaskCategory.powerUp
 
 //Перевіримо що доторкається
 if bodyA == player && bodyB == enemy || bodyB == player && bodyA == enemy {
 print("enemy vs player")
 }else if bodyA == player && bodyB == powerUp || bodyB == player && bodyA == powerUp {
 print("powerUp vs player")
 }else if bodyA == shot && bodyB == enemy || bodyB == shot && bodyA == enemy {
 print("enemy vs shot")
 }*/
