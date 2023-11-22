//
//  ContentView.swift
//  dices
//
//  Created by mnats on 20.11.2023.
//

import SwiftUI

struct DiceView: View {
    @ObservedObject var viewModel = DiceViewViewModel(diceAmount: 2)
    
    var body: some View {
        VStack {
            HStack {
                ForEach(viewModel.enemyFaces, id: \.self) { face in
                    Image(viewModel.diceRotating ? "dice1" : face)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .rotationEffect(.degrees(viewModel.diceRotation))
                }
            }
            
            Spacer()
            
            if let gameResult = viewModel.gameResult {
                Text(String(viewModel.score.1))
                Text(gameResult.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(gameResult == .draw ? Color.primary :
                                        (gameResult == .win ? Color.green : Color.red))
                
                Text(String(viewModel.score.0))
            }
            
            Spacer()
            
            HStack {
                HStack {
                    ForEach(viewModel.playerFaces, id: \.self) { face in
                        Image(viewModel.diceRotating ? "dice1" : face)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 200)
                            .rotationEffect(.degrees(viewModel.diceRotation))
                    }
                }
            }
            
            Button("Rotate") {
                viewModel.rollDice()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    DiceView()
}
