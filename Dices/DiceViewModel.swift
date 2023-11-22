//
//  DiceViewModel.swift
//  dices
//
//  Created by mnats on 20.11.2023.
//

import Foundation
import SwiftUI

class DiceViewViewModel: ObservableObject {
    @Published var diceRotation: CGFloat
    @Published var diceRotating: Bool
    @Published var playerFaces: [String]
    @Published var enemyFaces: [String]
    @Published var score: (Int, Int)
    @Published var gameResult: GameResult?

    private var faces: [String]
    
    init(diceAmount: Int = 1) {
        self.diceRotation = 0
        self.diceRotating = false
        self.score = (0, 0)
        self.gameResult = nil
        self.faces = ["1", "2", "3", "4", "5", "6"]
        self.playerFaces = [String](repeating: "1", count: diceAmount)
        self.enemyFaces = [String](repeating: "1", count: diceAmount)
    }

    func rotate(_ count: Int, duration: TimeInterval = 1) async {
        withAnimation(.linear(duration: duration)) {
            diceRotation += 360 * CGFloat(count)
        }
        try? await Task.sleep(nanoseconds: UInt64(duration * 1000_000_000))
        return
    }

    func rollDice() {
        guard !diceRotating else { return }
        diceRotating = true
        gameResult = nil
        Task {
            await rotate(2)
            for i in 0..<playerFaces.count {
                playerFaces[i] = faces.randomElement()!
            }
            
            for i in 0..<enemyFaces.count {
                enemyFaces[i] = faces.randomElement()!
            }
            diceRotating = false
            
            score = (playerFaces.reduce(0) {$0 + (Int($1) ?? 0)},
                     enemyFaces.reduce(0) {$0 + (Int($1) ?? 0)})
            
            print(score)
            
            gameResult = score.0 == score.1 ? .draw : score.0 > score.1 ? .win : .lose
        }
    }
}
