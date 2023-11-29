//
//  ShellGameView.swift
//  dices
//
//  Created by mnats on 20.11.2023.
//

import SwiftUI

struct ShellGameView: View {
    //MARK: - cupsCount = 1, winChance = 0 при плохой карме
    @ObservedObject var viewModel = ShellGameViewModel(cupsCount: 3, winChance: 0.3)
    @State var reveal: Bool = false
    @State var shuffleInProgress = false
    
    func shuffle(times: Int = 10, speed: Float = 1) async {
        var counter = times
        while counter > 0 {
            withAnimation {
                viewModel.shuffleCups()
            }
            try? await Task.sleep(nanoseconds: UInt64(300_000_000 / speed))
            counter -= 1
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(viewModel.cupViews, id: \.id) { cupView in
                    cupView
                        .disabled(!viewModel.readyToReveal)
                        .minimumScaleFactor(0.1)
                        .frame(maxWidth: 150)
                }
            }
//            .scaledToFit()
        }
        .padding()
        .onAppear {
            viewModel.setUpCups(reveal: $reveal)
        }
        Group {
            if viewModel.isFinish {
                Text(viewModel.isWin ? "You win" : "You lose")
            } else if !viewModel.readyToReveal {
                Text("Let's play!")
            } else {
                Text("Try your luck")
            }
        }
        .font(.title)
        .foregroundStyle(viewModel.isFinish ? (viewModel.isWin ? .green : .red) : .primary)
        .frame(height: 100)

        VStack {
            Slider(value: $viewModel.winChance, in: 0...1) {
                Text("\(viewModel.winChance) chance")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
            Text("\(viewModel.winChance, specifier: "%.2f") chance")
        }
        .padding(.horizontal)
        
        Button("Shuffle") {
            shuffleInProgress = true
            viewModel.setUpCups(reveal: $reveal)
            Task {
                await shuffle(times: 5, speed: 3)
                try? await Task.sleep(nanoseconds: 400_000_000)
                reveal.toggle()
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                await shuffle()
                viewModel.readyToReveal = true
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation {
                    shuffleInProgress = false
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(shuffleInProgress || viewModel.readyToReveal)
    }
}

#Preview {
    ShellGameView()
}
