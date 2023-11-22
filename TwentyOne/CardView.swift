//
//  CardView.swift
//  dices
//
//  Created by mnats on 21.11.2023.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var card: Card = Card(.six, of: .spades)
    
    var rankLabel: String {
        switch card.rank {
        case .six:
            "6"
        case .seven:
            "7"
        case .eight:
            "8"
        case .nine:
            "9"
        case .ten:
            "10"
        case .jack:
            "J"
        case .queen:
            "Q"
        case .king:
            "K"
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 2)
                .fill(card.isClosed ? Color(red: 0.7, green: 0.1, blue: 0.1) : .white)
                .frame(width: 100, height: 150)
            if !card.isClosed {
                Text(rankLabel)
                    .font(.title.bold())
                    .foregroundStyle(card.suit == .clubs || card.suit == .spades ? .black : .red)
                    .padding(5)
            }
        }
        .overlay {
            if !card.isClosed {
                Text(card.suit.rawValue)
                    .font(.largeTitle)
            }
        }
        .transition(.scale(scale: 1))
        .rotation3DEffect(.degrees(card.isClosed ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
}

#Preview {
    CardView(card: Card(.eight, of: .clubs))
}
