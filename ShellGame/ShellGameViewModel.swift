//
//  ShellGameViewModel.swift
//  dices
//
//  Created by mnats on 21.11.2023.
//

import SwiftUI

final class ShellGameViewModel: ObservableObject {
    @Published var cupViews: [CupView]
    @Published var isFinish: Bool
    @Published var isWin: Bool
    @Published var readyToReveal: Bool
    
    var cupsCount: Int
    @Published var winChance: Float
    
    init(cupsCount: Int = 3, winChance: Float = 1) {
        self.cupViews = []
        self.cupsCount = cupsCount
        self.winChance = winChance
        self.isFinish = false
        self.isWin = false
        self.readyToReveal = false
    }
    
    func shuffleCups() {
        isFinish = false
        isWin = false
        cupViews.shuffle()
    }
    
    func setUpCups(reveal: Binding<Bool>) {
        cupViews = []
        for i in 0..<cupsCount {
            self.cupViews.append(
                CupView(id: i,
                        reveal: i == 0 ? reveal : .constant(false),
                        winChance: winChance) { isWin in
                            self.isWin = isWin
                            self.isFinish = true
                            self.readyToReveal = false
                        }
            )
        }
    }
}
