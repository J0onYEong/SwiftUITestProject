//
//  TestCustomShape.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/24.
//

import SwiftUI

//Shape protocol conforms to Animatable
struct TestCustomShape: Shape {
    
    var value: Double
    
    internal var animatableData: Double {
        get { value }
        set { value = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX * animatableData, y: rect.maxY * animatableData))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
    
}
