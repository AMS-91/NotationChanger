//
//  HomeView.swift
//  NotationChanger
//
//  Created by 안민수 on 2022/04/05.
//

import SwiftUI

struct HomeView: View {
    
    @State var typedText : String = ""
    @State var convertedToUpper : String = ""
    @State var convertedToLower : String = ""
    @State var onTyping : Bool = false
    
    
    @FocusState private var nameIsFocused: Bool
    
    @State var notationSet : NotationOption = .Decimal
    
    var body: some View {

                GeometryReader { proxy in
                
                    let screenSize = proxy.size
                    
                ZStack {
                    //Background Color
                    Color.clear
                        .ignoresSafeArea()
                    
                    VStack(alignment:.center) {
                        
                        Rectangle()
                            .frame(height: screenSize.height / 10)
                            .opacity(0)
                        
                        selectNotation
                        
                        TextField("숫자를 입력하세요.", text: $typedText)
                            .focused($nameIsFocused)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                            .keyboardType(notationSet == .Decimal ? .decimalPad : .default)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color("ComponentColor"))
                                    .frame(height: 30)
                                    
                            )
                            .padding()
                            .onChange(of: typedText, perform: { _ in
                                if typedText != "" {
                                    onTyping = true
                                } else {
                                    onTyping = false
                                }
                            })
                            .overlay(
                                HStack{
                                    xButton
                                        .opacity(onTyping ? 1.0 : 0.0)
                                }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.horizontal, 20)
                            
                            )
                            
                            
                        buttonSection

                        Rectangle()
                            .frame(height: screenSize.height / 15)
                            .opacity(0)
                        
                        createDisplayView(screenSize: screenSize, base: .Binary)
                        
                        createDisplayView(screenSize: screenSize, base: .Decimal)
                        
                        createDisplayView(screenSize: screenSize, base: .Hexa)
                        
                        Spacer()
                    }
                    .ignoresSafeArea()
                    .frame(width: screenSize.width * 0.9                                             , height: screenSize.height)
                    
                    
                }
                
            }
            
        }
        
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            HomeView()
            
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}


extension HomeView {

    // View
    
    
    
    private func createDisplayView(screenSize: CGSize, base: NotationOption) -> some View {
        
        var returnedView : some View {
        
                    VStack(spacing: 15) {

                        HStack {
                            
                            Text(notationSet == .Decimal ? "Decimal" : "Hexadecimal")
                                .font(.headline)
                            
                            Image(systemName: "chevron.right")
                            
                            Text(base == .Hexa ? "Hexadecimal" : (base == .Decimal ? "Decimal" : "Binary"))
                        }
                        
                        // nottationset=10 , upper - binary  , lower - hexa , text - 10
                        
                        // nottationset=16 , upper - binary  , lower - decimal , text - 10
                        if notationSet == .Decimal {
                            
                            Text(base == .Binary ? convertedToUpper : (base == .Decimal ? "inserted value : \(typedText)" : convertedToLower))
                                .frame(width: screenSize.width / 1.5 )
                                .frame(height: 30)
                                .background(Color("ComponentColor"))
                            
                        } else {
                            
                            Text(base == .Binary ? convertedToUpper : (base == .Decimal ? convertedToLower : "inserted value : \(typedText)"))
                                .frame(width: screenSize.width / 1.5 )
                                .frame(height: 30)
                                .background(Color("ComponentColor"))
                            
                        }
                        

                    }
                    .frame(width: screenSize.width, alignment: .center)
                    .padding(.bottom, 10)
                
            }
            
        
        return returnedView
    }

    private var selectNotation : some View {
        
        VStack(spacing: 20){
            
            Text("몇 진법의 수를 입력하시나요??")
                .font(.callout)
                .fontWeight(.medium)
            
            HStack(spacing: 30) {
                
                Button {
                    notationSet = .Decimal
                    typedText = ""
                    nameIsFocused = false
                    convertedToUpper = ""
                    convertedToLower = ""
                } label: {
                    Text("Decimal")
                        .foregroundColor(
                        Color("FontColor")
                        )
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(
                            
                            ZStack {
                                
                                Rectangle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(notationSet == .Decimal ? Color("ComponentColor") : Color.gray.opacity(0.5))
                                    .opacity(notationSet == .Decimal ? 1 : 0.5)
                                
                                Color("ComponentColor")
                                    .opacity(
                                        notationSet == .Decimal ? 0.7 : 0
                                )
                            }
                        )
                        
                }

                Button {
                    notationSet = .Hexa
                    typedText = ""
                    nameIsFocused = false
                    convertedToUpper = ""
                    convertedToLower = ""
                } label: {
                    Text("Hexadecimal")
                        .foregroundColor(
                        Color("FontColor")
                        )
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(
                            ZStack {
                                
                                Rectangle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(notationSet == .Hexa ? Color("ComponentColor") : Color.gray.opacity(0.5))
                                    .opacity(notationSet == .Hexa ? 1 : 0.5)
                                
                                Color("ComponentColor")
                                    .opacity(
                                        notationSet == .Hexa ? 0.7 : 0
                                )
                            }
                        )
                        
                }
                
            }
            
        }
        .padding(.vertical, 30)
    }
    
    
    private var buttonSection : some View {
        
        Button {
            if notationSet == .Decimal {
            convertedToUpper = decimalToBinary(dec: typedText)
            convertedToLower = decimalToHexa(dec: typedText)
            } else if notationSet == .Hexa {
                convertedToUpper = hexaToBinary(hex: typedText)
                convertedToLower = hexaToDecimal(hex: typedText)
            } else {
                // binary to *
            }
            
            nameIsFocused = false
        } label: {
            Text("Click")
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.2))
        }
        
    }
    
    // Notation Option
    
    enum NotationOption : Int {
        case Binary = 2
        case Decimal = 10
        case Hexa = 16
    }
    
    // Convert Func
    
    private func decimalToBinary(dec: String) -> String {
        let output = String(stringToInt(input: dec), radix: 2)
        return output
    }
    
    private func decimalToHexa(dec: String) -> String {
        let output = String(stringToInt(input: dec), radix: 16, uppercase: true)
        return output
    }
    
    private func hexaToDecimal(hex: String) -> String {
        if let output = Int(hex, radix: 16) {
        return String(output)
        } else { return "error"}
    }
    
    private func hexaToBinary(hex: String) -> String {
        if let output = Int(hex, radix: 16) {
            return String(output, radix: 2)
        } else {
        return "error"
        }
    }
    
    
    private func stringToInt(input: String) -> Int {
        if let input = Int(input) {
            return input
        }
        return 0
    }
    
    private var xButton : some View {
        
            Button {
                typedText = ""
                onTyping.toggle()
            } label: {
                Image(systemName: "x.circle")
                    .font(.system(size: 20))
            }

        
        
    }
    
}
