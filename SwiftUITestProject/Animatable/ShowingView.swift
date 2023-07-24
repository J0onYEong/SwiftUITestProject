//
//  ShowingView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/24.
//

import SwiftUI

struct ShowingView: View {
    @State private var value = 0.0
    
    @State private var toggle = false
    
    var body: some View {
        TestCustomShape(value: value)
            .frame(width: 200, height: 200)
            .onTapGesture {
                print("Clicked")
                withAnimation(.spring(dampingFraction: 0.2)) {
                    toggle.toggle()
                    if toggle {
                        value = 0.5
                    } else {
                        value = 0.0
                    }
                }
            }
        
    }
}

struct ShowingView_Previews: PreviewProvider {
    static var previews: some View {
        ShowingView()
    }
}
