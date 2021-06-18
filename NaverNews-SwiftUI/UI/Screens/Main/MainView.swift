//
//  MainView.swift
//  NaverNews-SwiftUI
//
//  Created by Insu Byeon on 2021/06/18.
//

import SwiftUI
import Combine

struct MainView: View {
  
  @State var feeds: [Feed] = []
  
  @ObservedObject var viewModel: MainViewModel
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    if #available(iOS 14.0, *) {} else {
      UITableView.appearance().tableFooterView = UIView()
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.dataSource, id: \.id) {
            MainRow(feed: $0)
              .padding(.horizontal, 20.0)
          }
        }
      }
      .navigationBarTitle("NaverNews", displayMode: .large)
    }
    .onAppear(perform: viewModel.fetchRelay)
  }
  
  
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(viewModel: .init(service: DefaultMainService()))
  }
}
