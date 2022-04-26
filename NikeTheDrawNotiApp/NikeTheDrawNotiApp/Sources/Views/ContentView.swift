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
        GridItem(.flexible(minimum: 100), spacing: 20),
        GridItem(.flexible(minimum: 100), spacing: 20)
    ]
    var body: some View {
        NavigationView {
            ZStack {
                Color.cream.ignoresSafeArea(edges: .bottom)
                if viewModel.drawableItems.isEmpty {
                    Text("진행중인 응모가 없어요 !")
                        .foregroundColor(.gray)
                }
                RefreshableScrollView(isRefreshing: $refresh) {
                    Text(viewModel.testString)
                        .font(.headline)
                    ZStack {
                        Color.clear// 비어있을때도 당길 수 있도록 투명 뷰
                        VStack(spacing: 20) {
                            ForEach(viewModel.drawableItems) { drawableItem in
                                NavigationLink(destination: Text("네비게이션 테스트 뷰 입니다!")) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.white)
                                        VStack {
                                            Text(drawableItem.title)
                                                .foregroundColor(.black)
                                            Text(drawableItem.theme)
                                                .foregroundColor(.gray)
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
                        }// VStack
                    }// ZStack
                } onRefresh: {
                    print(#fileID, #function, #line, "onRefresh")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewModel.refreshActionSubject.send()
                        withAnimation { refresh = false }
                    }
                }// RefreshableScrollView
                .padding(.horizontal, 10)
                .navigationTitle("응모 목록")
                //.navigationBarTitleDisplayMode(.inline)
            }// ZStack
        }// NavigationView
        .navigationViewStyle(.stack)// 안붙이면 콘솔창에 오류가 주르륵
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
