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
        
        List {
            Text("Hello, world!")
                .padding()
            Text(viewModel.testString)
                .padding()
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
