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
  }
  
  var body: some View {
    NavigationView {
      if #available(iOS 14.0, *) {
        ScrollView {
          LazyVStack {
            ForEach(viewModel.dataSource, id: \.id) { feed in
              NavigationLink(destination: DetailView(with: feed)) {
                MainRow(feed: feed)
                  .padding(.horizontal, 20.0)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
        }
        .navigationBarTitle("NaverNews", displayMode: .large)
      } else {
        List {
          ForEach(viewModel.dataSource, id: \.id) { feed in
            NavigationLink(destination: DetailView(with: feed)) {
              MainRow(feed: feed)
                .padding(.horizontal, 20.0)
                .listRowInsets(EdgeInsets())
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
        .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
        .navigationBarTitle("NaverNews", displayMode: .large)
      }
      
    }
    .onAppear(perform: viewModel.fetchRelay)
  }
  
  
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(viewModel: .init(service: DefaultMainService()))
  }
}

