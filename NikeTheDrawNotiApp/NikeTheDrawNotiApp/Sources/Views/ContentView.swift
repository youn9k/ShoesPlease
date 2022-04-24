//
//  ContentView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MainViewModel()
    @State var refresh: Bool = false
    let columns = [
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100))
    ]
    var body: some View {
        NavigationView {
            ZStack {
                Color.cream
                if viewModel.drawableItems.isEmpty {
                    Text("내용이 엄서용")
                }
                RefreshableScrollView(isRefreshing: $refresh) {
                    Text(viewModel.testString)
                        .font(.headline)
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.drawableItems) { drawableItem in
                            NavigationLink(destination: Text("네비게이션 테스트 뷰 입니다!")) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.white)
                                    VStack {
                                        Text(drawableItem.title)
                                            .foregroundColor(.black)
                                        AsyncImage(url: URL(string: drawableItem.image)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .mask {
                                            RoundedRectangle(cornerRadius: 15)
                                        }
                                    }
                                }// ZStack
                            }// NavigationLink
                        }
                    }
                } onRefresh: {
                    print("onRefresh!!")
                    print(viewModel.drawableItems)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewModel.refreshActionSubject.send()
                        withAnimation { refresh = false }
                    }
                }// RefreshableScrollView
            }// ZStack
            .navigationTitle("앱 아이콘 들어갈 곳")
            .navigationBarTitleDisplayMode(.inline)
        }// NavigationView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public struct RefreshableScrollView<Content: View>: View {
    @Binding private var isRefreshing: Bool
    @State private var offset: CGFloat = .zero
    private var content: () -> Content
    private let onRefresh: () -> Void
    
    private let threshold: CGFloat = 80.0
    
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
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.3, anchor: .top)
                            .padding()
                            .frame(height: threshold)
                            .transition(.move(edge: .top).animation(.easeInOut).combined(with: .opacity))
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
