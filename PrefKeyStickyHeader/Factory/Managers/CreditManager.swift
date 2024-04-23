//
//  CreditManager.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/13/24.
//

import Foundation

enum CreditManager {
    
    static private let desiredCrewJobs: Set<String> = ["producer", "creator", "director", "story", "executive producer", "screenplay", "writer"]
    
    static private let sortingOrder: [String] = ["creator", "director", "producer", "executive producer", "writer", "screenplay", "story"]
    
    static func organizeCredit<Credit: MovieAndSeriesCreditCollection>(responses: [Credit]?, creators: [CrewResponse]? = nil) -> [Credit]? {
        
        if let crews = responses as? [CrewResponse] {
            let combinedCrews = addCreatorToCrews(crews: crews, creators: creators)
            let desiredCrews = getDesiredCrew(crews: combinedCrews)
            let combinedRoles = combineRoles(responses: desiredCrews)
            let sortedCrews = sortCredit(responses: combinedRoles)
            return sortedCrews as? [Credit]
        }
        
        if let casts = responses as? [CastResponse] {
            let combinedRoles = combineRoles(responses: casts)
            let sortedCasts = sortCredit(responses: combinedRoles)
            return sortedCasts as? [Credit]
        }
        return nil
    }
    
    static private func addCreatorToCrews(crews: [CrewResponse]?, creators: [CrewResponse]?) -> [CrewResponse]? {
        
        guard let crews = crews else { return nil }
        guard let creators = creators else { return crews }
        
        var uniqueCreators = creators.filter { creator in
            !crews.contains { $0.id == creator.id && $0.name == creator.name && $0.job == creator.job }
        }
        
        uniqueCreators.append(contentsOf: crews)
        
        return uniqueCreators
    }

    static private func combineRoles<Credit: MovieAndSeriesCreditCollection>(responses: [Credit]?) -> [Credit]? {
        
        guard let responses = responses else { return nil }
        let groupedResponses = Dictionary(grouping: responses, by: { $0.id })
        
        let combinedResponses: [Credit?] = groupedResponses.map { (_, responseList) in
            // Sort the response list based on the sortingOrder
            let sortedResponseList = responseList.sorted { (response1, response2) -> Bool in
                guard let role1 = response1.role?.lowercased(), let role2 = response2.role?.lowercased() else { return false }
                guard let index1 = sortingOrder.firstIndex(of: role1), let index2 = sortingOrder.firstIndex(of: role2) else {
                    if sortingOrder.contains(role1) {
                        return true
                    } else if sortingOrder.contains(role2) {
                        return false
                    } else {
                        return role1 < role2
                    }
                }
                return index1 < index2
            }
            
            // Concatenate sorted roles/characters for each group of responses with the same ID
            let combinedRole = sortedResponseList.compactMap { $0.role }.joined(separator: ", ")
            
            // Create a new response using the first response as a reference
            if let firstCast = sortedResponseList.first as? CastResponse {
                return CastResponse(id: firstCast.id, name: firstCast.name, picture: firstCast.picture, character: combinedRole, order: firstCast.order) as? Credit
            } else if let firstCrew = sortedResponseList.first as? CrewResponse {
                return CrewResponse(id: firstCrew.id, name: firstCrew.name, picture: firstCrew.picture, job: combinedRole) as? Credit
            } else {
                return nil
            }
        }
        
        return combinedResponses as? [Credit]
    }

    static private func getDesiredCrew(crews: [CrewResponse]?) -> [CrewResponse]? {
        
        guard let crews = crews else { return nil }
        //let desiredCrewJobs: Set<String> = ["producer", "creator", "director", "story", "executive producer", "storyboard", "screenplay", "co-producer"]
        
        let filteredCrewResponses = crews.filter { crew in
            guard let job = crew.job?.lowercased() else { return false }
            return desiredCrewJobs.contains { desiredJob in
                job == desiredJob || job.contains(desiredJob + ",") || job.contains(", " + desiredJob)
            }
        }
        return filteredCrewResponses
    }

