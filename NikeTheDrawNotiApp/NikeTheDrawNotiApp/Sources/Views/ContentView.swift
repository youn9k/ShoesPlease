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
        
        List(viewModel.drawableItems) { drawableItem in
            Text("Hello, world!")
                .padding()
            Text(viewModel.testString)
                .padding()
            HStack {
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
                
            }
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
