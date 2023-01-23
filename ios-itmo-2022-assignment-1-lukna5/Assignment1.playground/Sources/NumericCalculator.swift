import Foundation

private enum Token {
    case int, double, left, right, unar, op, end
}

enum parseErrors:Error{
    case tryToTakeFromEmptyList
    case unexpectedSymb(symb:Character)
    case takeNonExistOpFromStack(op:String)
    case lostLeftBrack
    case nothingInBrackets
}


public class NumericCalculator<Number: Numeric & LosslessStringConvertible>: Calculator {
    private var operators: Dictionary<String, Operator<Number>>
    public required init(operators: Dictionary<String, Operator<Number>>) {
        self.operators = operators
    }
    typealias Num = Int
    private var text: String = ""
    private var pos: Int = 0
    private func lexemAnalyze(_ input: String) {
        text = input
        pos = 0
    }
    
    private func getChar(_ ind: Int) -> Character{
        return text[text.index(text.startIndex, offsetBy: ind)]
    }
    
    //Выдает некст токен в строковом представлении
    private func nextToken() throws -> (Token, String) {
        if (pos >= text.count){
            return (Token.end, "")
        }
        var s = text[text.index(text.startIndex, offsetBy: pos)]
        if "0"..."9" ~= s{
            var num = ""
            while(pos < text.count && "0"..."9" ~= s){
                num.append(s)
                pos += 1
                if pos < text.count {
                    s = getChar(pos)
                }
            }
            if (pos >= text.count || s != "."){
                return (Token.int, num)
            }
            
            num.append(".")
            pos += 1
            s = getChar(pos)
            while(pos < text.count && "0"..."9" ~= s){
                num.append(s)
                if pos < text.count {
                    s = getChar(pos)
                }
            }
            return (Token.double, num)
        } else if s == "-" {
            pos += 1
            return (Token.unar, "-")
        } else if s == "("{
            pos += 1
            return (Token.left, "(")
        } else if s == ")"{
            pos += 1
            return (Token.right, ")")
        } else if operators[String(s)] != nil{
            pos += 1
            return (Token.op, String(s))
        } else {
            //throw
            throw parseErrors.unexpectedSymb(symb: s)
        }
        
        
    }
    
