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
            VStack {
                NavigationLink(destination: DiceView()) {
                    Text("Dice Game")
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
                NavigationLink(destination: TwentyOneView()) {
                    Text("21")
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

#Preview {
    MainView()
}
