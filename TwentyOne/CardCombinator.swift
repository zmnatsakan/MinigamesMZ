//
//  CardCombinator.swift
//  MinigamesMZ
//
//  Created by mnats on 27.11.2023.
//

import Foundation

class CardCombinator {
    static private var combinations = [[Card]]()

    static func findCombinations(cards: [Card], targetSum: Int) -> [[Card]] {
        combinations = []
        var currentCombination = [Card]()
        backtrack(currentCombination: &currentCombination, currentSum: 0, startIndex: 0, cards: cards, targetSum: targetSum)
        return combinations
    }

    static private func backtrack(currentCombination: inout [Card], currentSum: Int, startIndex: Int, cards: [Card], targetSum: Int) {
        if currentSum == targetSum {
            combinations.append(currentCombination)
            return
        }
        
        if currentSum > targetSum || startIndex >= cards.count {
            return
        }

        for i in startIndex..<cards.count {
            currentCombination.append(cards[i])
            backtrack(currentCombination: &currentCombination, currentSum: currentSum + cards[i].rank.rawValue, startIndex: i + 1, cards: cards, targetSum: targetSum)
            currentCombination.removeLast()
        }
    }
}
