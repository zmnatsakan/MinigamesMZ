//
//  TwentyOneView.swift
//  dices
//
//  Created by mnats on 21.11.2023.
//

import SwiftUI

//struct TwentyOneView: View {
//    @Namespace private var animation
//    @ObservedObject var viewModel = TwentyOneViewModel()
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                ZStack(alignment: .center) {
//                    ForEach(viewModel.deck, id: \.id) { card in
//                        CardView(card: card)
//                            .onTapGesture {
//                                viewModel.dealToPlayer()
//                            }
//                            .matchedGeometryEffect(id: card.id, in: animation)
//                    }
//                }
//                
//                Spacer()
//            }
//            
//            Spacer()
//            if let enemyScore = viewModel.enemyScore {
//                Text("Enemy score: \(enemyScore)")
//            }
//            HStack {
//                ForEach(viewModel.enemyHand, id: \.id) { card in
//                    CardView(card: card)
//                        .matchedGeometryEffect(id: card.id, in: animation)
//                        .padding(.horizontal, -CGFloat(5 * viewModel.enemyHand.count))
//                }
//            }
//            .padding(.horizontal, 50)
//            
//            Spacer()
//            
//            Text("Total: \(viewModel.playerScore)")
//            
//            HStack {
//                ForEach(viewModel.hand, id: \.id) { card in
//                    CardView(card: card)
//                        .matchedGeometryEffect(id: card.id, in: animation)
//                        .padding(.horizontal, -CGFloat(5 * viewModel.hand.count))
//                }
//            }
//            .padding(.horizontal, 50)
//            
//            if viewModel.enemyScore == nil {
//                Button("Compare") {
//                    viewModel.enemyScore = 0
//                    for card in viewModel.enemyHand {
//                        withAnimation {
//                            card.isClosed = false
//                            viewModel.enemyScore! += card.rank.rawValue
//                        }
//                    }
//                    viewModel.isFinished = true
//                }
//            }
//        }
//        .disabled(viewModel.enemyScore != nil || viewModel.isFinished)
//        .onAppear {
//            viewModel.startGame()
//        }
//    }
//}

struct TwentyOneView: View {
    @Namespace private var animation
    @ObservedObject var viewModel = TwentyOneViewModel()

    var body: some View {
        ZStack {
            VStack {
                deckView()
                Spacer()
                enemyHandView()
                Spacer()
                playerHandView()
                Spacer()
                comparisonButton()
            }
            .disabled(viewModel.isFinished)
            .onAppear {
                viewModel.startGame()
            }
            
            if viewModel.isFinishPresented {
                Rectangle().foregroundStyle(.thinMaterial).ignoresSafeArea()
                VStack {
                    Spacer()
                    Text(viewModel.gameResult.rawValue)
                        .font(.largeTitle.bold())
                        .foregroundStyle(viewModel.gameResult == .draw ? Color.primary :
                                                                    (viewModel.gameResult == .win ? Color.green : Color.red))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                    Button("Restart") {
                        viewModel.resetGame()
                    }
                    Spacer()
                }
            }
        }
    }

    private func deckView() -> some View {
        HStack {
            Spacer()
            ZStack(alignment: .center) {
                ForEach(viewModel.deck, id: \.id) { card in
                    CardView(card: card)
                        .onTapGesture {
                            viewModel.dealToPlayer()
                        }
                        .matchedGeometryEffect(id: card.id, in: animation)
                }
            }
            Spacer()
        }
    }

    private func enemyHandView() -> some View {
        VStack {
            if let enemyScore = viewModel.enemyScore {
                Text("Enemy score: \(enemyScore)")
            }
            HStack {
                ForEach(viewModel.enemyHand, id: \.id) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: animation)
                        .padding(.horizontal, -CGFloat(5 * viewModel.enemyHand.count))
                }
            }
            .padding(.horizontal, 50)
        }
    }

    private func playerScoreView() -> some View {
        Text("Total: \(viewModel.playerScore)")
    }

    private func playerHandView() -> some View {
        VStack {
            playerScoreView()
            HStack {
                ForEach(viewModel.hand, id: \.id) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: animation)
                        .padding(.horizontal, -CGFloat(5 * viewModel.hand.count))
                }
            }
            .padding(.horizontal, 50)
        }
    }

    private func comparisonButton() -> some View {
        return Button("Compare", action: viewModel.compareHands)
            .disabled(viewModel.playerScore == 0)
    }
}

#Preview {
    TwentyOneView()
}
