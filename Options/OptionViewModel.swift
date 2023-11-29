//
//  OptionViewModel.swift
//  MinigamesMZ
//
//  Created by mnats on 24.11.2023.
//

import SwiftUI

enum Direction {
    case up, down
}

@MainActor
final class OptionViewModel: ObservableObject {
    @Published var sliderValue: CGFloat = 0
    @Published var isAnimating = false
    @Published var buttonDisabled = false
    @Published var isFinishPresented = false
    @Published var gameResult: GameResult = .draw
    var selectedDirection = Direction.up

    func startAnimating() {
        isAnimating = true

        withAnimation {
            sliderValue = ([-0.5, 0.5] as [CGFloat]).randomElement()!
        }
        
        withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(5, autoreverses: true)) {
            sliderValue = 0 - sliderValue
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.sliderValue = CGFloat.random(in: 0...1) < 0.5 ? CGFloat.random(in: -0.5...(-0.3)) : CGFloat.random(in: 0.3...0.5)
                self.isAnimating = false
                self.showFinishScreen()
            }
        }
    }

    func showFinishScreen() {
        Task {
            if selectedDirection == .up && sliderValue > 0 ||
                selectedDirection == .down && sliderValue < 0 {
                gameResult = .win
            } else {
                gameResult = .lose
            }
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                isFinishPresented = true
            }
        }
    }
    
    func restart() {
        sliderValue = 0
        isAnimating = false
        buttonDisabled = false
        isFinishPresented = false
        gameResult = .draw
        selectedDirection = Direction.up
    }
}
