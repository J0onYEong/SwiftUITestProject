//
//  CustomTabView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/08/28.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

//------------------------------------------------------------------------------------


protocol CustomTabViewTabSample: Hashable & Identifiable & Comparable {
    var image: Image { get }
    var title: String { get }
}


struct CustomTabView<Sample>: View where Sample: CustomTabViewTabSample {
    
    @Binding var selectedTabSampleKey: Sample
    
    var centerTab: [Sample : AnyView]
    
    var underTabs: [Sample : AnyView]
    
    private var countOfTabs: Int { underTabs.count }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                underTabs[selectedTabSampleKey]?
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
            }
            .padding(.bottom, 25)
            VStack {
                let widthOfTabFrame = UIScreen.main.bounds.width / CGFloat(countOfTabs+1)
                
                let halfIndex = Int(countOfTabs / 2)
                
                Spacer()
                ZStack {
                    
                    //여기를 조작하여 원하는 백그라운드를 설정할 수 있다.
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.brown)
                        .ignoresSafeArea(.container, edges: .bottom)
                    
                    
                    
                    GeometryReader { geo in
                        ZStack {
                            Circle()
                                .fill(.brown)
                            
                            VStack {
                                //탭뷰에 표시되는 아이템
                                centerTab.keys.first!.image
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                            }
                        }
                        .frame(width: widthOfTabFrame*2)
                        .scaleEffect(1.5)
                        .position(x: geo.size.width/2, y: geo.size.height/2 * 0.5)
                        .contentShape(Circle())
                        .onTapGesture { selectedTabSampleKey = centerTab.keys.first! }
                    }
                    
                    
                    HStack(spacing: 0) {
                        ForEach(Array(underTabs.keys.sorted().enumerated()), id: \.element) { (index, sample) in
                            if index < halfIndex {
                                //선택상태 및 다른 조작이 가능하다.
                                VStack {
                                    //탭뷰에 표시되는 아이템
                                    sample.image
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, 5)
                                    Text(sample.title)
                                        .font(Font.system(size: 14))
                                        .frame(height: 14)
                                    
                                }
                                .frame(width: widthOfTabFrame)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedTabSampleKey = sample }
                            }
                        }
                        
                        Spacer(minLength: widthOfTabFrame)
                        
                        ForEach(Array(underTabs.keys.sorted().enumerated()), id: \.element) { (index, sample) in
                            if index >= halfIndex {
                                //선택상태 및 다른 조작이 가능하다.
                                VStack {
                                    //탭뷰에 표시되는 아이템
                                    sample.image
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, 5)
                                    Text(sample.title)
                                        .font(Font.system(size: 14))
                                        .frame(height: 14)
                                    
                                }
                                .frame(width: widthOfTabFrame)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedTabSampleKey = sample }
                            }
                        }
                    }
                    .frame(height: 50)
                    .cornerRadius(25, corners: [.topLeft, .topRight])
                }
                .frame(height: 50)
            }
        }
    }
}

//------------------------------------------------------

enum TestScreenTabViewSample: CustomTabViewTabSample {
    case flower, house, center, bulb, book
    
    var id: UUID { UUID() }
    
    var image: Image {
        switch self {
        case .flower:
            return Image(systemName: "fanblades")
        case .house:
            return Image(systemName: "house.circle")
        case .center:
            return Image(systemName: "circle.circle")
        case .bulb:
            return Image(systemName: "lightbulb.circle")
        case .book:
            return Image(systemName: "book")
        }
    }
    
    var title: String {
        switch self {
        case .flower:
            return "flower"
        case .house:
            return "house"
        case .center:
            return "center"
        case .bulb:
            return "bulb"
        case .book:
            return "book"
        }
    }
}

fileprivate struct TestView: View {
    
    @State private var selectedTabSample: TestScreenTabViewSample = .flower
    
    var body: some View {
        let underTabs: [TestScreenTabViewSample : AnyView] = [
            .flower : AnyView(Rectangle().foregroundColor(.red)),
            .house : AnyView(Rectangle().foregroundColor(.blue)),
            .bulb : AnyView(Rectangle().foregroundColor(.cyan)),
            .book : AnyView(Rectangle().foregroundColor(.white)),
        ]
        
        let centerTab: [TestScreenTabViewSample : AnyView] = [
            .center : AnyView(Rectangle().foregroundColor(.indigo))
        ]
        
        CustomTabView(selectedTabSampleKey: $selectedTabSample, centerTab: centerTab, underTabs: underTabs)
    }
    
}



struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
