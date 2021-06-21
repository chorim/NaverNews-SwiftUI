//
//  DetailView.swift
//  NaverNews-SwiftUI
//
//  Created by Insu Byeon on 2021/06/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
  // @State
  var feed: Feed
  
  init(with feed: Feed) {
    self.feed = feed
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        AnimatedImage(url: feed.imageURL)
          .resizable()
          .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 300,
            maxHeight: .infinity,
            alignment: .topLeading
          )
        VStack(alignment: .leading, spacing: 20.0) {
          Text(feed.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .lineLimit(1)
          
          Text(feed.content)
            .fontWeight(.medium)
          
          Text(feed.author + " - " + feed.date)
        }
      }
      .padding(.horizontal, 15.0)
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(
      with: .init(
        imageURL: URL(string: "https://i.pinimg.com/originals/3c/3b/86/3c3b86664b973d350a8c9013f4ac77d7.png")!,
        title: "어몽어스 아이콘 두줄두줄두줄두줄두줄두줄두줄두줄",
        content: "귀여운 어몽어스 아이콘입니다.\n투명한 이미지입니다.",
        author: "Insu Byeon",
        date: "2020.06.18"
      )
    )
  }
}
