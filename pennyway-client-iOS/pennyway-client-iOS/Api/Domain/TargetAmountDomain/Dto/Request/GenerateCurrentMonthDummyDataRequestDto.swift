

public struct GenerateCurrentMonthDummyDataRequestDto: Encodable {
    let year: Int
    let month: Int
  
    public init(
        year: Int,
        month: Int
     
    ) {
        self.year = year
        self.month = month
    }
}

