import Foundation
import SwiftUI


struct Toast<Presenting>: View where Presenting: View {
    
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                
                if isShowing {
                    VStack {
                        self.text
                    }
                    .frame(width: geometry.size.width / 2,
                           height: 40)
                    .background(Color(red: 250.0/255.0, green: 160.0/255.0, blue: 10.0/255.0))
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.isShowing = false
                            }
                        }
                    }
                    .opacity(self.isShowing ? 1 : 0)
                    
                }
            }
            
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
}
