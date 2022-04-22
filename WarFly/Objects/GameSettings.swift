//
//  GameSettings.swift
//  WarFly
//
//  Created by Andriy on 22.04.2022.
//

import UIKit

class GameSettings: NSObject {
    //Тут будемо працювати з UserDefaults, для збереження малих данних
    
    let ud = UserDefaults.standard

    var isMusic = true
    var isSound = true
    
    //ключі
    let musicKey = "music"
    let soundKey = "sound"
    
    //Збереження кращих результатів
    var highscore: [Int] = []
    var currentScore = 0
    let highscoreKey = "highscore"
    
    override init() {
        super.init()
        loadGameSettings()
        loadScores()
    }
    
    //Зберігає данні
    func saveScores() {
        //Добавляємо в масив очки, піля сцени gameOver
        highscore.append(currentScore)
        //Відсортуємо. Але зробимо так щоб було не більше 3 значень
        highscore = Array(highscore.sorted { $0 > $1 }.prefix(3))
        //Зберігаємо його
        ud.set(highscore, forKey: highscoreKey)
        ud.synchronize()
    }
    
    //Загружає данні
    func loadScores() {
        guard ud.value(forKey: highscoreKey) != nil else { return }
            highscore = ud.array(forKey: highscoreKey) as! [Int]
    }
    
    //Метод для збереження данних
    func saveGameSettings() {
        //Зберігаємо дані в UserDefaults
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
    }
    
    //Метод який загружає данні
    func loadGameSettings() {
        //Зробимо провірку чи є якісь значення
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        //Якщо є то загружаємо їх
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
}
