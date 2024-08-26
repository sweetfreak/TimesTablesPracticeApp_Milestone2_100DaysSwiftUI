//
//  ContentView.swift
//  Edu-tainment_MilestoneProject_SwiftUI
//
//  Created by Jesse Sheehan on 8/15/24.
//
/*
NOTES:
 - Game crashes after there are no more questions left.
 
 - Game generates questions and correct answers in two different lists
 
 - new wrong answers are created after each round
 
 - GameOver() is supposed to restart the game, but seems to just crash it.
 
 "Index out of range" is the issue i get
 
 */



import SwiftUI

struct Question {
    let firstNum: Int
    let secondNum: Int
    
    mutating func Solve() -> Int {
        return firstNum * secondNum
    }
}

struct ContentView: View {
    
    @State private var questions: [String] = []
    @State private var numOfQuestions = 10
    @State private var upRange: Int = 10
    
    @State private var timesTable: Int = 0
    @State private var allNumbers = false
    
    @State private var answerOptions: [Int] = []
    @State private var correctAnswers: [Int] = []
    
    @State private var playersAnswer: Int = 0
    
    @State private var questionsLeft = 0
    @State private var showQuestions = false
    
    @State private var score = 0
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Choose you Times Table") {
                        Toggle("Practice All Numbers?", isOn: $allNumbers)
                        
                        Picker("Choose Time Tables: \($timesTable)", selection: $timesTable) {
                            ForEach(0..<13) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Stepper("Highest Number: \(upRange)", value: $upRange, in: 10...12, step: 1)
                    }
                    
                    Section("How Many Questions?") {
                        Picker("Choose the Number of Questions", selection: $numOfQuestions) {  // **Updated to bind to Int**
                                                   ForEach([2, 15, 20], id: \.self) { number in
                                                       Text("\(number)").tag(number)  // **Ensure proper tagging**
                                                   }
                                               }.pickerStyle(.segmented)
                    }
                    
                    Button("Confirm") {
                        generateQuestions(selectednumQues: numOfQuestions, all: allNumbers, table: timesTable, upper: upRange)
                    }
                    
                    
                }
            }.navigationTitle("Time to Times Tables!")
            
            Section("Practice Question") {
                Text("Score: \(score)")
                if showQuestions {
                    Text(questions[numOfQuestions - questionsLeft])
                    
                    
                    Picker("Choose the correct answer", selection: $playersAnswer) {
                        //ForEach([correctAnswers[numOfQuestions - questionsLeft], correctAnswers[numOfQuestions - questionsLeft] + Int.random(in:1...15), correctAnswers[numOfQuestions - questionsLeft] - Int.random(in: 1...15)], id: \.self) { number in
                        ForEach(answerOptions, id: \.self) {number in
                            Text("\(number)").tag(number)
                        }
                    }.pickerStyle(.segmented)
                    
                    Button("Submit") {
                                                
                        if correctAnswers[numOfQuestions - questionsLeft] == playersAnswer {
                            score += 1
                        }
                        
                        if questionsLeft == 0 {
                            GameOver()
                            
                        } else {
                            questionsLeft -= 1
                            answerOptions.removeAll()
                            CreateAnswers(correctAns: correctAnswers[numOfQuestions - questionsLeft])
                        }
                        
                    }
                    
                }
                else {
                    Text("Choose parameters to test your skills")
                }
                }
            }
        }
        
    
        
    func generateQuestions(selectednumQues: Int, all: Bool, table: Int, upper: Int) {
        
            //Convert String to an Int
            let numQues = selectednumQues
            
            
            for _ in 0..<numQues {
                let first: Int = {
                    if allNumbers {
                        return Int.random(in: 0...10)
                    } else {
                        return Int(timesTable)
                    }
                }()
                let second = Int.random(in: 0...upper)
                
                var newQuestion = Question(firstNum: first, secondNum: second)
                
                correctAnswers.append(newQuestion.Solve())
                
                questions.append("\(first) * \(second) = ?")
             
               questionsLeft = numOfQuestions
            }
        showQuestions = true
            for question in questions {
                print(question)
            }
           
          //randomInt...up to low range..
            //randomInt...up low range
            //Solve it, assign as correct answer
            //geneate wrong answers
            //Add them to list of answers
            //
        //}
            CreateAnswers(correctAns: (numOfQuestions - questionsLeft))
        }
    
    func CreateAnswers(correctAns: Int) {
        let correct = correctAns
        print(correct)
    
        answerOptions.append(correctAnswers[numOfQuestions - questionsLeft])
        
        answerOptions.append(correct + Int.random(in: 1...15))
        answerOptions.append(correct - Int.random(in: 1...15))
        answerOptions.shuffle()
        
    }
        
    func GameOver() {
        showQuestions = false
        score = 0
        correctAnswers.removeAll()
        questions.removeAll()
        
    }

}

#Preview {
    ContentView()
}
