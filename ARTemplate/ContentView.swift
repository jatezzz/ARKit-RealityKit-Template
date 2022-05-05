//
//  ContentView.swift
//  ARTemplate
//
//  Created by John Trujillo on 4/5/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    @StateObject var dataModel = DataModel.shared
    
    var body: some View {
        ZStack{
            ARViewContainer().ignoresSafeArea()
            
            VStack {
                HStack{
                    OverlayButtonsView()
                    Spacer()
                } .padding()
                Spacer()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif


struct OverlayButtonsView: View {

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            OverlayButton()
        }
    }

}

struct OverlayButton: View {

    
    @StateObject var dataModel = DataModel.shared
    @State var isMeasureActive = false
    @State var isPointerActive = false
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button {
                dataModel.zoomIn()
            } label: {
                Label("Zoom In", systemImage: "plus.magnifyingglass")
            }
            Button {
                dataModel.zoomOut()
            } label: {
                Label("Zoom Out", systemImage: "minus.magnifyingglass")
            }
            Button {
                dataModel.toogleRecordingFlag()
            } label: {
                Label("Grab", systemImage: "line.3.crossed.swirl.circle")
            }

            Button {
                dataModel.toogleMeasureFunctionality()
            } label: {
                Label(dataModel.isInMeasureFunctionality ? "Cancel measure" : "Measure", systemImage: "ruler")
            }
            Section {
                Button {
                    isPointerActive = !isPointerActive
                    dataModel.tooglePointerFlag()
                } label: {
                    Label("Pointer", systemImage: isPointerActive ? "checkmark.circle.fill" : "circle")
                }
                Button {
                    isMeasureActive = !isMeasureActive
                    dataModel.toogleManipulationFlag()
                } label: {
                    Label("Manipulate", systemImage: isMeasureActive ? "checkmark.circle.fill" : "circle")
                }
            }

        }
    }
}

