//
//  GameScene.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    //Получаємо силку на наш екземпляр класу
    let sceneManager = SceneManager.shared
    
    fileprivate var player: PlayerPlane!
    //Екземпляр
    fileprivate let hud = HUD()
    //Створимо розмір екрану
    fileprivate let screenSize = UIScreen.main.bounds.size
    
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
    
    //Метод відпрацьовується після того коли вся фізика закінчилась:
    override func didSimulatePhysics() {
        //Викликаємо метод який перевіряє позицію
        player.checkPosition()
        
        //Перебирає ноди з іменем(зробим перевірку, якщо ноди по у = менше -100 то просто будем їх видаляти):
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
                //Перевіримо чи будуть пони видалятись
//                if node.isKind(of: PowerUp.self) {
//                    print("PowerUp is removed from scene")
//                }
            }
        }
        
        //Перебирає ноди з іменем(зробим перевірку, якщо ноди по у = більше 100 поінтів то просто будем їх видаляти):
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    //MARK: вистріл
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
    
    //Початок доторкання
    func didBegin(_ contact: SKPhysicsContact) {
        //Оприділяємо катигорію
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        switch contactCategory {
        case [.enemy, .player]: print("enemy vs player")
        case [.powerUp, .player]: print("powerUp vs player")
        case [.enemy, .shot]: print("enemy vs shot")
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
