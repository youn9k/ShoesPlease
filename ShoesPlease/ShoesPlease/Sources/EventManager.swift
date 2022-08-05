//
//  EventManager.swift
//  ShoesPlease
//
//  Created by YoungK on 2022/08/05.
//

import Foundation
import EventKit

class EventManager {
    static let instance = EventManager()
    
    func isAccessPermission(store: EKEventStore) -> Bool {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            store.requestAccess(to: .event) { status, error in
                if !status {
                    print(#fileID, #function, #line, error?.localizedDescription)
                }
            }
        case .restricted:
            print(#fileID, #function, #line, "restricted")
            return false
        case .denied:
            print(#fileID, #function, #line, "denied")
            return false
        case .authorized:
            return true
        default:
            print(#fileID, #function, #line, "unknown")
            return false
        }
        return false
    }
    
    func addEvent(startDate: Date, eventName: String) {
        let eventStore = EKEventStore()
        
        if isAccessPermission(store: eventStore) {
            let calendars = eventStore.calendars(for: .event)
            for calendar in calendars {
                if calendar.title == "캘린더" {
                    let event = EKEvent(eventStore: eventStore)
                    event.calendar = calendar
                    event.startDate = startDate
                    event.title = eventName
                    event.endDate = event.startDate.addingTimeInterval(3600)// 1 hours
                    let reminder1 = EKAlarm(relativeOffset: 0)
                    event.alarms = [reminder1]
                    do {
                        try eventStore.save(event, span: .thisEvent)
                        print("이벤트가 등록되었습니다.")
                    } catch {
                        print(#fileID, #function, #line, error.localizedDescription)
                    }
                }
            }
        } else {
            print("권한이 거부됨")
        }
    }
    
}
