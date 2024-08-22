//
//  QuestionAnalyticsEvents.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 8/21/24.
//

// MARK: - QuestionEvents

enum QuestionEvents: AnalyticsEvent {
    case questionView
    
    var eventName: AnalyticsConstants.EventName {
        switch self {
        case .questionView:
            return AnalyticsConstants.EventName.screenView
        }
    }
    
    var eventType: AnalyticsConstants.EventType {
        switch self {
        case .questionView:
            return AnalyticsConstants.EventType.screenView
        }
    }
    
    var parameters: [AnalyticsConstants.Parameter: Any]? {
        switch self {
        case .questionView: [
                .screenId: QuestionScreen.questionView.screenId,
                .screenName: QuestionScreen.questionView.screenName,
                .screenClass: QuestionScreen.questionView.screenClass
            ]
        }
    }
}

// MARK: - QuestionScreen

enum QuestionScreen {
    case questionView
    
    var screenId: String {
        switch self {
        case .questionView:
            return "question_view"
        }
    }
    
    var screenName: String {
        switch self {
        case .questionView:
            return "문의하기 화면"
        }
    }
    
    var screenClass: String {
        switch self {
        case .questionView:
            return "InquiryView"
        }
    }
}
