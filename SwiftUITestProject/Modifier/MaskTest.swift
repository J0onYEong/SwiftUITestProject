//
//  MaskTest.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/29.
//

import SwiftUI

struct MaskTest: View {
    var body: some View {
        Text("대한민국")
            .font(Font.system(size: 100, weight: .bold))
            .frame(width: 400)
            .useThisViewAs(mask: LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            .border(.red)
    }
}

extension View {
    func useThisViewAs(mask: some View) -> some View {
        self.overlay {
            mask
                .mask {
                    self
                }
        }
    }
}

struct MaskTest_Previews: PreviewProvider {
    static var previews: some View {
        MaskTest()
    }
}
