//
//  HappyRoseAPI.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/21/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import Foundation

final class HappyRoseAPI: NSObject {
    let service: Service
    
    convenience override init() {
        self.init(service: NetworkService())
    }
    
    init(service: Service) {
        self.service = service
    }
    
    func randomItemAsync(request: Requests = APIRequests.items, _ completion: @escaping (Result<Item>) -> Void) {
        allItemsAsync(request: request) { result in
            switch result {
            case .success(let items):
                guard items.count > 0 else {
                    completion(.error(APIError.noItems))
                    return
                }
                let index = Int(arc4random_uniform(UInt32(items.count)))
                completion(.success(items[index]))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func allItemsAsync(request: Requests = APIRequests.items, _ completion: @escaping (Result<[Item]>) -> Void) {
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let items: Items = try JSONDecoder().decode(Items.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(items.items))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.error(error))
                    }
                }
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }
    
    static func urlForPath(path: String) -> URL {
        return baseURL.appendingPathComponent(path)
    }
    
    static var baseURL: URL {
        return URL(string: "http://happy-rose.surge.sh/")!
    }
}

enum APIRequests: String, Requests {
    case items = "Items.json"
    
    var url: URL {
        return HappyRoseAPI.urlForPath(path: rawValue)
    }
}

enum APIError: Error {
    case noItems
}

// Only used for decoding
private struct Items: Codable {
    let items: [Item]
}
