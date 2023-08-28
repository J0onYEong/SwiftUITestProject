//
//  HierarchyUpdateTestView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/08/16.
//

import SwiftUI

class ChildViewController: ObservableObject {
    @Published var testVar = false
}

fileprivate struct ChildView: View {
    @Binding var param1: Bool
    @StateObject private var controller = ChildViewController()
    @State private var str = ""
    
    var body: some View {
        VStack {
            Text(controller.testVar ? "True" : "False")
            TextField("", text: $str)
                .disabled(controller.testVar)
        }
        .onChange(of: param1) { state in
            print("!!")
            testfunc1()
        }
    }
}

extension ChildView {
    func testfunc1() {
        controller.testVar.toggle()
    }
}


struct HierarchyUpdateTestView: View {
    @State private var var1 = false
    var body: some View {
        ZStack {
            ChildView(param1: $var1)
            
            VStack {
                Spacer()
                Spacer()
                Button("Toggle") {
                    var1.toggle()
                }
                Spacer()
            }
            .onAppear {
                test2()
            }
        }
    }
    
    func test2() {
        var1 = true
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            var1.toggle()
        }
    }
}

struct HierarchyUpdateTestView_Previews: PreviewProvider {
    static var previews: some View {
        HierarchyUpdateTestView()
    }
}
