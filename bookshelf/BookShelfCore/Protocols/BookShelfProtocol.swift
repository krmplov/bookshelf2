import Foundation

protocol BookShelfProtocol {
    func add(book: Book) throws
    func delete(id: UUID) throws
    func list() -> [Book]
    func search(query: SearchQuery) -> [Book]
}
