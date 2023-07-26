//
//  IdModifierTest.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/24.
//

import SwiftUI

struct StringWithId: Identifiable {
    let id: Int
    var str: String
}

extension Array where Element == String {
    func mapArrayWithId() -> Array<StringWithId> {
        self.enumerated().map { index, element in
            StringWithId(id: index, str: element)
        }
    }
}

struct IdModifierTest: View {
    @State private var listItem = ["A", "B", "C", "D"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(listItem.mapArrayWithId()) { item in
                    //id수정자로 매번 id를 업데이트 -> 자연스러운 애니메이션 불가
                    Text(item.str)
                        .id(UUID())
                }
            }
            .toolbar {
                Button("Add Item") {
                    withAnimation {
                        listItem.append("E")
                    }
                }
            }
        }
    }
}

struct IdModifierTest_Previews: PreviewProvider {
    static var previews: some View {
        IdModifierTest()
    }
}
