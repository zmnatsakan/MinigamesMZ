//
//  TwentyOneView.swift
//  dices
//
//  Created by mnats on 21.11.2023.
//

import SwiftUI

struct TwentyOneView: View {
    @Namespace private var animation
    @ObservedObject var viewModel: TwentyOneViewModel
    
    init(enemyTarget: Int = 20, guaranteedWin: Bool = false) {
        self.viewModel = TwentyOneViewModel(enemyTarget: enemyTarget, guaranteedWin: guaranteedWin)
    }

    var body: some View {
        ZStack {
            VStack {
                Text("Enemy's next hand sum:")
                Picker(selection: $viewModel.enemyTarget) {
                    ForEach(5...30, id: \.self) { number in
                        Text("\(number)")
                    }
                } label: {
                    Text("Pick")
                }

                deckView()
                Spacer()
                enemyHandView()
                Spacer()
                playerHandView()
                Spacer()
                comparisonButton()
            }
            .disabled(viewModel.isFinished)

            
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
                    VStack {
                        Button("Restart") {
                            viewModel.resetGame()
                            Task {
                                await viewModel.startGame()
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.startGame()
        }
        .onDisappear {
            viewModel.resetGame()
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
                        .disabled(!viewModel.isEnemyDealt)
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
                        .onAppear {
                            card.isClosed = true
                        }
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
    TwentyOneView(guaranteedWin: true)
}
