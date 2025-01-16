//
//  ContentView.swift
//  StackedCards
//
//  Created by Tim Guk on 12/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isRotationEnabled: Bool = true
    @State private var isShowsIndicator: Bool = false
    @State private var scrolledID: Int?
    @State private var currentIndex: Int? = 0
    @State private var dragDirection: String = "None"

    let items: [Item] = [
        Item(color: .red),
        Item(color: .orange),
        Item(color: .yellow),
        Item(color: .green),
        Item(color: .cyan),
        Item(color: .blue),
        Item(color: .purple),

    ]

    // 스크롤 상태 관리
    @State private var isDragging: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {
                    let size = $0.size

                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(0..<items.count, id:\.self) { index in
                                let item = items[index]
                                let isLogged = index == currentIndex

                                CardView(item)
                                    .padding(.horizontal, 88)
                                    .frame(width: size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .rotationEffect(rotation(for: geometryProxy, rotation: isRotationEnabled ? 5 : 0, isLogged: isLogged))
                                            .scaleEffect(scale(for: geometryProxy, scale: 0.1, isLogged: isLogged), anchor: .trailing)

                                            .offset(x: minX(for: geometryProxy, isLogged: isLogged))
                                            .offset(x: excessMinX(for: geometryProxy, offset: isRotationEnabled ? 8 : 10, isLogged: isLogged))
//                                            .opacity(0.6)
                                    }
                                    .zIndex(index == scrolledID ? 100 : items.zIndex(for: item, currentIndex: currentIndex ?? 0, scrollDirection: dragDirection))
                                    .id(index)
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.vertical, 16)
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(isShowsIndicator ? .visible : .hidden)
                    .scrollIndicatorsFlash(trigger: isShowsIndicator)
                    .scrollPosition(id: $scrolledID)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if !isDragging {
                                    isDragging = true
                                    print("Scrolling started")
                                    if let scrolledID = scrolledID {
                                        currentIndex = scrolledID
                                    }
                                }

                                // translation.width > 0 이면 오른쪽, < 0 이면 왼쪽
                                if value.translation.width > 0 {
                                    if dragDirection != "Right" {
                                        dragDirection = "Right"
                                        print("Scrolling to the Right")
                                    }
                                } else if value.translation.width < 0 {
                                    if dragDirection != "Left" {
                                        dragDirection = "Left"
                                        print("Scrolling to the Left")
                                    }
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                                print("Scrolling ended")
                                
                            }
                    )
                }
                .frame(height: 400)
                .animation(.snappy, value: isRotationEnabled)

                VStack (spacing: 16) {
                    Toggle("Rotation", isOn: $isRotationEnabled)
                    Toggle("Show Indicator", isOn: $isShowsIndicator)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
            }
            .navigationTitle("Stacked Cards")
        }
        .onChange(of: scrolledID) { oldValue, newValue in
            print("Scrolled ID: \(String(describing: newValue))")
        }
    }

    /// Card View
    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color.gradient)
    }

    /// Stakced Cards Animation
//    nonisolated
    private func minX(for proxy: GeometryProxy, isLogged: Bool) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        if isLogged { return -minX * edgeGain(progress(for: proxy, isLogged: isLogged)) }
        return -minX
    }

    private func edgeGain(_ x: CGFloat) -> CGFloat {
        if abs(x) > 1 { return 0 }
        return 4 * pow(abs(x) - 0.5, 2)
    }

//    nonisolated
    private func progress(for proxy: GeometryProxy, limit: CGFloat = 2, isLogged: Bool) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0

        // Converting into Progress
        let progress = (maxX / width) - 1.0
        var cappedProgress = min(progress, limit)

        cappedProgress = max(cappedProgress, -limit)

        if isLogged {
            print("Progress: \(progress)")
            print("Capped Progress: \(cappedProgress)")
        }
        return cappedProgress
    }

//    nonisolated
    private func scale(for proxy: GeometryProxy, scale: CGFloat = 0.1, isLogged: Bool) -> CGFloat {
        let progress = self.progress(for: proxy, isLogged: isLogged)
        return 1 - abs(progress) * scale
    }

//    nonisolated
    private func excessMinX(for proxy: GeometryProxy, offset: CGFloat = 10, isLogged: Bool) -> CGFloat {
        let progress = self.progress(for: proxy, isLogged: isLogged)

        if progress >= 0 {
            return progress * offset
        } else {
            return progress * offset * 6
        }
    }

//    nonisolated
    private func rotation(for proxy: GeometryProxy, rotation: CGFloat = 5, isLogged: Bool) -> Angle {
        let progress = self.progress(for: proxy, isLogged: isLogged)

        return .init(degrees: progress * rotation)
    }

}

#Preview {
    ContentView()
}
