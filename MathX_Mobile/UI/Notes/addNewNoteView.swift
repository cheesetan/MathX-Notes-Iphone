//
//  addNewNoteView.swift
//
//
//  Created by Tristan on 08/04/2023.
//

import SwiftUI

struct addNewNoteView: View {
    
    @State var noteTitle = String()
    @State var noteLatexRendering = false
    
    @State var showingEquationsFAQ = false
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var noteManager: NoteManager = .shared
    
    @AppStorage("notesCreated", store: .standard) var notesCreated = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    TextField("Untitled Note \(notesCreated + 1)", text: $noteTitle)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    HStack {
                        Image(systemName: "sum")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 3)
                        
                        Text("Math Rendering")
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        
                        Button {
                            showingEquationsFAQ.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.accentColor)
                                .font(.headline)
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $showingEquationsFAQ) {
                            mathEquationFAQ()
                        }
                        
                        Toggle("", isOn: $noteLatexRendering)
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    Spacer()
                    
                    if #available(iOS 26.0, *) {
                        Button {
                            addNewNote()
                        } label: {
                            Text("**Add new Note**")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 30)
                        .disabled(noteTitle.isEmpty)
                        .buttonStyle(.glassProminent)
                    } else {
                        Button {
                            addNewNote()
                        } label: {
                            Text("**Add new Note**")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 30)
                        .disabled(noteTitle.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.top)
                .padding(.horizontal, 30)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss.callAsFunction()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
        .onAppear {
            if notesCreated > 0 {
                noteTitle = "Untitled Note \(notesCreated + 1)"
            } else {
                noteTitle = "Untitled Note"
            }
        }
    }

    func addNewNote() {
        withAnimation {
            if !noteTitle.isEmpty {
                var currentNotesList = noteManager.notes

                currentNotesList.insert(Note(title: noteTitle, latexRendering: noteLatexRendering, dateLastModified: Date()), at: 0)

                let sortedNewNotesList = currentNotesList.sorted(by: { $0.dateLastModified.compare($1.dateLastModified) == .orderedDescending })

                noteManager.notes = sortedNewNotesList

                notesCreated += 1

                dismiss.callAsFunction()
            }
        }
    }
}

struct addNewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        addNewNoteView()
    }
}
