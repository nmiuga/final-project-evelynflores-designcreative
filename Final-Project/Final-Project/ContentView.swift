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

// MARK: - Sheet Info Struct
struct AssignmentDetailSheetInfo: Identifiable {
    let assignment: Assignment
    let className: String
    let dayIndex: Int
    var id: UUID { assignment.id }
}

// MARK: - Sample Data
let sampleClasses: [ClassInfo] = [
    ClassInfo(name: "Math", assignments: [
        [Assignment(name: "Homework 10.4", isUrgent: false), Assignment(name: "Quiz Ch. 10", isUrgent: true)],      // Mon Apr 27
        [Assignment(name: "Homework 10.5", isUrgent: false), Assignment(name: "Review notes", isUrgent: false)],    // Tue Apr 28
        [Assignment(name: "Study guide", isUrgent: false), Assignment(name: "Practice test", isUrgent: false)],     // Wed Apr 29
        [Assignment(name: "Problem Set 11", isUrgent: false)],                                                      // Thu Apr 30
        [Assignment(name: "Quiz Ch. 11", isUrgent: true)],                                                         // Fri May 1
        [Assignment(name: "Extra credit", isUrgent: false)],                                                       // Sat May 2
        [Assignment(name: "Test Review", isUrgent: false)]                                                        // Sun May 3
    ]),
    ClassInfo(name: "Biology", assignments: [
        [Assignment(name: "Lab Report", isUrgent: true), Assignment(name: "Flashcards", isUrgent: false)],          // Mon Apr 27
        [Assignment(name: "Diagram review", isUrgent: false)],                                                      // Tue Apr 28
        [Assignment(name: "Read Ch. 8", isUrgent: false), Assignment(name: "Quiz prep", isUrgent: false)],          // Wed Apr 29
        [Assignment(name: "Field trip prep", isUrgent: false)],                                                    // Thu Apr 30
        [Assignment(name: "Lab quiz", isUrgent: true)],                                                            // Fri May 1
        [Assignment(name: "Research notes", isUrgent: false)],                                                     // Sat May 2
        [Assignment(name: "Flashcard review", isUrgent: false)],                                                    // Sun May 3
    ]),
    ClassInfo(name: "English", assignments: [
        [Assignment(name: "Vocabulary list", isUrgent: false)],                                                    // Mon Apr 27
        [Assignment(name: "Essay Draft", isUrgent: false), Assignment(name: "Peer review", isUrgent: false)],       // Tue Apr 28
        [Assignment(name: "Poem Analysis", isUrgent: true), Assignment(name: "Journal entry", isUrgent: false)],    // Wed Apr 29
        [Assignment(name: "Reading assignment", isUrgent: false)],                                                 // Thu Apr 30
        [Assignment(name: "Essay final", isUrgent: true)],                                                         // Fri May 1
        [Assignment(name: "Book report prep", isUrgent: false)],                                                   // Sat May 2
        [Assignment(name: "Reading quiz", isUrgent: false)]                                                        // Sun May 3
    ]),
    ClassInfo(name: "History", assignments: [
        [Assignment(name: "Notes", isUrgent: false), Assignment(name: "Timeline", isUrgent: false)],                // Mon Apr 27
        [Assignment(name: "Presentation", isUrgent: false)],                                                       // Tue Apr 28
        [Assignment(name: "Document reading", isUrgent: false)],                                                   // Wed Apr 29
        [Assignment(name: "Group discussion", isUrgent: false)],                                                   // Thu Apr 30
        [Assignment(name: "Essay on WWI", isUrgent: true)],                                                        // Fri May 1
        [Assignment(name: "Quiz prep", isUrgent: false)],                                                          // Sat May 2
        [Assignment(name: "Map labeling", isUrgent: false)]                                                        // Sun May 3
    ]),
    ClassInfo(name: "Art", assignments: [
        [Assignment(name: "Warm-up sketch", isUrgent: false)],                                                     // Mon Apr 27
        [Assignment(name: "Sketch #2", isUrgent: false), Assignment(name: "Materials prep", isUrgent: false)],      // Tue Apr 28
        [Assignment(name: "Portfolio", isUrgent: true)],                                                           // Wed Apr 29
        [Assignment(name: "Color mixing exercise", isUrgent: false)],                                              // Thu Apr 30
        [Assignment(name: "Canvas prep", isUrgent: false)],                                                        // Fri May 1
        [Assignment(name: "Sculpture study", isUrgent: false)],                                                    // Sat May 2
        [Assignment(name: "Final project plan", isUrgent: true)]                                                  // Sun May 3
    ])
]

let weekDates: [(String, String)] = [
    ("Mon", "Apr 27"), ("Tue", "Apr 28"), ("Wed", "Apr 29"), ("Thu", "Apr 30"), ("Fri", "May 1"), ("Sat", "May 2"), ("Sun", "May 3")
]
let monthName = "April"

// MARK: - ContentView
struct ContentView: View {
    @State private var selectedDay: Int = 0 // Index into weekDates
    @Namespace private var anim
    @State private var selectedAssignment: AssignmentDetailSheetInfo? = nil
    
    var body: some View {
        NavigationStack {
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
                    Rectangle()
                        .fill(Color.gridGray)
                        .frame(height: 1)
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
                                    // Class Name as rotated text
                                    Text(classInfo.name)
                                        .font(.quicksand(size: 15, weight: .semibold))
                                        .foregroundColor(.textGray)
                                        .frame(maxWidth: 55 , maxHeight: .infinity, alignment: .center)
                                        .rotationEffect(.degrees(-90))
                                    
                                    Rectangle()
                                        .fill(Color.gridGray)
                                        .frame(width: 2)
                                        .frame(maxHeight: .infinity)
                                    
                                    // Assignments for this class, this day
                                    let assignments = classInfo.assignments[safe: selectedDay] ?? []
                                    VStack(alignment: .leading, spacing: 4) {
                                        ForEach(assignments) { assignment in
                                            AssignmentCell(assignment: assignment)
                                                .frame(maxWidth: .infinity)
                                                .onTapGesture {
                                                    selectedAssignment = AssignmentDetailSheetInfo(assignment: assignment, className: classInfo.name, dayIndex: selectedDay)
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
                                    Rectangle()
                                        .fill(Color.gridGray)
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)
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
                .padding(20)
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
            .sheet(item: $selectedAssignment) { item in
                AssignmentDetailView(assignment: item.assignment, className: item.className, dayIndex: item.dayIndex)
            }
        }
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

// MARK: - AssignmentDetailView Placeholder
struct AssignmentDetailView: View {
    let assignment: Assignment
    let className: String
    let dayIndex: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Assignment Detail")
                .font(.quicksand(size: 28, weight: .bold))
                .padding(.top)
            Text("Name: \(assignment.name)")
                .font(.quicksand(size: 20))
            Text("Class: \(className)")
                .font(.quicksand(size: 20))
            Text("Day: \(weekDates[safe: dayIndex]?.0 ?? "") \(weekDates[safe: dayIndex]?.1 ?? "")")
                .font(.quicksand(size: 20))
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
