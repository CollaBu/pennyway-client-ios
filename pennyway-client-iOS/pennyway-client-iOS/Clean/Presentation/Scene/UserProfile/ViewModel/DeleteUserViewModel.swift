//
//  DeleteUserViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 9/27/24.
//

import Foundation

// MARK: - DeleteUserViewModelInput

protocol DeleteUserViewModelInput {
    func deleteUserAccount(completion: @escaping (Bool) -> Void)
}

// MARK: - DeleteUserViewModelOutput

protocol DeleteUserViewModelOutput {}

// MARK: - DeleteUserViewModel

protocol DeleteUserViewModel: DeleteUserViewModelInput, DeleteUserViewModelOutput {}

// MARK: - DefaultDeleteUserViewModel

class DefaultDeleteUserViewModel: DeleteUserViewModel {
    private let deleteUseCase: DeleteUserAccountUseCase

    init(deleteUseCase: DeleteUserAccountUseCase) {
        self.deleteUseCase = deleteUseCase
    }

    func deleteUserAccount(completion: @escaping (Bool) -> Void) {
        deleteUseCase.execute(completion: completion)
    }
}
