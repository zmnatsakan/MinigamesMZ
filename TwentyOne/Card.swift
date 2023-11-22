//
//  Card.swift
//  dices
//
//  Created by mnats on 21.11.2023.
//

import SwiftUI

class Card: ObservableObject, Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.rank == rhs.rank
    }
    
    let id = UUID()
    
    @Published var isClosed = true
    var rank: CardRank
    var suit: CardSuit
    
    init(_ rank: CardRank, of suit: CardSuit) {
        self.isClosed = true
        self.rank = rank
        self.suit = suit
    }
}
