//
//  PaginationManager.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/4/24.
//

import Foundation

struct PaginationManager {
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    var uniqueIds: Set<Int> = []
    
    var canLoadMore: Bool {
        currentPage <= totalPages
    }
    
    mutating func reset() {
        currentPage = 1
        totalPages = 1
        uniqueIds = []
    }
    
    func loadMoreIfNeeded<Item: MediaCollection>(
        currentItem item: Item?,
        threshold: Int = 5,
        items: [Item],
        fetchMore: @escaping () async -> Void
    ) async {
        
        guard let item = item else { return }
        let thresholdIndex = computeThresholdIndex(items: items)
        
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            await fetchMore()
        }
    }
    
    mutating func updateResults<Results: MediaCollection>(
        _ results: [Results]?,
        totalPages: Int?, resultContainerIsEmpty: Bool
    ) -> [Results] {
        
        guard let results = results else { return [] }
        
        if let totalPages = totalPages, resultContainerIsEmpty {
            self.totalPages = totalPages
        }
        currentPage += 1
        
        let newResults = results.filter { !uniqueIds.contains($0.id) }
        uniqueIds.formUnion(newResults.map { $0.id })
        
        return newResults
    }
    
    private func computeThresholdIndex<Results: MediaCollection>(items: [Results]) -> Int {
        
        let count = items.count
        
        switch count {
        case 0: return 0
        case 1...5: return count - 1
        case 6...10: return count - 2
        case 11...15: return count - 3
        default: return count - 5
        }
    }
}
