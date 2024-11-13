//
//  ChatHistoryBinaryList.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/13/24.
//

import Foundation

// MARK: - ChatHistoryDelegate

protocol ChatHistoryDelegate: AnyObject {
    /// 새로운 메시지가 추가되었을 때 호출
    func didAddChatHistory(_ messages: [MessageItemModel])
    
    /// 메시지가 업데이트되었을 때 호출
    func didAddChatHistories(_ messages: [MessageItemModel])
}

// MARK: - ChatHistoryList

protocol ChatHistoryList: AnyObject {
    var delegate: ChatHistoryDelegate? { get set }
    
    func insert(_ message: MessageItemModel)
    func insertMessages(_ messages: [MessageItemModel])
    func getAllMessages() -> [MessageItemModel]
}

// MARK: - ChatHistoryBinaryList

final class ChatHistoryBinaryList: ChatHistoryList {
    /// 상태 변경을 수신할 delegate
    weak var delegate: ChatHistoryDelegate?
    
    /// 정렬된 상태로 저장되는 메시지 배열
    private var messages: [MessageItemModel] = []
    
    /// 스레드 안전성을 위한 직렬 큐
    private let queue = DispatchQueue(label: "com.app.chat.history")
    
    func insert(_ message: MessageItemModel) {
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            let index = self.findInsertionIndex(for: message)
            guard index >= self.messages.count || self.messages[index].chatId != message.chatId else {
                return
            }
            
            self.messages.insert(message, at: index)
            
            DispatchQueue.main.async {
                self.delegate?.didAddChatHistory([message])
            }
        }
    }
    
    func insertMessages(_ messages: [MessageItemModel]) {
        guard !messages.isEmpty else {
            return
        }
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            let sortedMessages = messages.sorted(by: { $0.chatId > $1.chatId })
            
            if self.messages.isEmpty {
                self.messages = sortedMessages
            } else {
                self.messages = self.mergeSortedArrays(self.messages, sortedMessages)
            }
            
            DispatchQueue.main.async {
                self.delegate?.didAddChatHistories(sortedMessages)
            }
        }
    }
    
    func getAllMessages() -> [MessageItemModel] {
        queue.sync { messages }
    }
    
    // MARK: - Private Methods
    
    /// 이진 탐색으로 삽입 위치 찾기
    private func findInsertionIndex(for message: MessageItemModel) -> Int {
        var low = 0
        var high = messages.count
        
        while low < high {
            let mid = (low + high) / 2
            if messages[mid].chatId < message.chatId {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
    
    /// 정렬된 두 배열 병합
    private func mergeSortedArrays(_ array1: [MessageItemModel], _ array2: [MessageItemModel]) -> [MessageItemModel] {
        var result: [MessageItemModel] = [] 
        var index1 = 0
        var index2 = 0
        
        while index1 < array1.count && index2 < array2.count {
            if array1[index1].chatId < array2[index2].chatId {
                result.append(array1[index1])
                index1 += 1
            } else if array1[index1].chatId > array2[index2].chatId {
                result.append(array2[index2])
                index2 += 1
            } else {
                result.append(array1[index1])
                index1 += 1
                index2 += 1
            }
        }
        
        result.append(contentsOf: array1[index1...])
        result.append(contentsOf: array2[index2...])
        
        return result
    }
}
