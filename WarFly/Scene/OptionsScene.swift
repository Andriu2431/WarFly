//
//  OptionsScene.swift
//  WarFly
//
//  Created by Andriy on 21.04.2022.
//

import SpriteKit

//Кнопка налаштування
class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!

    override func didMove(to view: SKView) {
        
        //Підгрузимо дані сюди з GameSettings
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        //MARK: Заголовок
        //Робимо заголовок(передаємо текст та фото)
        setHeader(withName: "options", endBackground: "header_background")
        
        //Будемо міняти фон взалежності від того чи буде музика чи ні
        let backgroundNameForMusic = isMusic == true ? "music" : "nomusic"
        let backgroundNameForSound = isSound == true ? "sound" : "nosound"
        
        //MARK: кнопки
        createButton(titled: nil, backgroundName: backgroundNameForMusic, x: self.frame.midX - 50, y: self.frame.midY, name: "music")
        createButton(titled: nil, backgroundName: backgroundNameForSound, x: self.frame.midX + 50, y: self.frame.midY, name: "sound")
        createButton(titled: "back", backgroundName: "button_background", x: self.frame.midX, y: self.frame.midY - 100, name: "back")
    }
    
    //Метод який свторює кнопки
    func createButton(titled: String?, backgroundName: String, x: CGFloat, y: CGFloat, name: String) {
        
        //Фото(кнопка) - titled(це текст кнопки), backgroundName - це фон.
        let button = ButtonNode(titled: titled, backgroundName: backgroundName)
        //Позиція
        button.position = CGPoint(x: x, y: y)
        //Для позначаня її
        button.name = name
        //Ховаємо лейбел
        button.label.name = titled
        addChild(button)
    }
    
    //MARK: touchesBegan
    //Спрацьовує при доторканні на екран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Беремо точку доторкання(first - перше доторкання, self - координати відносно цієї сцени)
        let location = touches.first!.location(in: self)
        //Получаємо нод по тій точці де натиснули
        let node = self.atPoint(location)
        
        //Перевіримо чи прийшов нод нашої кнопки
        if node.name == "music" {
            //Будемо міняти з true na false
            isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
        } else if node.name == "sound" {
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)
        } else if node.name == "back"{
            //Збережимо наші дані при виході
            gameSettings.isSound = isSound
            gameSettings.isMusic = isMusic
            gameSettings.saveGameSettings()
            
            //Якщо так то робимо перехід до іншої сцени
            let transition = SKTransition.crossFade(withDuration: 1)
            guard let backScene = backScene else { return }
            //Як вона буде відтворюватись
            backScene.scaleMode = .aspectFit
            //Створюємо сам перехід, в GameViewController запустимо цю сцену першою
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
    
    //Метод який буде міняти текстуру кнопки
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            //Якщо property що передамо буде true тоді буде включений звук, якщо false тоді виключиний
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
        }
    }
}

//Це було замість метода createButton, в didMove:

//        //Фото(кнопка) - titled(це текст кнопки), backgroundName - це фон.
//        let music = ButtonNode(titled: nil, backgroundName: "music")
//        //Позиція
//        music.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
//        //Для позначаня її
//        music.name = "music"
//        //Ховаємо лейбел
//        music.label.isHidden = true
//        addChild(music)
//
//        let sound = ButtonNode(titled: nil, backgroundName: "sound")
//        sound.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY)
//        sound.name = "sound"
//        sound.label.isHidden = true
//        addChild(sound)
//
//        let back = ButtonNode(titled: "back", backgroundName: "button_background")
//        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
//        back.name = "back"
//        back.label.name = "back"
//        addChild(back)
