//
//  LineChartView.swift
//  MinigamesMZ
//
//  Created by mnats on 22.11.2023.
//

import SwiftUI

struct LineChartView: View {
    var data: [Double]
    var minY: Double
    var maxY: Double
    @Binding var color: Color

    var body: some View {
        GeometryReader { geometry in
            self.makeLineChart(geometry: geometry)
        }
    }

    private func makeLineChart(geometry: GeometryProxy) -> some View {
        Path { path in
            for index in data.indices {
                let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index)
                let yPosition = (1 - CGFloat((data[index] - minY) / (maxY - minY))) * geometry.size.height
                
                if index == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                } else {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
        }
        .stroke(color, lineWidth: 5)
    }
}
