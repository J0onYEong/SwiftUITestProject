//
//  ClippedTest.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/25.
//

import SwiftUI


/// Circle을 사용한 방법은 수치적으로 정확해도 내부적인 오차가 발생해 프리뷰처럼 조금의 간극이 발생한다.
/// addArc를 사용하여 구현하면 간극없이 완벽한 구현이 가능하다.
struct QuaterCicle: View {
    
    let lineWidth = 5.0
    
    var body: some View {
        HStack(spacing: 0) {
            GeometryReader { geo in
                Circle()
                    .trim(from: 0.25, to: 0.5)
                    .stroke(lineWidth: lineWidth)
                    .padding(lineWidth/2)
                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    .scaleEffect(2.0)
                    .offset(CGSizeMake(geo.size.width/2, geo.size.height/2))
            }
            .aspectRatio(contentMode: .fit)
            ZStack {
                Rectangle()
                Rectangle()
                    .fill(.white)
                    .padding(.top, lineWidth*2)
            }
        }
        .frame(height: 200)
    }
}


struct TransitionWithClippedTest: View {
    @State private var isShowing = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    if isShowing {
                        ZStack {
                            LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing)
                            Text("Hello world")
                                .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 200)
                        .transition(.move(edge: .bottom))
                    }
                }
                .frame(width: 200)
                .clipShape(Rectangle())
            }
            
            
            
            VStack {
                Spacer()
                Spacer()
                Button("Change State") {
                    withAnimation {
                        isShowing.toggle()
                    }
                }
                Spacer()
            }
        }
    }
}


struct ClippedTest_Previews: PreviewProvider {
    static var previews: some View {
        TransitionWithClippedTest()
    }
}
