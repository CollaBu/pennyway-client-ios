
public struct GetTotalTargetAmountRequestDto: Encodable {
    let date: String
  
    public init(
        date: String
     
    ) {
        self.date = date
    }
}

