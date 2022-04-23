//
//  ContentView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MainViewModel()
    var body: some View {
        Text(viewModel.testString)
            .font(.title)
        
        List(viewModel.drawableItems) { drawableItem in
            VStack {
                Text(drawableItem.title)
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
            }// VStack
        }
        .refreshable {
            viewModel.refreshActionSubject.send()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
