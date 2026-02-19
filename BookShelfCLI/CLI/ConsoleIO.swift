struct ConsoleIO: IO {
    func write(_ text: String) { print(text) }
    func read() -> String? { readLine() }
}
