import Foundation
import SwiftUI

private let pickerViewTitlePadding: CGFloat = 4.0

struct TimePickerView: View {
    let title: String
    
    // range of values to explain
    let range: ClosedRange<Int>
    
    // binding - a way for the two views to communicate
    // will update the user's selection
    let binding: Binding<Int>
    
    var body: some View {
       // Hstack renders all the views at once, good for a small number of views
        HStack(spacing: -pickerViewTitlePadding) {
            // Picker - UI control that allows users to select a single value from a list of options
            Picker(title, selection: binding){
                // computes vies on demand from underlying collection of data
                // we are using it here to load all of the possible options
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        Spacer()
                        Text("\(timeIncrement)")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .pickerStyle(InlinePickerStyle())
            .labelsHidden()
                          
            Text(title)
                .fontWeight(.bold)
        }
    }
    
}
