//
//  TabViewWithScrollView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/08/30.
//

import SwiftUI

struct TabViewWithScrollView<Sample>: View where Sample: TabViewWithScrollTabSample {
    @Binding var selectedTabSampleKey: Sample
    
    
    @State private var underBarOffsetX: CGFloat = 0.0
    
    var tabs: [Sample : AnyView]
    
    private var countOfTabs: Int { tabs.count }
    
    private let tabBarItemCount = 4
    private var tabBarItemFrameWidth: CGFloat { UIScreen.main.bounds.width / CGFloat(tabBarItemCount) }
    
    private var offsetXStart: CGFloat {
        CGFloat(countOfTabs % 2 == 0 ? countOfTabs/2 : Int(countOfTabs/2)) * (-tabBarItemFrameWidth)
    }
    
    //----------------View----------------
    @State private var viewOffsetX: CGFloat = 0.0
    
    
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
                                    .onChange(of: underBarOffsetX) { newOffsetXValue in
                                        let scrollViewSpaceCoordinate = geoOverUnderBar.frame(in: .named("ScrollViewCoordinate"))
                                        if scrollViewSpaceCoordinate.midX > UIScreen.main.bounds.width || scrollViewSpaceCoordinate.midX < 0  {
                                            withAnimation {
                                                proxy.scrollTo(selectedTabSampleKey, anchor: .trailing)
                                            }
                                        }
                                    }
                            }
                            .frame(width: tabBarItemFrameWidth, height: 3)
                            .offset(x: underBarOffsetX, y: 0)
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
                        underBarOffsetX = offsetXStart + tabBarItemFrameWidth * CGFloat(index)
                    }
                }
            }
            
            .onAppear {
                underBarOffsetX = offsetXStart
            }
            
            //----------------------뷰----------------------
            
            ZStack {
                
                if let index = tabs.keys.sorted().firstIndex(of: selectedTabSampleKey), index > 0 {
                    if let previousVew = tabs[tabs.keys.sorted()[index-1]] {
                        previousVew
                            .offset(x: -UIScreen.main.bounds.width + viewOffsetX, y: 0)
                    }
                }
                
                
                if let centerView = tabs[selectedTabSampleKey] {
                    centerView
                        .offset(x:viewOffsetX, y: 0)
                        .gesture(
                            DragGesture()
                                .onChanged(onDragGestureChange(value:))
                                .onEnded(onDragGestureEnded(value:))
                        )
                }
                
                if let index = tabs.keys.sorted().firstIndex(of: selectedTabSampleKey), index < countOfTabs-1 {
                    if let previousVew = tabs[tabs.keys.sorted()[index+1]] {
                        previousVew
                            .offset(x: +UIScreen.main.bounds.width + viewOffsetX, y: 0)
                    }
                }
                    
            }
            
            Spacer(minLength: 0)
        }
    }
    
    private func onDragGestureChange(value: DragGesture.Value) {
        //첫화면인 경우 오른쪽 슬라이드 막기
        if (tabs.keys.sorted().first != selectedTabSampleKey || value.translation.width < 0) && (tabs.keys.sorted().last != selectedTabSampleKey || value.translation.width > 0) {
            viewOffsetX = value.translation.width * 0.5
        }
    
    }
    
    private func onDragGestureEnded(value: DragGesture.Value) {
        //드래그를 절반이상 오른쪽으로 한경우
        if viewOffsetX > UIScreen.main.bounds.width * 0.25 {
            if let index = tabs.keys.sorted().firstIndex(of: selectedTabSampleKey), index > 0 {
                selectedTabSampleKey = tabs.keys.sorted()[index-1]
            }
        }
        
        if viewOffsetX < -UIScreen.main.bounds.width * 0.25 {
            if let index = tabs.keys.sorted().firstIndex(of: selectedTabSampleKey), index < countOfTabs-1 {
                selectedTabSampleKey = tabs.keys.sorted()[index+1]
            }
        }
        
        //중앙에 위치하도록
        viewOffsetX = 0.0
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
