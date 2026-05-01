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

// MARK: - SplashScreenView
struct SplashScreenView: View {
    private let beeImage = "splash-screen-06"
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Image(beeImage)
                    .resizable()
                    .background(Color.highlightYellow)


            }
        }
    }
}

// MARK: - Data Models
struct Assignment: Identifiable {
    let id: UUID
    var name: String
    var isUrgent: Bool
    var isComplete: Bool

    init(id: UUID = UUID(), name: String, isUrgent: Bool, isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.isUrgent = isUrgent
        self.isComplete = isComplete
    }
}

struct ClassInfo: Identifiable {
    let id = UUID()
    let name: String
    var assignments: [[Assignment]] // Each inner array is a day’s assignments
}

// MARK: - Sheet Info Struct
struct AssignmentDetailSheetInfo: Identifiable {
    let assignment: Assignment
    let className: String
    let dayIndex: Int
    var id: UUID { assignment.id }
}

// MARK: - Sample Data
let sampleClassesData: [ClassInfo] = [
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
    @State private var showSplash: Bool = true
    @State private var classes: [ClassInfo] = sampleClassesData
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else {
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
                                let rowCount = classes.count
                                let cellHeight = geo.size.height / CGFloat(rowCount)
                                
                                VStack(spacing: 1) {
                                    ForEach(Array(classes.enumerated()), id: \.element.id) { rowIdx, classInfo in
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
                                                ForEach(assignments.indices, id: \.self) { assignIdx in
                                                    AssignmentCell(assignment: $classes[rowIdx].assignments[selectedDay][assignIdx])
                                                        .frame(maxWidth: .infinity)
                                                        .onTapGesture {
                                                            selectedAssignment = AssignmentDetailSheetInfo(assignment: classes[rowIdx].assignments[selectedDay][assignIdx], className: classInfo.name, dayIndex: selectedDay)
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
                .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

struct AssignmentCell: View {
    @Binding var assignment: Assignment
    var body: some View {
        HStack {
            Button(action: {
                assignment.isComplete.toggle()
            }) {
                Image(systemName: assignment.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(assignment.isComplete ? .accentYellow : .gridGray)
                    .font(.system(size: 22, weight: .bold))
            }
            Text(assignment.name)
                .font(.quicksand(size: 15, weight: .semibold))
                .foregroundColor(assignment.isComplete ? .textGray : (assignment.isUrgent ? .textBlack : .textGray))
                .strikethrough(assignment.isComplete, color: .textGray)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            assignment.isComplete ? Color.clear : (assignment.isUrgent ? Color.highlightYellow : Color.bgWhite)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    assignment.isComplete ? Color.clear : (assignment.isUrgent ? Color.clear : Color.gridGray),
                    lineWidth: assignment.isComplete ? 0 : (assignment.isUrgent ? 0 : 2.5)
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

// MARK: - AssignmentDetailView
struct AssignmentDetailView: View {
    let assignment: Assignment
    let className: String
    let dayIndex: Int
    
    @State private var focusMinutes: Int = 25
    @State private var breakMinutes: Int = 5
    @State private var repeatCount: Int = 4
    @State private var showFocusTimer: Bool = false
    
    @State private var showEditSheet: Bool = false
    
    // Local editable states for assignment
    @State private var editableName: String
    @State private var editableIsUrgent: Bool
    
    init(assignment: Assignment, className: String, dayIndex: Int) {
        self.assignment = assignment
        self.className = className
        self.dayIndex = dayIndex
        // Initialize editable states
        _editableName = State(initialValue: assignment.name)
        _editableIsUrgent = State(initialValue: assignment.isUrgent)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(editableName)
                .font(.quicksand(size: 28, weight: .bold))
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Class: \(className)")
                    .font(.quicksand(size: 20))
                Text("Day: \(weekDates[safe: dayIndex]?.0 ?? "") \(weekDates[safe: dayIndex]?.1 ?? "")")
                    .font(.quicksand(size: 20))
            }
            .padding(.horizontal)
            
            // Focus time picker
            VStack(alignment: .leading, spacing: 8) {
                Stepper(value: $focusMinutes, in: 1...120) {
                    HStack {
                        Text("Focus Time:")
                            .font(.quicksand(size: 18))
                        Text("\(focusMinutes)")
                            .font(.quicksand(size: 18, weight: .semibold))
                    }
                }
                .padding()
                Stepper(value: $breakMinutes, in: 1...60) {
                    HStack {
                        Text("Break Time:")
                            .font(.quicksand(size: 18))
                        Text("\(breakMinutes)")
                            .font(.quicksand(size: 18, weight: .semibold))
                    }
                }
                .padding()
                Stepper(value: $repeatCount, in: 1...10) {
                    HStack {
                        Text("Repeat Count:")
                            .font(.quicksand(size: 18))
                        Text("\(repeatCount)")
                            .font(.quicksand(size: 18, weight: .semibold))
                    }
                }
                .padding()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                showFocusTimer = true
            }) {
                HStack {
                    Image(systemName: "bee.fill")
                        .font(.title2)
                    Text("Start Focus")
                        .font(.quicksand(size: 22, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentYellow)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color.accentYellow.opacity(0.6), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditSheet = true
                }
                .font(.quicksand(size: 18, weight: .medium))
                .foregroundColor(Color.accentYellow)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    Form {
                        Section(header: Text("Assignment Info").font(.quicksand(size: 20, weight: .semibold))) {
                            TextField("Assignment Name", text: $editableName)
                                .font(.quicksand(size: 18))
                                .foregroundColor(.textBlack)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                            Toggle(isOn: $editableIsUrgent) {
                                Text("Urgent")
                                    .font(.quicksand(size: 18))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.bgWhite)
                }
                .background(Color.bgWhite.ignoresSafeArea())
                .navigationTitle("Edit Assignment")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            // Reset edits to original on cancel
                            editableName = assignment.name
                            editableIsUrgent = assignment.isUrgent
                            showEditSheet = false
                        }
                        .font(.quicksand(size: 18))
                        .foregroundColor(.textGray)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            // Update local assignment info for session
                            // This updates only local editable states in this view as assignment is let constant;
                            // To persist edits, data model and storage would be needed.
                            showEditSheet = false
                        }
                        .disabled(editableName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .font(.quicksand(size: 18, weight: .semibold))
                        .foregroundColor(editableName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : Color.accentYellow)
                    }
                }
            }
        }
        .sheet(isPresented: $showFocusTimer) {
            FocusTimerView(assignment: Assignment(id: assignment.id, name: editableName, isUrgent: editableIsUrgent),
                           focusMinutes: focusMinutes,
                           breakMinutes: breakMinutes,
                           repeatCount: repeatCount)
        }
    }
}

// MARK: - FocusTimerView Full Implementation
struct FocusTimerView: View {
    let assignment: Assignment
    let focusMinutes: Int
    let breakMinutes: Int
    let repeatCount: Int
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isRunning: Bool = false
    @State private var isFocusPeriod: Bool = true
    @State private var timeRemaining: Int
    @State private var currentRound: Int = 1
    @State private var timer: Timer? = nil
    @State private var isComplete: Bool = false
    
    // Added state variable for flashing effect
    @State private var showFlash: Bool = false
    
    // Added state for automatic start control
    @State private var hasStartedAutomatically = false
    
    init(assignment: Assignment, focusMinutes: Int, breakMinutes: Int, repeatCount: Int) {
        self.assignment = assignment
        self.focusMinutes = focusMinutes
        self.breakMinutes = breakMinutes
        self.repeatCount = repeatCount
        _timeRemaining = State(initialValue: focusMinutes * 60)
    }
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            
            // Overlay flash effect on entire ZStack, behind main content
            Color.accentYellow.opacity(showFlash ? 0.65 : 0)
                .animation(.easeInOut(duration: 0.25), value: showFlash)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "bee.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.accentYellow)
                    .shadow(color: Color.accentYellow.opacity(0.6), radius: 10, x: 0, y: 4)
                
                if isComplete {
                    Text("🎉 Well done! 🎉")
                        .font(.quicksand(size: 32, weight: .bold))
                        .foregroundColor(.accentYellow)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("You completed all \(repeatCount) cycles for \"\(assignment.name)\".")
                        .font(.quicksand(size: 20))
                        .foregroundColor(.textBlack)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text(isFocusPeriod ? "Focus Time" : "Break Time")
                        .font(.quicksand(size: 28, weight: .bold))
                        .foregroundColor(.accentYellow)
                    
                    Text(timeString(from: timeRemaining))
                        .font(.quicksand(size: 64, weight: .bold))
                        .monospacedDigit()
                        .foregroundColor(.textBlack)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.bgWhite)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                    
                    Text("Cycle \(currentRound) of \(repeatCount)")
                        .font(.quicksand(size: 20, weight: .semibold))
                        .foregroundColor(.textGray)
                }
                
                Spacer()
                
                if isComplete {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("End")
                            .font(.quicksand(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentYellow)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.accentYellow.opacity(0.6), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                } else {
                    HStack(spacing: 20) {
                        if isRunning {
                            Button(action: pauseTimer) {
                                Text("Pause")
                                    .font(.quicksand(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentYellow)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: Color.accentYellow.opacity(0.6), radius: 8, x: 0, y: 4)
                            }
                        } else {
                            Button(action: startTimer) {
                                Text("Resume")
                                    .font(.quicksand(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentYellow)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: Color.accentYellow.opacity(0.6), radius: 8, x: 0, y: 4)
                            }
                        }
                        
                        Button(action: resetTimer) {
                            Text("Reset")
                                .font(.quicksand(size: 22, weight: .semibold))
                                .foregroundColor(Color.accentYellow)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.accentYellow, lineWidth: 2.5)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("End")
                            .font(.quicksand(size: 22, weight: .semibold))
                            .foregroundColor(.textGray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.textGray, lineWidth: 2.5)
                            )
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical, 30)
        }
        .onAppear {
            // Ensure timer is stopped and time is correct on appear
            stopTimer()
            if isComplete {
                // Already finished
                return
            }
            // Initialize timeRemaining properly if not running
            if !isRunning && !hasStartedAutomatically {
                startTimer()
                hasStartedAutomatically = true
            } else if !isRunning {
                timeRemaining = isFocusPeriod ? focusMinutes * 60 : breakMinutes * 60
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            tick()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func pauseTimer() {
        isRunning = false
        stopTimer()
    }
    
    private func resetTimer() {
        stopTimer()
        isRunning = false
        isComplete = false
        isFocusPeriod = true
        currentRound = 1
        timeRemaining = focusMinutes * 60
        showFlash = false
        hasStartedAutomatically = false
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            // Flash logic updated: flash for both focus and break periods when 5 seconds or less remaining, but not zero
            if timeRemaining <= 5 && timeRemaining > 0 {
                showFlash.toggle()
            } else {
                showFlash = false
            }
        } else {
            // Time's up, switch focus/break or finish
            showFlash = false
            if isFocusPeriod {
                // Switch to break
                isFocusPeriod = false
                timeRemaining = breakMinutes * 60
            } else {
                // Break over
                if currentRound >= repeatCount {
                    // Finished all cycles
                    isComplete = true
                    stopTimer()
                    isRunning = false
                } else {
                    // Next round focus
                    currentRound += 1
                    isFocusPeriod = true
                    timeRemaining = focusMinutes * 60
                }
            }
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    ContentView()
}