    public func evaluate(_ input: String) throws -> Number {
        var opStack: [String] = []
        var numStack: [Number] = []
        text = input.replacingOccurrences(of: " ", with: "")
        pos = 0
        var isUnar = true
        var containsMinus = false
        if operators["-"] != nil{
            containsMinus = true
        }
        var (type, c) = try nextToken()
        eval: while type != Token.end {
            switch type {
            case Token.int, Token.double:
                //После числа не может быть унарный минус
                isUnar = false
                guard let num = Number(c) else {
                    return 0
                }
                //Если перед этим был унарный минус обработаем его
                guard let top = opStack.last else {
                    numStack.append(num)
                    break
                }
                if top != "unar"{
                    numStack.append(num)
                    break
                }
                opStack.removeLast()
                numStack.append(num * -1)
            case Token.unar:
                // Если минуса нет или это начало выражения то это точно унарный
                if !containsMinus || isUnar {
                    guard let top = opStack.last else {
                        opStack.append("unar")
                        break
                    }
                    let topIsUnar = top == "unar"
                    //Если на топе уарный минус то уберем его и брейкаем
                    if topIsUnar {
                        opStack.removeLast()
                        break
                    }
                    opStack.append("unar")
                } else {
                    fallthrough
                }
            case Token.op:
                isUnar = true
                // Если Нет операции или ( значит некуда спускать оператор
                if (opStack.isEmpty || opStack.last! == "("){
                    opStack.append(c)
                    break
                }

                var topV = opStack.last! // Символ топа стэка
                guard var top = operators[topV] else { // Операция топа стэка
                    throw parseErrors.takeNonExistOpFromStack(op: topV)
                }
                
                guard let cur = operators[c] else { // Операция текущего оператора
                    throw parseErrors.takeNonExistOpFromStack(op: c)
                }
                
                //Приорит больше значит брейк
                if top.precedence < cur.precedence  {
                    opStack.append(c)
                    break
                }
                
                //выкинем топ стэка, мы его и так уже помним
                opStack.removeLast()

                // Пока приоритет меньше обрабатываем операции
                while top.precedence > cur.precedence {
                    guard numStack.count >= 2 else {
                        throw parseErrors.tryToTakeFromEmptyList
                    }
                    let y = numStack.popLast()!
                    let x = numStack.popLast()!
                    numStack.append(try top.apply(x, y))
                    if opStack.isEmpty{
                        opStack.append(c)
                        continue eval
                    }
                    topV = opStack.popLast()!
                    guard let top1 = operators[topV] else {
                        throw parseErrors.tryToTakeFromEmptyList
                    }
                    top = top1
                }

                // Если приоритеты не равны -> наш приоритет уже больше и брейкаем
                if top.precedence != cur.precedence {
                    opStack.append(topV)
                    opStack.append(c)
                    break
                }
                // Раз тут -> приоритеты равны и учитывая ассоциативность решим что делать
                if cur.associativity != .right{
                    guard numStack.count >= 2 else {
                        throw parseErrors.tryToTakeFromEmptyList
                    }
                    let y = numStack.popLast()!
                    let x = numStack.popLast()!
                    numStack.append(try top.apply(x, y))
                    opStack.append(c)
                // Если правоассоц -> то операцию которую мы приняли нужно посчитать первей, поэтому будет считать это потом
                } else {
                    opStack.append(topV)
                    opStack.append(c)
                }
                //Обработаем типы ассоциативности
                //Создадим 2 аналогичных стэка и будем класть по элементу пока встречается такой же приоритет, извлекая эти элементы из изначальный стэков (чтобы посчитать и вернуть одно число)
//                print("Stacks")
//                printStacks(ops: opStack, nums: numStack)
//
//                var tempOps: [String] = [topV]
//                guard numStack.count >= 2 else {
//                    return 0
//                }
//                var y = numStack.popLast()!
//                var x = numStack.popLast()!
//                var tempNums: [Number] = [x, y]
//                while !opStack.isEmpty && top.precedence == cur.precedence {
//                    guard !numStack.isEmpty else {
//                        return 0
//                    }
//                    topV = opStack.popLast()!
//                    print(topV)
//                    tempOps.append(topV)
//                    tempNums.append(numStack.popLast()!)
//                }
//                printStacks(ops: tempOps, nums: tempNums)
//                print("OFFIng")
////                Извлекаем из временных стэков элемы и применяем функции в порядке зависящем от ассоциативности
//                while !tempOps.isEmpty {
//                    guard tempNums.count >= 2 else {
//                        print("What why < 2")
//                        return 0
//                    }
//                    if cur.associativity == .right {
//                        topV = tempOps.popLast()!
//                        y = tempNums.popLast()!
//                        x = tempNums.popLast()!
//                        tempNums.append(try top.apply(x, y)) // в конец
//                    } else {
//                        topV = tempOps.first!
//                        top = operators[topV]!
//                        print("what")
//                        tempOps.removeFirst()
//                        x = tempNums.first!
//                        tempNums.removeFirst()
//                        y = tempNums.first!
//                        tempNums.removeFirst()
//                        tempNums.insert(try top.apply(x, y), at: 0) // в начало
//                    }
//                }
//                opStack.append(c)
//                numStack.append(tempNums.popLast()!)
                
            case Token.left:
                isUnar = true
                opStack.append("(")
            case Token.right:
                //Идем влево пока не встретим "(", пока идем считаем что попадается
                isUnar = false
                guard var topV = opStack.popLast() else {
                    throw parseErrors.lostLeftBrack
                }
                guard var top = operators[topV] else{
                    // Выражение () считается чем-то странным поэтому ошибка
                    throw parseErrors.nothingInBrackets
                }
                while topV != "("{
                    guard let top1 = operators[topV] else{
                        throw parseErrors.takeNonExistOpFromStack(op: topV)
                    }
                    top = top1
                    guard numStack.count >= 2 else {
                        throw parseErrors.tryToTakeFromEmptyList
                    }
                    let y = numStack.popLast()!
                    let x = numStack.popLast()!
                    numStack.append(try top.apply(x, y))
                    guard let topV1 = opStack.popLast() else {
                        throw parseErrors.lostLeftBrack
                    }
                    topV = topV1
                }
                if opStack.isEmpty || opStack.last != "unar" {
                    break
                }
                
                guard numStack.count >= 1 else {
                    throw parseErrors.tryToTakeFromEmptyList
                }
                opStack.removeLast()
                numStack.append(numStack.popLast()! * -1)
            case .end:
                return 0
            }
            (type, c) = try nextToken()
        }
        
        //Обработка остатка стэка
        while !opStack.isEmpty{
            let topV = opStack.popLast()!
            guard let top = operators[topV] else{
                throw parseErrors.takeNonExistOpFromStack(op: topV)
            }
            guard numStack.count >= 2 else {
                throw parseErrors.tryToTakeFromEmptyList
            }
            let y = numStack.popLast()!
            let x = numStack.popLast()!
            numStack.append(try top.apply(x, y))
        }

        guard let res = numStack.popLast() else {
            throw parseErrors.tryToTakeFromEmptyList
        }
        return res
    }
    
    //вспомогательная функция для вывода стэка
    private func printStacks(ops: [String], nums: [Number]) {
        var opRes = "Ops -> "
        for op in ops{
            opRes += op
        }
        var numRes = "Nums -> "
        for num in nums{
            numRes += String(num) + " "
        }
        print(opRes)
        print(numRes)
    }
}
