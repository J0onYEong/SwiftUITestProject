//
//  TabViewWithScrollView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/08/30.
//

import SwiftUI

struct TabViewWithScrollView<Sample>: View where Sample: TabViewWithScrollTabSample {
    @Binding var selectedTabSampleKey: Sample
    
    
    @State private var underBarOffsetXValue: CGFloat = 0.0
    
    var tabs: [Sample : AnyView]
    
    private var countOfTabs: Int { tabs.count }
    
    private let tabBarItemCount = 4
    private var tabBarItemFrameWidth: CGFloat { UIScreen.main.bounds.width / CGFloat(tabBarItemCount) }
    
    private var offsetXStartValue: CGFloat {
        CGFloat(countOfTabs % 2 == 0 ? countOfTabs/2 : Int(countOfTabs/2)) * (-tabBarItemFrameWidth)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                
                //여기를 조작하여 원하는 백그라운드를 설정할 수 있다.
                Color.cyan.ignoresSafeArea()
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                ForEach(tabs.keys.sorted()) { sample in
                                    //선택상태 및 다른 조작이 가능하다.
                                    GeometryReader { geoOverItemBox in
                                        VStack {
                                            //탭뷰에 표시되는 아이템
                                            Text(sample.title)
                                                .font(Font.system(size: 14))
                                                .frame(height: 14)
                                            
                                        }
                                        .position(x: geoOverItemBox.size.width/2, y: geoOverItemBox.size.height/2)
                                    }
                                    .frame(width: tabBarItemFrameWidth)
                                    .contentShape(Rectangle())
                                    .id(sample)
                                    .onTapGesture {
                                        selectedTabSampleKey = sample
                                    }
                                    
                                }
                            }
                            GeometryReader { geoOverUnderBar in
                                Rectangle()
                                    .onChange(of: underBarOffsetXValue) { newOffsetXValue in
                                        let scrollViewSpaceCoordinate = geoOverUnderBar.frame(in: .named("ScrollViewCoordinate"))
                                        if scrollViewSpaceCoordinate.minX > UIScreen.main.bounds.width {
                                            proxy.scrollTo(selectedTabSampleKey, anchor: .leading)
                                        }
                                    }
                            }
                            .frame(width: tabBarItemFrameWidth, height: 3)
                            .offset(x: underBarOffsetXValue, y: 0)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .frame(height: 50)
            .coordinateSpace(name: "ScrollViewCoordinate")
            .onChange(of: selectedTabSampleKey) { sampleKey in
                if let index = tabs.keys.sorted().firstIndex(of: sampleKey) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        underBarOffsetXValue = offsetXStartValue + tabBarItemFrameWidth * CGFloat(index)
                    }
                }
            }
            
            .onAppear {
                underBarOffsetXValue = offsetXStartValue
            }
            
            //----------------------뷰----------------------
            
            GeometryReader { geo in
                tabs[selectedTabSampleKey]?
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
            }
            
            
            Spacer(minLength: 0)
        }
    }
}

//------------------------------------------------------

protocol TabViewWithScrollTabSample: Identifiable, Hashable, Comparable {
    var title: String { get }
}


enum TabViewWithScrollSample: TabViewWithScrollTabSample {
    var id: UUID { UUID() }
    
    case one, two, three, four, five, six, seven
    
    var title: String {
        switch self {
        case .one:
            return "one"
        case .two:
            return "two"
        case .three:
            return "three"
        case .four:
            return "four"
        case .five:
            return "five"
        case .six:
            return "six"
        case .seven:
            return "seven"
        }
    }
}


fileprivate struct TestView: View {
    
    @State private var selectedTabSample: TabViewWithScrollSample = .one
    
    var body: some View {
        let tabs: [TabViewWithScrollSample : AnyView] = [
            .one : AnyView(Rectangle().foregroundColor(.red)),
            .two : AnyView(Rectangle().foregroundColor(.blue)),
            .three : AnyView(Rectangle().foregroundColor(.green)),
            .four : AnyView(Rectangle().foregroundColor(.indigo)),
            .five : AnyView(Rectangle().foregroundColor(.cyan)),
            .six : AnyView(Rectangle().foregroundColor(.purple)),
            .seven : AnyView(Rectangle().foregroundColor(.gray)),
        ]
        
        TabViewWithScrollView(selectedTabSampleKey: $selectedTabSample, tabs: tabs)
    }
    
}

struct TabViewWithScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
