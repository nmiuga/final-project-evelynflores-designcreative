//
//  ContentView.swift
//  Final-Project
//
//  Created by Evelyn Flores on 4/22/26.
//

import SwiftUI

// MARK: - Color & Font Extensions
extension Color {
    static let accentYellow = Color(red: 254/255, green: 184/255, blue: 0/255)
    static let highlightYellow = Color(red: 255/255, green: 225/255, blue: 135/255)
    static let gridGray = Color(red: 217/255, green: 217/255, blue: 217/255)
    static let textBlack = Color.black
    static let textGray = Color(red: 139/255, green: 139/255, blue: 139/255)
    static let bgWhite = Color.white
}

extension Font {
    static func quicksand(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Quicksand", size: size, relativeTo: .body).weight(weight)
    }
}

// MARK: - Data Models
struct Assignment: Identifiable {
    let id = UUID()
    let name: String
    let isUrgent: Bool
}

struct ClassInfo: Identifiable {
    let id = UUID()
    let name: String
    let assignments: [[Assignment]] // Each inner array is a day’s assignments
}

// MARK: - Sample Data
let sampleClasses: [ClassInfo] = [
    ClassInfo(name: "Math", assignments: [
        [Assignment(name: "Homework 10.4", isUrgent: false), Assignment(name: "Quiz Ch. 10", isUrgent: true)],
        [Assignment(name: "Homework 10.5", isUrgent: false), Assignment(name: "Review notes", isUrgent: false)],
        [Assignment(name: "Study guide", isUrgent: false), Assignment(name: "Practice test", isUrgent: false)]
    ]),
    ClassInfo(name: "Biology", assignments: [
        [Assignment(name: "Lab Report", isUrgent: true), Assignment(name: "Flashcards", isUrgent: false)],
        [Assignment(name: "Diagram review", isUrgent: false)],
        [Assignment(name: "Read Ch. 8", isUrgent: false), Assignment(name: "Quiz prep", isUrgent: false)]
    ]),
    ClassInfo(name: "English", assignments: [
        [Assignment(name: "Vocabulary list", isUrgent: false)],
        [Assignment(name: "Essay Draft", isUrgent: false), Assignment(name: "Peer review", isUrgent: false)],
        [Assignment(name: "Poem Analysis", isUrgent: true), Assignment(name: "Journal entry", isUrgent: false)]
    ]),
    ClassInfo(name: "History", assignments: [
        [Assignment(name: "Notes", isUrgent: false), Assignment(name: "Timeline", isUrgent: false)],
        [Assignment(name: "Presentation", isUrgent: false)],
        [Assignment(name: "Document reading", isUrgent: false)]
    ]),
    ClassInfo(name: "Art", assignments: [
        [Assignment(name: "Warm-up sketch", isUrgent: false)],
        [Assignment(name: "Sketch #2", isUrgent: false), Assignment(name: "Materials prep", isUrgent: false)],
        [Assignment(name: "Portfolio", isUrgent: true)]
    ])
]

let weekDates: [(String, String)] = [
    ("Mon", "Apr 27"), ("Tue", "Apr 28"), ("Wed", "Apr 29")
]
let monthName = "April"

// MARK: - ContentView
struct ContentView: View {
    @State private var selectedDay: Int = 0 // Index into weekDates
    @Namespace private var anim
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.bgWhite.ignoresSafeArea()
            VStack(spacing: 0) {
                // Month
                Text(monthName)
                    .font(.quicksand(size: 24, weight: .bold))
                    .foregroundColor(.textBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.top, 20)
                Spacer()
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                // Day Row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<weekDates.count, id: \.self) { idx in
                            let (day, date) = weekDates[idx]
                            VStack(spacing: 4) {
                                Text(day)
                                    .font(.quicksand(size: 15, weight: .medium))
                                    .foregroundColor(.textBlack)
                                Text(date)
                                    .font(.quicksand(size: 15, weight: .medium))
                                    .foregroundColor(.textBlack)
                            }
                            .padding(8)
                            .background {
                                if idx == selectedDay {
                                    RoundedRectangle(cornerRadius: 8).fill(Color.highlightYellow)
                                        .matchedGeometryEffect(id: "selectedDay", in: anim)
                                }
                            }
                            .onTapGesture { selectedDay = idx }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)

                // Grid
                GeometryReader { geo in
                    let rowCount = sampleClasses.count
                    let cellHeight = geo.size.height / CGFloat(rowCount)
                    
                    VStack(spacing: 1) {
                        ForEach(Array(sampleClasses.enumerated()), id: \.element.id) { rowIdx, classInfo in
                            HStack(spacing: 0) {
                                // Class Name as vertical letters
                                VStack(spacing: 0) {
                                    ForEach(Array(classInfo.name), id: \.self) { letter in
                                        Text(String(letter))
                                            .font(.quicksand(size: 12, weight: .semibold))
                                            .foregroundColor(.textGray)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.vertical, 8)
                                .frame(width: 24, alignment: .center)
                                .background(Color.bgWhite)
                                
                                Divider().frame(width: 1).background(Color.gridGray)
                                
                                // Assignments for this class, this day
                                let assignments = classInfo.assignments[safe: selectedDay] ?? []
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(assignments) { assignment in
                                        AssignmentCell(assignment: assignment)
                                            .frame(maxWidth: .infinity)
                                            .onTapGesture {
                                                // Navigation to detail (to be implemented)
                                            }
                                    }
                                }
                                .padding(6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: cellHeight - 1)
                                .background(Color.bgWhite)
                            }
                            .frame(height: cellHeight)
                            if rowIdx != rowCount - 1 {
                                Divider().background(Color.gridGray)
                            }
                        }
                    }
                    .background(Color.bgWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gridGray, lineWidth: 2)
                    )
                    .padding([.horizontal, .bottom])
                }
                .padding(.top, 4)
            }
            // Floating Add Button
            Button(action: {
                // Add assignment action (to be implemented)
            }) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .font(.system(size: 28, weight: .bold))
                    .padding()
                    .background(Circle().fill(Color.accentYellow).shadow(radius: 4))
            }
            .padding(30)
        }
        // Swipe gesture
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -40, selectedDay < weekDates.count - 1 {
                        selectedDay += 1
                    } else if value.translation.width > 40, selectedDay > 0 {
                        selectedDay -= 1
                    }
                }
        )
    }
}

struct AssignmentCell: View {
    let assignment: Assignment
    var body: some View {
        Text(assignment.name)
            .font(.quicksand(size: 15, weight: .semibold))
            .foregroundColor(assignment.isUrgent ? .textBlack : .textGray)
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                assignment.isUrgent ? Color.highlightYellow : Color.bgWhite
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        assignment.isUrgent ? Color.clear : Color.gridGray,
                        lineWidth: assignment.isUrgent ? 0 : 2.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Safe Array Indexing
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    ContentView()
}
