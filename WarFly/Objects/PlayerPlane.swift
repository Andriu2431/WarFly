//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Andriu on 04.03.2022.
//

import SpriteKit
import CoreMotion

class PlayerPlane: SKSpriteNode {

    //MARK: поворот пристрою
    //Відслідковує поворот нашого пристрою
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    //Для того щоб самольот пропадав за екраном
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    //Створимо анімацію поворота самольота
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    //оприділяє положення в якому ми летемо
    var moveDirection: TrunDirecton = .none
    //Чи почалась вже анамація
    var stillTurning = false
    //Кортеж чисел які будемо використовувати в переборі фото
    let animationSpriteStrides = [(13, 1, -1), (13, 26, 1), (13, 13, 1)]
    
    //MARK: створення самольота
    //Створюємо самольот
    static func populate(at point: CGPoint) -> PlayerPlane {
        //Виклечимо підгружений атлас
        let atlas = Assets.shared.playerPlaneAtlas
        //Створюємо текстуру:
        let pleyerPlaneTexture = atlas.textureNamed("airplane_3ver2_13") //SKTexture(imageNamed: "airplane_3ver2_13")
        //Створюємо сам самольот:
        let playerPlane = PlayerPlane(texture: pleyerPlaneTexture)
        //Зменшим наше зображення:
        playerPlane.setScale(0.5)
        //Задааємо координати:
        playerPlane.position = point
        playerPlane.zPosition = 10
        
        return playerPlane
    }
    
    //MARK: перевірка позиціх самольота
    //Перевіряє позицію
    func checkPosition() {
        //Для того щоб наш самольот переміщався:
        self.position.x += xAcceleration * 50
        
        //Щоб самольот не переміщався в боки:
        if self.position.x < -70 {
            self.position.x = screenSize.width + 70
        } else if self.position.x > screenSize.width + 70 {
            self.position.x = -70
        }
    }
    
    //MARK: політ
    //Виконує політ
    func performFly() {
        //Перше загружаємо наші текстури поворотів
//        planeAnomationFillArray()
        preloadTextureArrays()
        //Як часто повинен оновлятись аксилероматер:
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [unowned self] (data, error) in
            if let data = data {
                let acceleration = data.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
            }
        }

        //Будемо викликати метод який вибирає поворот самольота кожну секунду
        let planeWaitAction = SKAction.wait(forDuration: 1.0)
        let planeDirectionCheckAction = SKAction.run { [unowned self] in
            self.movementDirectionCheck()
        }
        let planeSequence = SKAction.sequence([planeWaitAction, planeDirectionCheckAction])
        let planeSequenceForever = SKAction.repeatForever(planeSequence)
        self.run(planeSequenceForever)
    }

    //MARK: заповнення масивів з поворотами
    //Метод який буде перебирати фото з масиву які приходять та вставляти фото по масивам з поворотом
    fileprivate func preloadTextureArrays() {
        for i in 0...2 {
            self.preloadArray(_stride: animationSpriteStrides[i]) { [unowned self] array in
                //Наш array вже має загружені фото нашого проходу циклу та якщо це перший прохід тозаписує їх в перший масив, тобто поворот ліворуч, і так далі...
                switch i {
                case 0: self.leftTextureArrayAnimation = array
                case 1: self.rightTextureArrayAnimation = array
                case 2: self.forwardTextureArrayAnimation = array
                default: break
                }
            }
        }
    }
    
    //MARK: перебираємо фото
    //Створимо метод який буде поміщяти наші фото в масиви, для того щоб робити анімацію поворота самольотика
    fileprivate func preloadArray(_stride: (Int, Int, Int), callback: @escaping (_ array: [SKTexture]) -> ()) {
        var array = [SKTexture]()
        //Перебираємо фото які приходять
        for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
            array.append(texture)
        }
        SKTexture.preload(array) {
            callback(array)
        }
    }
    
    //MARK: вибір в яку сторну перевнутий самольот
    //Оприділяє в яку сторону потрібно запустити анімацію
    fileprivate func movementDirectionCheck() {
        //якщо аксимелометр повернутий вправо
        if xAcceleration > 0.02, moveDirection != .right, stillTurning == false{
           stillTurning = true
            moveDirection = .right
            //Викликаємо метод який анімує поворот
            turnPlane(direction: .right)
            //якщо аксимелометр повернутий вліво
        } else if xAcceleration < -0.02, moveDirection != .left, stillTurning == false {
            stillTurning = true
             moveDirection = .left
            //Викликаємо метод який анімує поворот
            turnPlane(direction: .left)
            //якщо аксимелометр рівний
        } else if stillTurning == false {
            //Викликаємо метод який анімує поворот
            turnPlane(direction: .none)
        }
    }
    
    //MARK: запускає анімацію
    //Метод який буде запускати анімацію повороту
    fileprivate func turnPlane(direction: TrunDirecton) {
        //Масив в який будемо записувати текстури
        var array = [SKTexture]()
        
        //В залежності від повороту ми будемо цей масив заповнювати
        if direction == .right {
            array = rightTextureArrayAnimation
        } else if direction == .left {
            array = leftTextureArrayAnimation
        } else {
            array = forwardTextureArrayAnimation
        }
         
        //MARK: анімація повороту
        //Анамація повороту
        let forwardAction = SKAction.animate(with: array, timePerFrame: 0.05, resize: true, restore: false)
        //Анімація для того щоб він вернувся в середнє положення
        let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.05, resize: true, restore: false)
        let sequenceAction = SKAction.sequence([forwardAction, backwardAction])
        self.run(sequenceAction) { [unowned self] in //Скасовує сильну силку
            self.stillTurning = false
        }
    }
}

//Енум з поворотами
enum TrunDirecton {
    case left
    case right
    case none
}


////Створимо метод який буде поміщяти наші фото в масиви, для того щоб робити анімацію поворота самольотика
//fileprivate func planeAnomationFillArray() {
//    //Всередені метода ми будемо перебирати фото та додавати їх в один з трьох масивів
//
//    SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "PlayerPlane")]) {
//        //Робим анімацію поворота ліворуч
//        self.leftTextureArrayAnimation = {
//            //Створюємо масив
//            var array = [SKTexture]()
//            //Перебираємо фото від 13 до 1
//            for i in stride(from: 13, through: 1, by: -1) {
//                let number = String(format: "%02d", i)
//                let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
//                array.append(texture)
//            }
//            SKTexture.preload(array) {
//                print("preload is done")
//            }
//            return array
//        }()
//
//        //Робим анімацію поворота праворуч
//        self.rightTextureArrayAnimation = {
//            //Створюємо масив
//            var array = [SKTexture]()
//            //Перебираємо фото від 13 до 26
//            for i in stride(from: 13, through: 26, by: 1) {
//                let number = String(format: "%02d", i)
//                let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
//                array.append(texture)
//            }
//            SKTexture.preload(array) {
//                print("preload is done")
//            }
//            return array
//        }()
//
//        //Робим анімацію ріного самольота
//        self.forwardTextureArrayAnimation = {
//            //Створюємо масив
//            var array = [SKTexture]()
//            //Прсто беремо фото 13
//            let texture = SKTexture(imageNamed: "airplane_3ver2_13")
//            array.append(texture)
//
//            SKTexture.preload(array) {
//                print("preload is done")
//            }
//            return array
//        }()
//
//    }
//}





