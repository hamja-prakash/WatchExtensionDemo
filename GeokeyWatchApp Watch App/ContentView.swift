//
//  ContentView.swift
//  GeokeyWatchApp Watch App
//
//  Created by Hamja Paldiwala on 16/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ListViewModel()
    
    var body: some View {
        List {
            ForEach($viewModel.videos) { video in
                if video.wrappedValue.isVisible {
                    if video.wrappedValue.isHeader {
                        HeaderView(video: video)
                            .onTapGesture {
                                viewModel.expandSection(video.wrappedValue)
                            }
                    } else {
                        ChildView(video: video, viewModel: viewModel)
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.videos = ListViewModel.VideoList.topTen.filter({($0.parentId == 1 || $0.sectionId == 1)})
            viewModel.setupiOSConnectivity()
        }
        .toast(isShowing: $viewModel.isToastVisible, text: Text(viewModel.toastMessage))
    }
}

struct HeaderView: View {
    @Binding var video: ListViewModel.Video

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(video.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(video.title)
                    .font(.system(size: 14))
                Spacer()
                Image(systemName: video.isExpanded == true ? "chevron.down" : "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ChildView: View {
    @Binding var video: ListViewModel.Video
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(video.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(video.title)
                    .font(.system(size: 14))
            }
        }
        .onTapGesture {
//            let sendvideoObject: [String: Any] = [
//                "title": video.title,
//                "imageName": video.imageName,
//            ]
            iOSCommunicator.shared.sendDataToiPhone(video: video)
            withAnimation {
                viewModel.showToast("Success")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
