//
//  ContentView.swift
//  NikeTheDrawNotiApp
//
//  Created by YoungK on 2022/04/18.
//

import SwiftUI

struct ContentView: View {
    var viewModel = MainViewModel()
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                viewModel.request(path: "/kr/launch?type=upcoming&activeDate=date-filter:AFTER")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
