//
//  monospaced.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/08/01.
//

import SwiftUI

struct MonospacedTestView: View {
    @State private var digit: Int = 3000
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("I love you")
                    .font(Font.system(size: 30))
                
                Text("\(digit)")
                    .font(Font.system(size: 30, design: .monospaced))
                    .border(.blue)
            }
            .border(.red)
            
            Button("Change") {
                digit = Int.random(in: 1000...3000)
            }
        }
    }
}

struct monospaced_Previews: PreviewProvider {
    static var previews: some View {
        MonospacedTestView()
    }
}
