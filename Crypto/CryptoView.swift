//
//  CryptoView.swift
//  MinigamesMZ
//
//  Created by mnats on 23.11.2023.
//

import SwiftUI

struct CryptoView: View {
    @ObservedObject var viewModel = CryptoViewModel(numberOfCharts: 3)
    @State var runningView: RunningLineView
    
    init(numberOfCharts: Int = 3) {
        self.viewModel = CryptoViewModel(numberOfCharts: numberOfCharts)
        let array = ["BitBuck", "CoinCon", "EtherYm", "RipRap", "LiteLot", "DashDsh", "DogeDbl", "Linky", "MoneroM", "StelarS", "Cardano", "PolkaDz", "TethrTl", "BinBuck", "Uniswop", "VeChnVt", "TronTrk", "Cosmos", "TezosT", "NeoNug"]
        self.runningView = RunningLineView(items: array)
    }
    
    var body: some View {
        ZStack {
            VStack {
                runningView.frame(height: 100)
                HStack {
                    ZStack {
                        ForEach(0..<viewModel.numberOfCharts, id: \.self) { index in
                            LineChartView(data: viewModel.chartDatas[index],
                                          minY: viewModel.minY,
                                          maxY: viewModel.maxY,
                                          color: $viewModel.chartColors[index])
                        }
                    }
                    .frame(height: 300)
                    .foregroundStyle(.red)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(viewModel.chartColors[0].opacity(0.2)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                Button("Invest") {
                    Task {
                        await viewModel.play()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.buttonDisabled)
                
                Spacer()
            }
            
            if viewModel.isFinishPresented {
                Rectangle().foregroundStyle(.thinMaterial).ignoresSafeArea()
                VStack {
                    Spacer()
                    Text(viewModel.gameResult == .win ? "+$$$" : "-$$$")
                        .font(.largeTitle.bold())
                        .foregroundStyle(viewModel.gameResult == .win ? Color.green : Color.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                    Button("Restart") {
                        withAnimation {
                            viewModel.restart()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    CryptoView()
}
