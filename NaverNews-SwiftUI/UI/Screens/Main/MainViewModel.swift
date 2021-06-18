//
//  MainViewModel.swift
//  NaverNews-SwiftUI
//
//  Created by Insu Byeon on 2021/06/18.
//

import Combine
import SwiftUI
import Alamofire
import SwiftSoup

// 복잡하게 안할거임
protocol MainService {
  
  func fetch() -> AnyPublisher<[Feed], Error>
}

final class DefaultMainService: MainService {
  func fetch() -> AnyPublisher<[Feed], Error> {
    return AF.request("https://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=105&sid2=731", method: .get)
      .validate()
      .publishData()
      .tryMap { result in
        if let error = result.error {
          throw error
        }
        
        guard let data = result.data else {
          throw NSError(domain: "Couldn't load data", code: 500, userInfo: nil)
        }
        guard let html = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))) else {
          throw NSError(domain: "Couldn't convert data to html", code: 500, userInfo: nil)
        }
        
        let doc: Document? = try? parse(html)
        
        let imageUrlElements: Elements? = try? doc?.body()?.select("dt.photo a img")
        let imageUrls = imageUrlElements?.map({ try! $0.attr("src") })
        let titleElements: Elements? = try? doc?.body()?.select(".list_body.newsflash_body ul li dl dt a")
        let titleTexts = titleElements?.map({ try! $0.text() }).filter({ !$0.isEmpty })
        let bodyElements: Elements? = try? doc?.body()?.select(".list_body.newsflash_body ul li dl dd span.lede")
        let bodyTexts = bodyElements?.map({ try! $0.text() }).filter({ !$0.isEmpty })
        let authorElements: Elements? = try? doc?.body()?.select(".list_body.newsflash_body ul li dl dd span.writing")
        let authorTexts = authorElements?.map({ try! $0.text() }).filter({ !$0.isEmpty })
        let dateElements: Elements? = try? doc?.body()?.select(".list_body.newsflash_body ul li dl dd span.date")
        let dateTexts = dateElements?.map({ try! $0.text() }).filter({ !$0.isEmpty })
        
        return (0..<imageUrls!.count)
          .map({
            Feed(
              imageURL: URL(string: imageUrls![$0])!,
              title: titleTexts![$0],
              content: bodyTexts![$0],
              author: authorTexts![$0],
              date: dateTexts![$0]
            )
          })
      }
      .mapError({ fatalError($0.localizedDescription) })
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

final class MainViewModel: ObservableObject, Identifiable {
  
  @Published var dataSource: [Feed] = []
  
  private var disposables = Set<AnyCancellable>()
  private let service: MainService
  
  init(service: MainService) {
    self.service = service
  }
  
  func fetchRelay() {
    service.fetch()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] value in
        guard let `self` = self else { return }
        switch value {
        case .failure(_):
          self.dataSource = []
        default: break
        }
      }, receiveValue: { [weak self] feeds in
        guard let `self` = self else { return }
        self.dataSource = feeds
      })
      .store(in: &disposables)
  }
  
}
