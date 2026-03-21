enum KeyboardMode: String, CaseIterable {
    case letter = "字母鍵盤"
    case numpad = "數字鍵盤"

    var label: String { rawValue }

    // J(38)↔U(32)  K(40)↔I(34)  L(37)↔O(31)
    // 4(21)↔1(18)  5(23)↔2(19)  6(22)↔3(20)
    var swapMap: [Int64: Int64] {
        switch self {
        case .letter:
            return [38: 32, 32: 38, 40: 34, 34: 40, 37: 31, 31: 37]
        case .numpad:
            return [21: 18, 18: 21, 23: 19, 19: 23, 22: 20, 20: 22]
        }
    }
}
