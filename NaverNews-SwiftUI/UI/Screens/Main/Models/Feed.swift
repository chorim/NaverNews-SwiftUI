//
//  Feed.swift
//  NaverNews-SwiftUI
//
//  Created by Insu Byeon on 2021/06/18.
//

import Foundation

struct Feed: Hashable {
  let id: UUID = .init()
  let imageURL: URL
  let title: String
  let content: String
  let author: String
  let date: String
}
