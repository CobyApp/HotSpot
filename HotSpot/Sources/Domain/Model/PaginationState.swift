import Foundation

struct PaginationState: Equatable {
    var currentPage: Int
    var isLastPage: Bool
    var isLoading: Bool
    
    init(currentPage: Int = 1, isLastPage: Bool = false, isLoading: Bool = false) {
        self.currentPage = currentPage
        self.isLastPage = isLastPage
        self.isLoading = isLoading
    }
    
    mutating func reset() {
        currentPage = 1
        isLastPage = false
        isLoading = false
    }
    
    mutating func update(isLastPage: Bool) {
        self.isLastPage = isLastPage
    }
    
    mutating func startLoading() {
        isLoading = true
    }
    
    mutating func finishLoading() {
        isLoading = false
    }
    
    mutating func incrementPage() {
        currentPage += 1
    }
} 