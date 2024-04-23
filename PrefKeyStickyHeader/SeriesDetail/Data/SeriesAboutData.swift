//
//  SeriesAboutData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/20/24.
//

import Foundation

enum SeriesAboutData: MediaAboutData {
    
    case originalName
    case type
    case originalLanguage
    case spokenLanguages
    case firstAirDate
    case lastAirDate
    case totalSeasons
    case totalEpisodes
    case awards
    case originCountries
    case productionCompanies
    case productionCountries
    
    var id: SeriesAboutData { self }
    
    internal var description: String {
        switch self {
        case .originalName: return "Original Title"
        case .type: return "Series Type"
        case .originalLanguage: return "Original Language"
        case .spokenLanguages: return "Spoken language"
        case .firstAirDate: return "First Aired on"
        case .lastAirDate: return "Last Air Date"
        case .totalSeasons: return "Total Seasons"
        case .totalEpisodes: return "Total Episodes"
        case .awards: return "Awards"
        case .originCountries: return "Countries"
        case .productionCompanies: return "Production Companies"
        case .productionCountries: return "Production Countries"
        }
    }
    
    static func labelItems(detail: TmdbSeriesResponse?, omdb: OmdbSeriesResponse?, aboutItems: [SeriesAboutData]) -> [LabelGridItemData] {
        
        let items: [LabelGridItemData] = aboutItems.compactMap { aboutItem in
                switch aboutItem {
                case .originalName:
                    return LabelGridItemData(label: aboutItem.description, content: detail?.originalName)
                
                case .originalLanguage:
                    return LabelGridItemData(label: aboutItem.description, content: detail?.originalLanguage)
                
                case .type:
                    return LabelGridItemData(label: aboutItem.description, content: detail?.type)
                
                case .firstAirDate:
                    return LabelGridItemData(label: aboutItem.description, content: GlobalMethods.formatDate(detail?.firstAirDate, fullDate: true))
                
                case .lastAirDate:
                    return LabelGridItemData(label: aboutItem.description, content: GlobalMethods.formatDate(detail?.lastAirDate, fullDate: true))
                
                case .totalSeasons:
                    return LabelGridItemData(label: aboutItem.description, content: OptionalMethods.unwrapNumbersToString(detail?.totalSeasons))
                
                case .totalEpisodes:
                    return LabelGridItemData(label: aboutItem.description, content: OptionalMethods.unwrapNumbersToString(detail?.totalEpisodes))
                
                default:
                    return nil
                }
            }
            
            return items
    }
    
    static func labelArrayItem(detail: TmdbSeriesResponse?, omdb: OmdbSeriesResponse?, aboutItem: SeriesAboutData) -> LabelGridItemArray? {
        switch aboutItem {
        case .spokenLanguages:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.spokenLanguages)
        
        case .awards:
            return LabelGridItemArray(label: aboutItem.description, items: GlobalMethods.formatAwards(awards: omdb?.awards))
        
        case .originCountries:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.originCountry)
        
        case .productionCompanies:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.companies)
        
        case .productionCountries:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.countries)
        
        default:
            return nil
        }
    }
}
