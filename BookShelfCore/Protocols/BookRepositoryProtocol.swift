import Foundation

protocol BookRepositoryProtocol {
    func add(_ book: Book) throws
    func delete(id: UUID) throws
    func list() -> [Book]
    func findById(_ id: UUID) -> Book?
}
