//
//  ContentView.swift
//  task5
//
//  Created by Роман on 12/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    let colorArray: [Color] = [.white, .pink, .yellow, .black]
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                ForEach((0...colorArray.count - 1), id: \.self) { i in
                    Rectangle()
                        .foregroundColor(colorArray[i])
                }
            }.ignoresSafeArea()
                    GeometryReader { geometry in
                        let view = Rectangle()
                        view
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .position(x: geometry.size.width / 2,
                                      y: geometry.size.height / 2)
                            .addCustomBlendMode()
                            
                    }.draggable()
        }.background(Color.clear).compositingGroup()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DraggableView: ViewModifier {
    @State var offset = CGPoint(x: 0, y: 0)
    
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    self.offset.x += value.location.x - value.startLocation.x
                    self.offset.y += value.location.y - value.startLocation.y
            })
            .offset(x: offset.x, y: offset.y)
    }
}

extension View {
    func draggable() -> some View {
        return modifier(DraggableView())
    }
}

extension View {
    func addCustomBlendMode() -> some View {
        return modifier(CustomBlendMode())
    }
}

struct CustomBlendMode: ViewModifier {
    
    let view: some View =  Rectangle()
        .frame(width: 80, height: 80)
        .cornerRadius(10)
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .blendMode(.difference)
            .overlay(content
                .overlay(
                    view
                        .blendMode(.hue))
                .overlay(
                    view
                        .foregroundColor(.white).blendMode(.overlay)
                )
                .overlay(
                    view
                        .foregroundColor(.black).blendMode(.overlay)
                )
                .blendMode(.overlay))
            .overlay(content.foregroundColor(.white).blendMode(.overlay))
    }
}
