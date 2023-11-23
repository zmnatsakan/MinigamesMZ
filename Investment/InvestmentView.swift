//
//  InvestmentView.swift
//  MinigamesMZ
//
//  Created by mnats on 22.11.2023.
//

import SwiftUI

struct InvestmentView: View {
    @ObservedObject var viewModel = InvestmentViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    LineChartView(data: viewModel.chartData,
                                  minY: viewModel.minY,
                                  maxY: viewModel.maxY,
                                  color: $viewModel.chartColor)
                    .frame(width: .infinity, height: 300)
                    .foregroundStyle(.red)
                    .animation(.easeIn, value: viewModel.chartData.count)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(viewModel.chartColor.opacity(0.2)))
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
