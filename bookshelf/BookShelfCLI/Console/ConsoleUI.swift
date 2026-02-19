import Foundation

final class ConsoleUI {
    private let shelf: BookShelfProtocol
    private let io: IO

    init(shelf: BookShelfProtocol, io: IO = ConsoleIO()) {
        self.shelf = shelf
        self.io = io
    }

    func run() {
        while true {
            printMenu()
            let cmd = io.read() ?? ""

            switch cmd {
            case "1":
                add()
            case "2":
                delete()
            case "3":
                list()
            case "4":
                search()
            case "5":
                io.write("Выход")
                return
            default:
                io.write("Неизвестная команда")
            }
        }
    }
    
    private func printMenu() {
        io.write(
            """

            1.) Добавить книгу
            2.) Удалить книгу по ID
            3.) Список книг
            4.) Поиск по фильтрам
            5.) Выход
            """
        )
    }
    
    private func printBooks(books: [Book]) {
        if books.isEmpty {
            io.write("Пусто")
            return
        }
        
        for book in books {
            let year = book.publicationYear.map(\.description) ?? "неизвестно"
            let tags = book.tags.isEmpty
            ? "нет"
            : book.tags.joined(separator: ", ")
            
            io.write("""
                id: \(book.id.uuidString)
                title: \(book.title)
                author: \(book.author)
                year: \(year)
                genre: \(book.genre.rawValue)
                tags: \(tags)
                """
                  )
        }
    }

    private func add() {
        io.write("Введите название книги:")
        let title = io.read() ?? ""
        
        io.write("Введите автора книги:")
        let author = io.read() ?? ""
        
        io.write("Введите год издания книги (или нажмите Enter, если неизвестно):")
        let yearInput = io.read() ?? ""
        let year: Int? = yearInput.isEmpty ? nil : Int(yearInput)
        
        var chosenGenre: Genre? = nil
        
        io.write("Жанры")
        for (i, g) in Genre.allCases.enumerated() {
            io.write("\(i + 1)) \(g.rawValue)")
        }
        while chosenGenre == nil {
            io.write("Введите номер жанра:")
            let number = Int(io.read() ?? "")
            
            if number == nil {
                io.write("Нужно ввести число")
                continue
            }else if number! < 1 || number! > Genre.allCases.count {
                io.write("Номер вне диапазона")
                continue
            } else {
                chosenGenre = Genre.allCases[number! - 1]
            }
        }
        
        io.write("Введите теги через запятую:")
        let tagsInput = io.read() ?? ""
        let tags: [String] = tagsInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }.map{ $0.capitalized }
        
        let newBook = Book(
            id: UUID(),
            title: title,
            author: author,
            publicationYear: year,
            genre: chosenGenre!,
            tags: tags
        )
                
        do {
            try shelf.add(book: newBook)
            io.write("Книга добавлена")
        } catch let error as LibraryError {
            io.write(error.errorDescription ?? "Неизвестная ошибка")
        } catch {
            io.write("Ошибка: \(error)")
        }
    }
    private func delete() {
        var id: UUID? = nil
        while id == nil {
            io.write("Ввудите id книги:")
            let idString = io.read() ?? ""
            
            if let parseId = UUID(uuidString: idString) {
                id = parseId
            } else {
                io.write("Неверный формат ввода UUID")
            }
            
        }
        
        do {
            try shelf.delete(id: id!)
            io.write("Книга удалена")
        } catch let error as LibraryError {
            io.write(error.errorDescription ?? "Неизвестная ошибка")
        } catch {
            io.write("Ошибка: \(error)")
        }
    }
    private func list() {
        printBooks(books: shelf.list())
    }
    private func search() {
        io.write("""
            Варианты фильтрации:
            1.) Название
            2.) Автор
            3.) Жанр
            4.) Тег
            5.) Год
            """)
        let filterTypeInput = io.read() ?? ""
        switch filterTypeInput {
        case "1":
            io.write("Введите название книги:")
            let q = io.read() ?? ""
            printBooks(books: shelf.search(query: .title(q)))
            
        case "2":
            io.write("Ввeдите имя автора")
            let q = io.read() ?? ""
            printBooks(books: shelf.search(query: .author(q)))
            
        case "3":
            var chosenGenre: Genre? = nil
            
            io.write("Жанры")
            for (i, g) in Genre.allCases.enumerated() {
                io.write("\(i + 1)) \(g.rawValue)")
            }
            while chosenGenre == nil {
                io.write("Введите номер жанра:")
                let number = Int(io.read() ?? "")
                
                if number == nil {
                    io.write("Нужно ввести число")
                    continue
                }else if number! < 1 || number! > Genre.allCases.count {
                    io.write("Номер вне диапазона")
                    continue
                } else {
                    chosenGenre = Genre.allCases[number! - 1]
                }
            }
            
            printBooks(books: shelf.search(query: .genre(chosenGenre!)))
            
        case "4":
            io.write("Введите тег:")
            let q = io.read() ?? ""
            printBooks(books: shelf.search(query: .tag(q)))
            
        case "5":
            io.write("Введите год:")
            let yearInput = io.read() ?? ""
            let year: Int? = yearInput.isEmpty ? nil : Int(yearInput)
            
            printBooks(books: shelf.search(query: .publicationYear(year)))
            
        default :
            io.write("Неизвестный вариант")
        }
        
    }
}
