import Foundation

struct Book {
    let id: UUID
    var title: String
    var author: String
    var publicationYear: Int?
    var genre: Genre
    var tags: [String]
    
    init(id: UUID, title: String, author: String, publicationYear: Int? = nil, genre: Genre, tags: [String] = []) {
        self.id = id
        self.title = title
        self.author = author
        self.publicationYear = publicationYear
        self.genre = genre
        self.tags = tags
    }
}
