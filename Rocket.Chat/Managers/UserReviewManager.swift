//
//  UserReviewManager.swift
//  Rocket.Chat
//
//  Created by Augusto Falcão on 9/14/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation
import StoreKit

final class UserReviewManager {
    static let shared = UserReviewManager()

    private let nextDateForReviewKey: String = "kNextDateForReview"

    private let defaults = UserDefaults.standard

    private let week: TimeInterval = 604800

    private var nextDateForReview: Date {
        get {
            if let date = defaults.object(forKey: nextDateForReviewKey) as? Date {
                return date
            } else {
                let date = calculateNextDateForReview()
                defaults.set(date, forKey: nextDateForReviewKey)
                return date
            }
        }
        set(newDate) {
            defaults.set(newDate, forKey: nextDateForReviewKey)
        }
    }

    private var availableForReview: Bool {
        return nextDateForReview < Date()
    }

    private func calculateNextDateForReview() -> Date {
        return Date().addingTimeInterval(week)
    }

    @discardableResult
    func requestReview() -> Bool {
        if availableForReview {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }

            nextDateForReview = calculateNextDateForReview()
            return true
        }

        return false
    }
}
