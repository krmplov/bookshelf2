import Foundation

enum LibraryError: Error, LocalizedError {
    case emptyTitle
    case emptyAuthor
    case invalidYear(Int)
    case notFound(id: String)
    case duplicateId(String)

    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "Название не может быть пустым"
        case .emptyAuthor: return "Автор не может быть пустым"
        case .invalidYear(let y): return "Некорректный год: \(y)"
        case .notFound(let id): return "Книга с id \(id) не найдена"
        case .duplicateId(let id): return "Книга с id \(id) уже существует"
        }
    }
}
