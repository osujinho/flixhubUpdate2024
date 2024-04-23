//
//  RapidMovieResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/21/24.
//

import Foundation

typealias RapidMovieSteamingData = RapidMovieResponse.ResponseResult.CountryStreamingInfo

struct RapidMovieResponse: Codable {
    let result: [ResponseResult.CountryStreamingInfo]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try? container.decode(ResponseResult.self, forKey: .result).getCountryProviders(for: "us")
    }
    
    struct ResponseResult: Codable {
        let streamingInfo: [String: [CountryStreamingInfo]]?
        
        func getCountryProviders(for country: String) -> [CountryStreamingInfo]? {
            return streamingInfo?[country]
        }
        
        struct CountryStreamingInfo: Hashable, Codable {
            let service: String?
            let streamingType: String?
            let quality: String?
            let link: String?
            let videoLink: String?
            let price: String
            let availableSince: Int?
            
            init(from decoder: Decoder) throws {
                let container: KeyedDecodingContainer<RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys> = try decoder.container(keyedBy: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.self)
                self.service = try container.decodeIfPresent(String.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.service)
                self.streamingType = try container.decodeIfPresent(String.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.streamingType)
                self.quality = try container.decodeIfPresent(String.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.quality)
                self.link = try container.decodeIfPresent(String.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.link)
                self.videoLink = try container.decodeIfPresent(String.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.videoLink)
                self.availableSince = try container.decodeIfPresent(Int.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.availableSince)
                
                // Decode price into formatted price
                let priceResponse = try container.decodeIfPresent(RapidMovieResponse.ResponseResult.CountryStreamingInfo.Price.self, forKey: RapidMovieResponse.ResponseResult.CountryStreamingInfo.CodingKeys.price)
                self.price = getPrice(price: priceResponse)
                
                
                func getPrice(price: RapidMovieResponse.ResponseResult.CountryStreamingInfo.Price?) -> String {
                    guard let price = price else { return GlobalValues.defaultWrappedString }
                    if let currency = price.currency, let amount = price.amount, currency.lowercased() == "usd" {
                        return "$\(amount)"
                    } else {
                        return price.formatted ?? price.amount ?? GlobalValues.defaultWrappedString
                    }
                }
            }
            
            struct Price: Hashable, Codable {
                let amount: String?
                let currency: String?
                let formatted: String?
            }
        }
    }
}
