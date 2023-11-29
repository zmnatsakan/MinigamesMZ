//
//  ClickerView.swift
//  MinigamesMZ
//
//  Created by mnats on 29.11.2023.
//

import SwiftUI

struct ClickerView: View {
    @StateObject var viewModel = ClickerViewModel()

    var body: some View {
        Text(viewModel.label)
            .font(.title.bold())
            .frame(height: 200)
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 300, height: 300)
                .overlay {
                    Circle().frame(width: 20, height: 20).foregroundStyle(.red)
                        .offset(y: viewModel.offsetY)
                }
                .onTapGesture {
                    viewModel.onTapGesture()
                }
                .padding()
            Divider().foregroundStyle(.red)
        }
        .onChange(of: viewModel.offsetY) { _ in
            viewModel.checkOffset()
        }
        Button("Start") {
            viewModel.startTimer()
        }
    }
}

#Preview {
    ClickerView()
}



#Preview {
    ClickerView()
}
