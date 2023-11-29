//
//  ClickerViewModel.swift
//  MinigamesMZ
//
//  Created by mnats on 29.11.2023.
//

import SwiftUI

final class ClickerViewModel: ObservableObject {
    @Published var offsetY: CGFloat = 0
    @Published var label = "Ну давай!"
    var timer: Timer?

    func onTapGesture() {
        if offsetY >= -150 && offsetY < 150 && (timer?.isValid ?? false) {
            withAnimation {
                offsetY -= 5
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            withAnimation {
                self?.offsetY += 2
            }
        }
    }

    func checkOffset() {
        withAnimation {
            if offsetY <= -150 {
                label = "Признаю, ты был прав..."
                timer?.invalidate()
            } else if offsetY > 150 {
                label = "Больше тут не появляйся, звездабол..."
                timer?.invalidate()
            }
            updateLabelBasedOnOffset()
        }
    }

    private func updateLabelBasedOnOffset() {
        switch offsetY {
        case -145 ..< -110:
            label = "Ты похож на мудреца, друг"
        case -100 ..< -60:
            label = "Черт, все сходится!"
        case -50 ..< -10:
            label = "Ровно стелешь, однако"
        case 0..<40:
            label = "Не убедил, попробуй еще раз что-ли?"
        case 50..<90:
            label = "Не врешь ли ты часом, дружок?"
        case 100..<150:
            label = "Пойман за руку, дешевка!"
        default:
            break
        }
    }
}
