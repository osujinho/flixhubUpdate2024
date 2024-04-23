//
//  MovieDetailAboutData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/29/24.
//

import Foundation

enum MovieAboutData: MediaAboutData {
    
    case originalTitle
    case releaseDate
    case status
    case originalLanguage
    case spokenLanguages
    case awards
    case dvdReleaseDate
    case budget
    case boxOffice
    case revenue
    case productionCompanies
    case productionCountries
    
    var id: MovieAboutData { self }
    
    internal var description: String {
        switch self {
        case .originalTitle: return "Original Title"
        case .releaseDate: return "Release Date"
        case .originalLanguage: return "Original Language"
        case .spokenLanguages: return "Spoken language"
        case .awards: return "Awards"
        case .dvdReleaseDate: return "DVD Release Date"
        case .budget: return "Budget"
        case .boxOffice: return "Box Office"
        case .revenue: return "Revenue"
        case .productionCompanies: return "Production Companies"
        case .productionCountries: return "Production Countries"
        case .status: return "Status"
        }
    }
    
    static func labelItems(detail: TmdbMovieResponse?, omdb: OmdbMovieResponse?, aboutItems: [MovieAboutData]) -> [LabelGridItemData] {
        
        let items: [LabelGridItemData] = aboutItems.compactMap { aboutItem in
                switch aboutItem {
                case .originalTitle:
                    return LabelGridItemData(label: aboutItem.description, content: detail?.originalTitle)
                    
                case .releaseDate: return LabelGridItemData(label: aboutItem.description, content: GlobalMethods.formatDate(detail?.releaseDate, fullDate: true))
                    
                case .originalLanguage:
                    return LabelGridItemData(label: aboutItem.description, content: detail?.originalLanguage)
                    
                case .dvdReleaseDate:
                    return LabelGridItemData(label: aboutItem.description, content: omdb?.dvd)
                    
                case .budget:
                    return LabelGridItemData(label: aboutItem.description, content: GlobalMethods.formatMoney(amount: detail?.budget))
                    
                case .boxOffice:
                    return LabelGridItemData(label: aboutItem.description, content: omdb?.boxOffice)
                
                case .revenue:
                    return LabelGridItemData(label: aboutItem.description, content: GlobalMethods.formatMoney(amount: detail?.revenue))
                    
                case .status:
                    return LabelGridItemData(label: aboutItem.description, content: detail?.status)
                
                default:
                    return nil
                }
            }
            
            return items
    }
    
    static func labelArrayItem(detail: TmdbMovieResponse?, omdb: OmdbMovieResponse?, aboutItem: MovieAboutData) -> LabelGridItemArray? {
        switch aboutItem {
        case .spokenLanguages:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.spokenLanguages)
        
        case .awards:
            return LabelGridItemArray(label: aboutItem.description, items: GlobalMethods.formatAwards(awards: omdb?.awards))
        
        case .productionCompanies:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.companies)
        
        case .productionCountries:
            return LabelGridItemArray(label: aboutItem.description, items: detail?.countries)
        
        default:
            return nil
        }
    }
}
