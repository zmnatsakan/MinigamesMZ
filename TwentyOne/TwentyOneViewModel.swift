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
    @Published var enemyScore: Int? = nil
    @Published var isEnemyDealt = false
    @Published var isFinished = false
    @Published var isFinishPresented = false
    @Published var enemyTarget: Int
    @Published var guaranteedWin = false
    
    init(enemyTarget: Int, guaranteedWin: Bool = false) {
        self.deck = []
        self.hand = []
        self.enemyHand = []
        self.enemyRevealed = false
        self.enemyScore = nil
        self.isFinished = false
        self.isFinishPresented = false
        self.isEnemyDealt = false
        self.enemyTarget = enemyTarget
        self.guaranteedWin = guaranteedWin

    }
    
    var playerScore: Int {
        return hand.reduce(0, { $0 + $1.rank.rawValue })
    }
    var gameResult: GameResult {
        if enemyScore == nil && isFinished {
            return .lose
        } else if enemyScore ?? 0 > 21 {
            return .win
        } else if enemyScore ?? 0 > playerScore {
            return .lose
        } else if enemyScore ?? 0 < playerScore {
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
    
    func dealToEnemy() async {
        let combinations = CardCombinator.findCombinations(cards: deck, targetSum: enemyTarget)
        guard !combinations.isEmpty else { return }
        let willBeDeltToEnemy = combinations.randomElement()!
        for card in willBeDeltToEnemy {
            withAnimation {
                enemyHand.append(card)
                deck.removeAll { $0 == card }
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
        isEnemyDealt = true
    }
    
    func resetGame() {
        deck = []
        hand = []
        enemyHand = []
        enemyRevealed = false
        enemyScore = nil
        isFinished = false
        isFinishPresented = false
        isEnemyDealt = false
        print("RESET")
    }
    
    func startGame() async {
        print("ENEMYTARGET: \(enemyTarget)")
        for suit in CardSuit.allCases {
            for rank in CardRank.allCases {
                deck.append(Card(rank, of: suit))
            }
        }
        deck.shuffle()
        try? await Task.sleep(nanoseconds: 500_000_000)
        await  dealToEnemy()
        
        if guaranteedWin {
            let combinations = CardCombinator.findCombinations(cards: deck, targetSum: 21)
            guard !combinations.isEmpty else { return }
            let willBeDeltToPlayer = combinations.sorted(by: { $0.last!.rank.rawValue > $1.last!.rank.rawValue })[Int.random(in: 0...combinations.count / 4)]
            for card in willBeDeltToPlayer {
                deck.removeAll { $0 == card }
            }
            deck = willBeDeltToPlayer + deck
            return
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
