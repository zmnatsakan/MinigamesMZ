//
//  Cup.swift
//  dices
//
//  Created by mnats on 20.11.2023.
//

import SwiftUI

struct CupView: View {
    var id: Int
    @Binding var reveal: Bool
    @State private var isUp = false
    @State var isCoinPresent = true
    var winChance: Float
    var onCupRevealed: (Bool) -> ()
    
    init(id: Int, reveal: Binding<Bool> = .constant(false), winChance: Float = 1, onCupRevealed: @escaping (Bool) -> () = {_ in}) {
        self.id = id
        self._reveal = reveal
        self.isUp = false
        self.isCoinPresent = true
        self.winChance = winChance
        self.onCupRevealed = onCupRevealed
    }
    
    func moveUpDown() {
        guard !isUp else { return }
        Task {
            withAnimation {
                isUp = true
            }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                isUp = false
            }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isCoinPresent = false
        }
    }
    
    var body: some View {
        ZStack {
            Image("cup")
                .resizable()
                .offset(y: isUp ? -70 : 0)
                .aspectRatio(1, contentMode: .fit)
                .background {
                    if isCoinPresent {
                        Circle()
                            .scale(isUp ? 0.4 : 0)
                            .offset(y: 20)
                            .foregroundColor(.yellow)
                    }
                }
        }
        .onTapGesture {
            isCoinPresent = winChance > Float.random(in: 0...1)
            moveUpDown()
            onCupRevealed(isCoinPresent)
        }
        .onChange(of: reveal) { _ in
            isCoinPresent = true
            moveUpDown()
        }
    }
}

#Preview {
    HStack {
        CupView(id: 0, reveal: .constant(false), winChance: 1)
        CupView(id: 0, reveal: .constant(false), winChance: 1)
        CupView(id: 0, reveal: .constant(false), winChance: 1)
    }
}
