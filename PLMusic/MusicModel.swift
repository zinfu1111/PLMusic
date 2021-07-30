//
//  MusicModel.swift
//  PLMusic
//
//  Created by 連振甫 on 2021/7/30.
//

import Foundation

struct SearchResonse: Codable{
    let resultCount: Int
    let results: [Music]
}

struct Music: Codable {
    let artistName: String?
    let collectionCensoredName: String?
    let trackName: String
    let artistViewUrl: URL?
    let collectionViewUrl: URL
    let previewUrl: URL
    let artworkUrl100: URL
    let trackPrice: Double?
}

class DataManager {
    
    static let shared = DataManager()
    
    
    func fetchMusic(completeHandler: @escaping ([Music])->Void) {
        if let urlStr = "https://itunes.apple.com/search?term=蔡依林&media=music".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr){
                URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
                    
                    guard let self = self else {return}
                    
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let searchResonse = try decoder.decode(SearchResonse.self, from: data)
                            
                            completeHandler(searchResonse.results)
                        }
                        catch {
                            print("error",error)
                        }
                    }
                }.resume()
        }
    }
}
