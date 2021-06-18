//
//  MainRow.swift
//  NaverNews-SwiftUI
//
//  Created by Insu Byeon on 2021/06/18.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainRow: View {
  var feed: Feed
  
  var body: some View {
    HStack(spacing: 10.0) {
      AnimatedImage(url: feed.imageURL)
        .resizable()
        .frame(width: 100, height: 100)
      VStack(alignment: .leading) {
        Text(feed.title)
          .font(.title)
          .fontWeight(.bold)
          .lineLimit(1)
          .padding(.bottom, 5)
        Text(feed.content)
      }
    }
  }
}


struct MainRow_Previews: PreviewProvider {
  static var previews: some View {
    MainRow(
      feed: .init(
        imageURL: URL(string: "https://i.pinimg.com/originals/3c/3b/86/3c3b86664b973d350a8c9013f4ac77d7.png")!,
        title: "어몽어스 아이콘 두줄두줄두줄두줄두줄두줄두줄두줄",
        content: "귀여운 어몽어스 아이콘입니다.\n투명한 이미지입니다.",
        author: "Insu Byeon",
        date: "2020.06.18"
      )
    )
    .previewLayout(.fixed(width: 400, height: 100))
  }
}
