import Foundation


let repo: BookRepositoryProtocol = InMemoryBookRepository()
let shelf: BookShelfProtocol = BookShelfService(repo: repo)
let ui = ConsoleUI(shelf: shelf)
ui.run()
