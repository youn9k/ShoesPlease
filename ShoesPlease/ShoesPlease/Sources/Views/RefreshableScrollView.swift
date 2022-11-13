//
//  RR.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/28.
//

import SwiftUI

public struct RefreshableScrollView<Content: View>: View {
    @Binding private var isRefreshing: Bool
    @State private var offset: CGFloat = .zero
    private var content: () -> Content
    private let onRefresh: () -> Void
    
    private let threshold: CGFloat = 120.0
    
    public init(
        isRefreshing: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () -> Void
    ) {
        _isRefreshing = isRefreshing
        self.content = content
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack {
                        content()
                    }
                    .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
                        geometry[$0].y
                    }
                    .alignmentGuide(.top, computeValue: { _ in
                        isRefreshing ? -threshold : 0
                    })
                    if isRefreshing {
                        HStack {
                            Spacer()
                            ProgressView("")
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .scaleEffect(1.3, anchor: .top)
                                .padding()
                                .frame(height: threshold)
                                .transition(.move(edge: .top).animation(.easeInOut).combined(with: .opacity))
                            Spacer()
                        }
                        
                    }
                }
            }
            .onPreferenceChange(OffsetPreferenceKey.self) { currentOffset in
                DispatchQueue.main.async {
                    if !isRefreshing {
                        if currentOffset > threshold, offset <= threshold {
                            withAnimation {
                                isRefreshing = true
                                onRefresh()
                            }
                        }
                        self.offset = currentOffset
                    }
                }
            }
            .animation(.easeInOut, value: isRefreshing)
        }
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
