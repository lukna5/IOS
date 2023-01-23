import Cocoa

/*:
 
 # IOS @ ITMO 2022
 ## ДЗ №1
 ### Написать калькулятор
 1. Создать два типа IntegralCalculator и RealCalculator
 2. Поддержать для них протокол Calculator с типами Int и Double соответственно

 ### Бонус
 За удвоенные баллы:
 1. Поддержать унарный минус
 2. Поддержать скобки
 
 ### Критерии оценки
 0. Общая рациональность
 1. Корректность
 2. Красота и качество кода
*/



func test1(calculator type: (some Calculator<Int>).Type) {
    let calculator = type.init(operators: [
        "+": Operator(precedence: 10, associativity: .left, function: +),
        "-": Operator(precedence: 10, associativity: .right, function: -),
        "*": Operator(precedence: 20, associativity: .left, function: *),
        "/": Operator(precedence: 20, associativity: .left, function: /),
    ])

    let result1 = try! calculator.evaluate("-(-2+2*-5+8*-(5+4)) + ---4 * (5 - 3) / 8 - 41")
    print(result1)
    //assert(result1 == 20)
}

test1(calculator: IntegerCalculator)