    static private func sortCredit<Credit: MovieAndSeriesCreditCollection>(responses: [Credit]?) -> [Credit]? {
        
        guard let responses = responses else { return nil }
        //let sortingOrder: [String] = ["creator", "director", "producer", "executive producer", "co-producer", "screenplay", "storyboard", "story"]
        
        if let crews = responses as? [CrewResponse] {
            let sortedCrews = crews.sorted { crew1, crew2 in
                guard let job1 = crew1.job?.lowercased(), let job2 = crew2.job?.lowercased() else {
                    return crew1.job != nil
                }
                
                // Extract the first word of each job
                let firstWord1 = job1.components(separatedBy: ",")[0].trimmingCharacters(in: .whitespaces)
                let firstWord2 = job2.components(separatedBy: ",")[0].trimmingCharacters(in: .whitespaces)
                
                guard let index1 = sortingOrder.firstIndex(where: { $0.contains(firstWord1) }),
                      let index2 = sortingOrder.firstIndex(where: { $0.contains(firstWord2) }) else {
                    // If either job is not in sortingOrder, handle it separately
                    if sortingOrder.contains(firstWord1) {
                        return true // Job 1 is in sortingOrder, so it should come before
                    } else if sortingOrder.contains(firstWord2) {
                        return false // Job 2 is in sortingOrder, so it should come before
                    } else {
                        return job1 < job2 // Neither job is in sortingOrder, use default string comparison
                    }
                }
                
                if index1 == index2 {
                    // If jobs are identical, prioritize CrewResponses with non-nil pictures
                    if crew1.picture != nil && crew2.picture == nil {
                        return true
                    } else if crew1.picture == nil && crew2.picture != nil {
                        return false
                    }
                }
                
                // If both jobs are compound roles, compare the first words using sorting order
                return index1 < index2
            }
            return sortedCrews as? [Credit]
        }
        
        if let casts = responses as? [CastResponse] {
            let sortedCast = casts.sorted { cast1, cast2 in
                
                guard let order1 = cast1.order, let order2 = cast2.order else { return cast1.order != nil }
                
                return order1 < order2
            }
            return sortedCast as? [Credit]
        }
        return responses
    }
    
    static func mergeKnownCredits<Credit: PersonCreditCollection>(_ responses: [Credit]?) -> [Credit]? {
        
        guard let responses = responses, !responses.isEmpty else { return responses }
        let groupedResponses = Dictionary(grouping: responses, by: { $0.id })
        
        let combinedResponses: [Credit?] = groupedResponses.map { (_, responseList) in
            
            let combinedRole = responseList.compactMap { $0.role }.joined(separator: ", ")
            guard let firstResponse = responseList.first else { return nil }
            
            switch firstResponse {
            case let castMovie as PersonCastMovie:
                return PersonCastMovie(id: castMovie.id, genreIds: castMovie.genreIds, poster: castMovie.poster, rating: castMovie.rating, mediaType: castMovie.mediaType, title: castMovie.title, releaseDate: castMovie.releaseDate, character: combinedRole) as? Credit

            case let castSeries as PersonCastSeries:
                return PersonCastSeries(id: castSeries.id, genreIds: castSeries.genreIds, poster: castSeries.poster, rating: castSeries.rating, mediaType: castSeries.mediaType, name: castSeries.name, firstAirDate: castSeries.firstAirDate, character: combinedRole) as? Credit

            case let crewMovie as PersonCrewMovie:
                return PersonCrewMovie(id: crewMovie.id, genreIds: crewMovie.genreIds, poster: crewMovie.poster, rating: crewMovie.rating, mediaType: crewMovie.mediaType, title: crewMovie.title, releaseDate: crewMovie.releaseDate, job: combinedRole) as? Credit

            case let crewSeries as PersonCrewSeries:
                return PersonCrewSeries(id: crewSeries.id, genreIds: crewSeries.genreIds, poster: crewSeries.poster, rating: crewSeries.rating, mediaType: crewSeries.mediaType, name: crewSeries.name, firstAirDate: crewSeries.firstAirDate, job: combinedRole) as? Credit

            default:
                return nil
            }
        }
        
        return combinedResponses as? [Credit]
    }
}
