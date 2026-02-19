import Foundation

class BookShelfService : BookShelfProtocol {
    private let repo: BookRepositoryProtocol
    
    init(repo: BookRepositoryProtocol) {
        self.repo = repo
    }
    
    
    func add(book: Book) throws {
        if book.title.isEmpty {
            throw LibraryError.emptyTitle
        }
        
        if book.author.isEmpty {
            throw LibraryError.emptyAuthor
        }
        
        if let year = book.publicationYear {
            let currentYear = Calendar.current.component(.year, from: Date())
            if year < 1400 || year > currentYear {
                throw LibraryError.invalidYear(year)
            }
        }
        
        if repo.findById(book.id) != nil {
            throw LibraryError.duplicateId(book.id.uuidString)
        }

        try repo.add(book)
    }
    
    func delete(id: UUID) throws {
        try repo.delete(id: id)
    }
    
    func list() -> [Book] {
        repo.list()
    }
    
    func search(query: SearchQuery) -> [Book] {
        let books = repo.list()
        
        switch query {
        case .title(let text):
            let q = text.lowercased()
            return books.filter { $0.title.lowercased() == q }
        case .author(let text):
            let q = text.lowercased()
            return books.filter { $0.author.lowercased() == q }
        case .genre(let g):
            return books.filter { $0.genre == g }
            
        case .publicationYear(let y):
            return books.filter { $0.publicationYear == y }
            
        case .tag(let text):
            let q = text.lowercased()
            return books.filter {
                book in book.tags.contains(where: { $0.lowercased() == q })
            }
        }
    }
}
