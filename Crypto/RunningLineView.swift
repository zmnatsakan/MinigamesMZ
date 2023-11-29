//
//  ContentView.swift
//  MinigamesMZ
//
//  Created by mnats on 24.11.2023.
//

import SwiftUI

struct RunningLineView: View {
    var items: [String]
    private var graphs: [[Double]] = []
    @State private var offset: CGFloat = 0
    @State private var data: [String]
    
    func makeList(_ n: Int) -> [Double] {
        var result = (0..<n - 1).map { _ in Double.random(in: 1...30) }
        result.append(Bool.random() ? Double.random(in: 1...3) : Double.random(in: 20...30))
        return result
    }

    init(items: [String]) {
        self.items = items
        _data = State(initialValue: items + items) // Start with two sets of items
        for _ in 0..<items.count {
            graphs.append(makeList(10))
        }
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(data, id: \.self) { item in
                    let data = graphs[items.firstIndex(of: item)!]
                    let color = data.first! < data.last! ? Color.green : Color.red
                    VStack {
                        Text(item)
                            .font(.title3.bold())
                            .frame(width: 100)
                            .foregroundStyle(color)
                        LineChartView(data: data, minY: 0, maxY: 20, color: .constant(color))
                            .frame(width: 100, height: 20)
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(color.opacity(0.2))
                    )
                    .padding(.horizontal, 5)
                }
            }
            .offset(x: offset, y: 0)
            .task {
                startScrolling(geometry: geometry)
            }
        }
    }

    func startScrolling(geometry: GeometryProxy) {
        let itemWidth: CGFloat = 140 // Adjust this based on your text width
        let totalWidth: CGFloat = CGFloat(data.count) * itemWidth
        let duration = Double(items.count)
        withAnimation(.linear(duration: duration)) {
            self.offset -= totalWidth / 2
        }
        Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { timer in
            offset = 0
            withAnimation(.linear(duration: duration)) {
                self.offset -= totalWidth / 2
            }

//            if abs(self.offset) > itemWidth {
//                self.offset += itemWidth
//                self.data.removeFirst()
//                self.data.append(items.randomElement()!) // Or append a specific item
//            }

//            if abs(self.offset) >= totalWidth / 2 {
//                // Reset to prevent overflow
//                self.offset = 0
//                self.data = items + items
//            }
        }
    }
}


#Preview {
    RunningLineView(items: ["Gazik", "Sberz", "Lukol", "Yandx"/*, "Rosny", "Aerok", "Rostl", "VKut", "Magny", "Kaspk", "Belug", "AlfaZ", "X5ail", "Mobil", "Trans", "Noril", "Vebro", "Tatnf", "Evraz", "Sevrl"*/])
}
