//
//  PersonDetailViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/28/24.
//

import Foundation

@MainActor
class PersonDetailViewModel: ObservableObject {
    
    @Published private(set) var personDetail: PersonResponse?
    @Published var hasError: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var isLoading: Bool = false
    
    @Published var personDetailOption: PersonDetailOptions? = .about
    
    let alertTitle: String = "Error Loading Person Details"
    var service: PersonServiceable
    
    init(service: PersonServiceable, personId: Int) {
        self.service = service
        
        Task {
            self.personDetail = await loadPersonDetail(personId: personId)
        }
    }
    
    func loadPersonDetail(personId: Int) async -> PersonResponse? {
        
        guard !isLoading else { return nil }
        self.isLoading = true
        self.hasError = false
        self.errorMessage = ""
        
        do {
            let response: PersonResponse = try await service.getPersonDetail(id: personId)
            self.isLoading = false
            return response
            
        } catch {
            self.errorMessage = RequestError.getMessage(error: error)
            self.isLoading = false
            self.hasError = true
            return nil
        }
    }
}
