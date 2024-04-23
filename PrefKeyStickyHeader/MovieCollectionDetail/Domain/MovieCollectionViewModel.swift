//
//  MovieCollectionViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import Foundation

@MainActor
class MovieCollectionViewModel: ObservableObject {
    
    @Published private(set) var collectionDetail: MovieCollectionResponse?
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String = ""
    let alertTitle: String = "Error Loading Movie Collection Details"
    
    @Published var movieCollectionOption: MovieCollectionOption? = .collection
    var service: MovieCollectionServiceable
    
    init(service: MovieCollectionServiceable, collectionId: Int) {
        self.service = service
        
        Task {
            self.collectionDetail = await fetchCollection(collectionId: collectionId)
        }
    }
    
    private func fetchCollection(collectionId: Int) async -> MovieCollectionResponse? {
        
        guard !isLoading else { return nil }
        self.isLoading = true
        self.hasError = false
        self.errorMessage = ""
        
        do {
            let response: MovieCollectionResponse = try await service.getBelongsToCollection(collectionId: collectionId)
            self.isLoading = false
            return response
            
        } catch {
            errorMessage = RequestError.getMessage(error: error)
            self.isLoading = false
            self.hasError = true
            return nil
        }
    }
}
