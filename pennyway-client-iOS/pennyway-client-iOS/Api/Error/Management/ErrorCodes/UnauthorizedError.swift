
enum UnauthorizedError: String {
    case missingOrInvalidCredentials = "4010"
    case expiredOrRevokedToken = "4011"
    case insufficientPermissions = "4012"
    case tamperedOrMalformedToken = "4013"
}
