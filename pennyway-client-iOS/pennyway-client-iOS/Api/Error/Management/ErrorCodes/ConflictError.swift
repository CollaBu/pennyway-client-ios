
enum ConflictError: String {
    case requestConflictWithResourceState = "4090"
    case resourceAlreadyExists = "4091"
    case concurrentModificationConflict = "4092"
}
