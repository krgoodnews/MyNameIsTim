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

    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {
                    let size = $0.size

                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(0..<items.count, id:\.self) { index in
                                let item = items[index]
                                let isLogged = item.color == .blue

                                CardView(item)
                                    .padding(.horizontal, 88)
                                    .frame(width: size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .scaleEffect(scale(for: geometryProxy, scale: 0.1, isLogged: isLogged), anchor: .trailing)
                                            .rotationEffect(rotation(for: geometryProxy, rotation: isRotationEnabled ? 5 : 0, isLogged: isLogged))
                                            .offset(x: minX(for: geometryProxy))
                                            .offset(x: excessMinX(for: geometryProxy, offset: isRotationEnabled ? 8 : 10, isLogged: isLogged))
                                    }
                                    .zIndex(items.zIndex(for: item))
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
//    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color.gradient)
    }

    /// Stakced Cards Animation
//    nonisolated
    private func minX(for proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }

//    nonisolated
    private func progress(for proxy: GeometryProxy, limit: CGFloat = 2, isLogged: Bool) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0

        // Converting into Progress
        let progress = (maxX / width) - 1.0
        let cappedProgress = min(progress, limit)

        if isLogged {
            print("Progress: \(progress)")
            print("Capped Progress: \(cappedProgress)")
        }
        return cappedProgress
    }

//    nonisolated
    private func scale(for proxy: GeometryProxy, scale: CGFloat = 0.1, isLogged: Bool) -> CGFloat {
        let progress = self.progress(for: proxy, isLogged: isLogged)
        return 1 - progress * scale
    }

//    nonisolated
    private func excessMinX(for proxy: GeometryProxy, offset: CGFloat = 10, isLogged: Bool) -> CGFloat {
        let progress = self.progress(for: proxy, isLogged: isLogged)

        return progress * offset
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
