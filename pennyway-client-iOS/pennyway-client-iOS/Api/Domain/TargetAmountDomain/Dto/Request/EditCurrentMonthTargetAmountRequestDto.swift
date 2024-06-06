
public struct EditCurrentMonthTargetAmountRequestDto: Encodable {
    let amount: Int
  
    public init(
        amount: Int
    ) {
        self.amount = amount
    }
}

