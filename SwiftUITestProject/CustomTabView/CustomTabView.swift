//
//  CustomTabView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/08/28.
//

import SwiftUI

protocol TabSample: Hashable & Identifiable {
    var image: Image { get }
    var title: String { get }
}


struct CustomTabView<Sample>: View where Sample: TabSample {
    
    @Binding var selectedTabSampleKey: Sample
    
    var tabs: [Sample : AnyView]
    
    private var countOfTabs: Int { tabs.count }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                tabs[selectedTabSampleKey]?
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
            }
            Spacer(minLength: 0)
            ZStack {
                
                //여기를 조작하여 원하는 백그라운드를 설정할 수 있다.
                Color.cyan.ignoresSafeArea()
                
                GeometryReader { geo in
                    
                    let widthOfTabFrame = geo.size.width / CGFloat(countOfTabs)
                    
                    HStack(spacing: 0) {
                        ForEach(Array(tabs.keys)) { sample in
                            //선택상태 및 다른 조작이 가능하다.
                            VStack {
                                //탭뷰에 표시되는 아이템
                                sample.image
                                    .resizable()
                                    .scaledToFit()
                                Text(sample.title)
                                    .font(Font.system(size: 14))
                                    .frame(height: 14)
                                
                            }
                            .frame(width: widthOfTabFrame)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedTabSampleKey = sample }
                            .border(.red)
                        }
                    }
                }
            }
            .frame(height: 50)
        }
    }
}

//------------------------------------------------------

enum TestScreenTabViewSample: TabSample {
    case flower, house, bulb
    
    var id: UUID { UUID() }
    
    var image: Image {
        switch self {
        case .flower:
            return Image(systemName: "fanblades")
        case .house:
            return Image(systemName: "house.circle")
        case .bulb:
            return Image(systemName: "lightbulb.circle")
        }
    }
    
    var title: String {
        switch self {
        case .flower:
            return "flower"
        case .house:
            return "house"
        case .bulb:
            return "bulb"
        }
    }
}

struct TestView: View {
    
    @State private var selectedTabSample: TestScreenTabViewSample = .flower
    
    var body: some View {
        let tabs: [TestScreenTabViewSample : AnyView] = [
            .flower : AnyView(Rectangle().foregroundColor(.red)),
            .house : AnyView(Rectangle().foregroundColor(.blue)),
            .bulb : AnyView(Rectangle().foregroundColor(.green)),
        ]
        
        CustomTabView(selectedTabSampleKey: $selectedTabSample, tabs: tabs)
    }
    
}



struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
