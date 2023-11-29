//
//  MainView.swift
//  dices
//
//  Created by mnats on 22.11.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NavigationLink(destination: DiceView()) {
                        Text("Dice Game")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: DiceView(viewModel: DiceViewViewModel(diceAmount: 4, guaranteedWin: true))) {
                        Text("Dice Game (always wins)")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: ShellGameView()) {
                        Text("Shell Game")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: ShellGameView(viewModel: ShellGameViewModel(cupsCount: 5))) {
                        Text("Difficult Shell Game")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: ShellGameView(viewModel: ShellGameViewModel(cupsCount: 1, winChance: 0))) {
                        Text("0 karma Shell Game")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: TwentyOneView(enemyTarget: 10)) {
                        Text("21")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: TwentyOneView(enemyTarget: 10, guaranteedWin: true)) {
                        Text("21 (always wins)")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: InvestmentView()) {
                        Text("Investment")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: CryptoView()) {
                        Text("Crypto")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                    NavigationLink(destination: OptionView()) {
                        Text("Options")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }                
                    NavigationLink(destination: ClickerView()) {
                        Text("Clicker")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.thickMaterial))
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainView()
}
