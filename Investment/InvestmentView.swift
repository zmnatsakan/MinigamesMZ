//
//  InvestmentView.swift
//  MinigamesMZ
//
//  Created by mnats on 22.11.2023.
//

import SwiftUI

struct InvestmentView: View {
    @ObservedObject var viewModel: InvestmentViewModel
    @State var runningView: RunningLineView
    
    init() {
        self.viewModel = InvestmentViewModel()
        let array = ["Gazik", "Sberz", "Lukol", "Yandx", "Rosny", "Aerok", "Rostl", "VKut", "Magny", "Kaspk", "Belug", "AlfaZ", "X5ail", "Mobil", "Trans", "Noril", "Vebro", "Tatnf", "Evraz", "Sevrl"]
        self.runningView = RunningLineView(items: array)
    }
    
    var body: some View {
        ZStack {
            VStack {
                runningView
                    .frame(height: 100)
                HStack {
                    LineChartView(data: viewModel.chartData,
                                  minY: viewModel.minY,
                                  maxY: viewModel.maxY,
                                  color: $viewModel.chartColor)
                    .frame(height: 300)
                    .foregroundStyle(.red)
                    .background(
                        RoundedRectangle(cornerRadius: 10).foregroundStyle(viewModel.chartColor.opacity(0.2))
                    )
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
                Button("Print") {
                    print(viewModel.chartData)
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
    InvestmentView()
}
