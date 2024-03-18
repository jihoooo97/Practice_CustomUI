//
//  CarouselView.swift
//  Practice_CustomUI
//
//  Created by 유지호 on 3/18/24.
//

import SwiftUI

struct ParallaxCarouselView<T: RandomAccessCollection, Content: View>: View where T.Element: Identifiable {
    let data: T
    let content: (T.Element) -> Content
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        ForEach(data) { card in
                            content(card)
                                .frame(width: size.width - 30, height: size.height - 50)
                        }
                    }
                    .padding(.horizontal)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .top)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
            .frame(height: 500)
            .padding(.top, 10)
        }
        .safeAreaPadding(.horizontal, 30)
    }
}

#Preview {
    ParallaxCarouselView(data: CardItem.mockData) { data in
        GeometryReader { proxy in
            let cardSize = proxy.size
            let minX = proxy.frame(in: .scrollView).minX
            
            Text(data.name)
                .offset(x: -minX)
                .frame(width: cardSize.width, height: cardSize.height)
                .background(.gray)
                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                .overlay {
                    ZStack(alignment: .bottomLeading) {
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.1),
                                .black
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        VStack(alignment: .leading) {
                            Text(data.name)
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundStyle(.white)
                        }
                        .padding(20)
                    }
                }
                .clipShape(.rect(cornerRadius: 15))
        }
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view
                .scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
    }
}

struct CardItem: Identifiable {
    var id: UUID = .init()
    var name: String
    
    static let mockData: [CardItem] = [
        CardItem(name: "a"),
        CardItem(name: "b"),
        CardItem(name: "c"),
        CardItem(name: "d"),
        CardItem(name: "e"),
    ]
}

struct AnotherItem: Identifiable {
    var id: UUID = .init()
    var name: String
    
    static let mockData: [AnotherItem] = [
        AnotherItem(name: "1"),
        AnotherItem(name: "2"),
        AnotherItem(name: "3"),
        AnotherItem(name: "4"),
        AnotherItem(name: "5"),
    ]
}
