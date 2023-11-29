//
//  OptionView.swift
//  MinigamesMZ
//
//  Created by mnats on 24.11.2023.
//

import SwiftUI

struct OptionView: View {
    @ObservedObject private var viewModel = OptionViewModel()

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ZStack {
                    VStack(spacing: 0) {
                        Color.green.frame(height: 200)
                        Color.red.frame(height: 200)
                    }
                    .frame(width: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Rectangle()
                        .frame(width: 70, height: 10)
                        .offset(y: -viewModel.sliderValue * 400)
                }
                
                Spacer()
                
                Group {
                    Button {
                        viewModel.selectedDirection = .up
                        viewModel.startAnimating()
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.title.bold())
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.green))
                    
                    Button {
                        viewModel.selectedDirection = .down
                        viewModel.startAnimating()
                    } label: {
                        Image(systemName: "arrow.down")
                            .font(.title.bold())
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.red))
                }
                .foregroundStyle(.white)
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
    OptionView()
}
