//
//  BetWithStrangerView.swift
//  MinigamesMZ
//
//  Created by mnats on 27.11.2023.
//

import SwiftUI

struct FlippingView: View {
    @State private var flipped = false
    @State private var scaled = false
    @State private var animate3d = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack() {
                FrontCoin().opacity(flipped ? 0.0 : 1.0)
                BackCoin().opacity(flipped ? 1.0 : 0.0)
            }
            .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 720 + 180 : 0, axis: (x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))))
            .scaleEffect(CGSize(width: scaled ? 1.5 : 1.0, height: scaled ? 1.5 : 1.0))
            .onTapGesture {
                Task {
                    withAnimation(Animation.easeInOut(duration: 2)) {
                        self.animate3d.toggle()
                    }
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        scaled.toggle()
                    }
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        scaled.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct FlipEffect: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.flipped = Int(self.angle) % 360 >= 90 && Int(self.angle) % 360 < 270
        }
        
        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct FrontCoin : View {
    var body: some View {
        Text("Win!").padding(5).frame(width: 250, height: 150, alignment: .center).background(Circle().foregroundStyle(.green))
    }
}

struct BackCoin : View {
    var body: some View {
        Text("Lose!").padding(5).frame(width: 250, height: 150).background(Circle().foregroundStyle(.red))
    }
}

#Preview {
    FlippingView()
}
