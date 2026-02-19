import Foundation

final class InMemoryBookRepository: BookRepositoryProtocol {
    private var books: [Book] = []

    func add(_ book: Book) throws {
        books.append(book)
    }

    func delete(id: UUID) throws {
        guard let idx = books.firstIndex(where: { $0.id == id }) else {
            throw LibraryError.notFound(id: id.uuidString)
        }
        books.remove(at: idx)
    }

    func list() -> [Book] {
        return books
    }

    func findById(_ id: UUID) -> Book? {
        return books.first(where: { $0.id == id })
    }
}
