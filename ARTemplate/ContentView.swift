//
//  ContentView.swift
//  ARTemplate
//
//  Created by John Trujillo on 4/5/22.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @StateObject var dataModel = DataModel.shared
    
    @State var showOverlay = true
    
    var body: some View {
        NavigationView {
            ZStack {
                ARViewContainer().ignoresSafeArea()
            }
            .navigationTitle(dataModel.appState.title)
            .font(.body)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if dataModel.appState == .zoom {
                        Button {
                            dataModel.zoomIn()
                        } label: {
                            Label("Zoom In", systemImage: "plus.magnifyingglass")
                        }
                        
                        Spacer()
                        
                        Button {
                            dataModel.zoomOut()
                        } label: {
                            Label("Zoom Out", systemImage: "minus.magnifyingglass")
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        
                        Button {
                            dataModel.setGrabStrategy()
                        } label: {
                            Label("Grab", systemImage: "line.3.crossed.swirl.circle")
                        }
                        
                        Button {
                            dataModel.setMeasureStrategy()
                        } label: {
                            Label("Measure", systemImage: "ruler")
                        }
                        
                        Button {
                            dataModel.setPointerStrategy()
                        } label: {
                            Label("Pointer", systemImage: "circle")
                        }
                        Button {
                            dataModel.setZoomStrategy()
                        } label: {
                            Label("Zoom Manipulation", systemImage: "plus.magnifyingglass")
                        }
                        Button {
                            dataModel.setGestureStrategy()
                        } label: {
                            Label("Manipulate", systemImage: "hand")
                            
                        }.opacity(showOverlay ? 1 : 0)
                        
                    } label: {
                        Image(systemName: "gear")
                    }
                    .opacity(showOverlay ? 1 : 0)
                    
                }
            }
        }
        
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
