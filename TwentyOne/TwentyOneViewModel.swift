//
//  TwentyOneViewModel.swift
//  dices
//
//  Created by mnats on 22.11.2023.
//

import SwiftUI

@MainActor
final class TwentyOneViewModel: ObservableObject {
    @Published var deck: [Card] = []
    @Published var hand: [Card] = []
    @Published var enemyHand: [Card] = []
    @Published var enemyRevealed = false
    @Published var enemyCardsDelt = 0
    @Published var enemyScore: Int? = nil
    @Published var isFinished = false
    @Published var isFinishPresented = false
    
    var playerScore: Int {
        return hand.reduce(0, { $0 + $1.rank.rawValue })
    }
    var gameResult: GameResult {
        if enemyScore == nil && isFinished {
            return .lose
        } else if enemyScore ?? 0 > 21 {
            return .win
        } else if enemyScore! > playerScore {
            return .lose
        } else if enemyScore! < playerScore {
            return . win
        } else {
            return .draw
        }
    }
    
    func dealToPlayer() {
        guard let card = deck.first else { return }
        withAnimation {
            hand.append(card)
            deck.remove(at: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    card.isClosed.toggle()
                }
            }
            if playerScore > 21 {
                finishGame()
            }
        }
    }
    
    func dealToEnemy() {
        guard let card = deck.first else { return }
        withAnimation {
            enemyHand.append(card)
            deck.remove(at: 0)
        }
    }
    
    func resetGame() {
        deck = []
        hand = []
        enemyHand = []
        enemyRevealed = false
        enemyCardsDelt = 0
        enemyScore = nil
        isFinished = false
        isFinishPresented = false
        startGame()
    }
    
    func startGame() {
        for suit in CardSuit.allCases {
            for rank in CardRank.allCases {
                deck.append(Card(rank, of: suit))
            }
        }
        deck.shuffle()
        Task {
            for _ in 0...Int.random(in: 2...3) {
                try? await Task.sleep(nanoseconds: 500_000_000)
                dealToEnemy()
            }
        }
    }
    
    func finishGame() {
        isFinished = true
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                isFinishPresented = true
            }
        }
    }
    
    func compareHands() {
        enemyScore = 0
        for card in enemyHand {
            withAnimation {
                card.isClosed = false
                enemyScore! += card.rank.rawValue
            }
        }
        finishGame()
    }
}
