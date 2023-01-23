import Foundation

/// Ассоциативность оператора
public enum Associativity {
    case left, right, none
}

/// Оператор
public struct Operator<T: Numeric> {
    public let precedence: Int
    public let associativity: Associativity
    private let function: (T, T) throws -> T
    
    /// Конструктор с параметрами
    /// - Parameters:
    ///   - precedence: приоритет
    ///   - associativity: ассоциативность
    ///   - function: вычислимая бинарная функция
    public init(precedence: Int, associativity: Associativity, function: @escaping (T, T) -> T) {
        self.precedence = precedence
        self.associativity = associativity
        self.function = function
    }
    
    /// Применить оператор
    /// - Parameters:
    ///   - lhs: первый аргумент
    ///   - rhs: второй аргумент
    /// - Returns: результат, либо исключение
    public func apply(_ lhs: T, _ rhs: T) throws -> T {
        try self.function(lhs, rhs)
    }
}

public let IntegerCalculator = NumericCalculator<Int>.self
public let RealCalculator = NumericCalculator<Double>.self

/// Калькулятор
public protocol Calculator<Number> {
    /// Тип чисел, с которыми работает данный калькулятор
    associatedtype Number: Numeric
    
    init(operators: Dictionary<String, Operator<Number>>)
    
    func evaluate(_ input: String) throws -> Number
}


