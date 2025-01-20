//
//  ChatHistoryListTest.swift
//  pennyway-client-iOSTests
//
//  Created by 최희진 on 11/13/24.
//

@testable import pennyway_client_iOS
import XCTest

// MARK: - MockChatHistoryDelegate

class MockChatHistoryDelegate: ChatHistoryDelegate {
    var onAdd: (([MessageItemModel]) -> Void)?

    func didAddChatHistory(_ messages: [MessageItemModel]) {
        onAdd?(messages)
    }

    func didAddChatHistories(_ messages: [MessageItemModel]) {
        onAdd?(messages)
    }
}

// MARK: - UserUnitTestTests

final class UserUnitTestTests: XCTestCase {
    private var sut: ChatHistoryBinaryList!
    private var mockDelegate: MockChatHistoryDelegate!

    override func setUp() {
        super.setUp()
        sut = ChatHistoryBinaryList()
        mockDelegate = MockChatHistoryDelegate()
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        mockDelegate = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Helper Methods

    /// 테스트용 메시지 생성
    private func createMessage(roomId: Int64 = 1, chatId: Int64, content: String = "test") -> MessageItemModel {
        return MessageItemModel(
            chatRoomId: roomId,
            chatId: chatId,
            content: content,
            contentType: .text,
            categoryType: .normal,
            createdAt: "2024-11-13 20:59:44",
            senderId: 1
        )
    }

    // MARK: - Basic Operation Tests

    /// 단일 메시지 삽입 테스트
    /// - 메시지가 정상적으로 저장되는지 확인
    /// - delegate에 정확한 이벤트가 전달되는지 확인
    /// - 저장된 메시지를 정상적으로 조회할 수 있는지 확인
    func testSingleMessageInsert() {
        // Given
        let message = createMessage(chatId: 1)
        let expectation = expectation(description: "Message insert")
        mockDelegate.onAdd = { messages in
            // Then
            XCTAssertEqual(messages.count, 1)
            XCTAssertEqual(messages[0].chatId, 1)
            expectation.fulfill()
        }

        // When
        sut.insert(message)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.getAllMessages().count, 1)
    }

    /// 중복 메시지 삽입 테스트
    /// - 동일한 chatId를 가진 메시지 삽입 시 처리 검증
    /// - 첫 번째 메시지만 유지되어야 함
    /// - delegate 이벤트가 한 번만 발생해야 함
    func testDuplicateMessageInsert() {
        // Given
        let message1 = createMessage(chatId: 1, content: "first")
        let message2 = createMessage(chatId: 1, content: "second")
        var eventCount = 0

        mockDelegate.onAdd = { _ in
            eventCount += 1
        }

        // When
        sut.insert(message1)
        sut.insert(message2)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(eventCount, 1)
            XCTAssertEqual(self.sut.getAllMessages().count, 1)
            XCTAssertEqual(self.sut.getAllMessages().first?.content, "first")
        }
    }

    // MARK: - Bulk Operation Tests

    /// 정렬되지 않은 메시지 일괄 삽입 테스트
    /// - 순서가 섞인 메시지들이 정렬되어 저장되는지 확인
    /// - delegate 이벤트가 정상적으로 발생하는지 확인
    func testUnorderedBulkInsert() {
        // Given
        let messages = [
            createMessage(chatId: 5),
            createMessage(chatId: 2),
            createMessage(chatId: 4),
            createMessage(chatId: 1),
            createMessage(chatId: 3)
        ]
        let expectation = expectation(description: "Bulk insert")

        mockDelegate.onAdd = { addedMessages in
            XCTAssertEqual(addedMessages.count, 5)
            XCTAssertEqual(addedMessages.map { $0.chatId }, [5, 4, 3, 2, 1])
            expectation.fulfill()
        }

        // When
        sut.insertMessages(messages)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.getAllMessages().map { $0.chatId }, [5, 4, 3, 2, 1])
    }

    // MARK: - Edge Cases Tests

    /// 경계값 테스트
    /// - 빈 배열 삽입
    /// - Int.min, Int.max chatId 처리
    /// - 범위를 벗어난 조회
    func testEdgeCases() {
        // Empty array insert
        sut.insertMessages([])
        XCTAssertTrue(sut.getAllMessages().isEmpty)

        // Extreme values
        let extremeMessages = [
            createMessage(chatId: Int64(Int.max)),
            createMessage(chatId: 0),
            createMessage(chatId: Int64(Int.min))
        ]
        sut.insertMessages(extremeMessages)
        XCTAssertEqual(sut.getAllMessages().count, 3)
        XCTAssertEqual(sut.getAllMessages().first?.chatId, Int64(Int.max))
        XCTAssertEqual(sut.getAllMessages().last?.chatId, Int64(Int.min))
    }

    // MARK: - Concurrency Tests

    /// 동시성 테스트
    /// - 여러 스레드에서 동시에 메시지 삽입
    /// - 데이터 일관성 검증
    /// - 정렬 상태 유지 확인
    func testConcurrentInserts() {
        // Given
        let messageCount = 100
        let expectation = self.expectation(description: "Concurrent inserts")
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)

        // When
        for i in 0 ..< messageCount {
            queue.async(group: dispatchGroup) {
                self.sut.insert(self.createMessage(chatId: Int64(i)))
            }
        }

        // Then
        dispatchGroup.notify(queue: .main) {
            let messages = self.sut.getAllMessages()
            XCTAssertEqual(messages.count, messageCount)

            // 정렬 확인
            for i in 0 ..< (messages.count - 1) {
                XCTAssertLessThan(messages[i].chatId, messages[i + 1].chatId)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    /// 동시성 스트레스 테스트
    /// - 단일 삽입과 일괄 삽입을 동시에 수행
    /// - 대량의 데이터로 성능과 안정성 검증
    /// - 메모리 누수 확인
    func testConcurrencyStress() {
        // Given
        let batchCount = 5
        let batchSize = 100
        let singleInsertCount = 50
        let expectation = self.expectation(description: "Stress test")
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "test.stress", attributes: .concurrent)

        // When
        // 배치 삽입
        for i in 0 ..< batchCount {
            queue.async(group: dispatchGroup) {
                let startId = i * batchSize
                let messages = (startId ..< (startId + batchSize)).map {
                    self.createMessage(chatId: Int64($0))
                }
                self.sut.insertMessages(messages)
            }
        }

        // 개별 삽입
        for i in 0 ..< singleInsertCount {
            queue.async(group: dispatchGroup) {
                let chatId = batchCount * batchSize + i
                self.sut.insert(self.createMessage(chatId: Int64(chatId)), false)
            }
        }

        // Then
        dispatchGroup.notify(queue: .main) {
            let messages = self.sut.getAllMessages()
            let expectedCount = (batchCount * batchSize) + singleInsertCount
            XCTAssertEqual(messages.count, expectedCount)

            // 정렬 및 중복 검증
            let chatIds = messages.map { $0.chatId }
            XCTAssertEqual(chatIds, Array(Set(chatIds)).sorted(by: >))

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
