//
//  ContentView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = MainViewModel()
    var body: some View {
        Text("Hello, world!")
            .padding()
        Text(viewModel.testString)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
