//
//  ContentView.swift
//  LetsCrashIt
//
//  Created by Pavankumar Arepu on 25/05/24.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    @State private var crashReportExists: Bool = UserDefaults.standard.string(forKey: "crashReport") != nil
    @State private var isShowingMailView = false
    @State private var crashReport = ""

    var body: some View {
        VStack {
            Button(action: {
                // Simulate a crash
                fatalError("App crashed")
            }) {
                Text("Crash the App")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            checkForCrashReport()
        }
        .alert(isPresented: $crashReportExists) {
            Alert(
                title: Text("Crash Detected"),
                message: Text("The app crashed last time it was used. Do you want to send a crash report?"),
                primaryButton: .default(Text("Send Report")) {
                    self.isShowingMailView = true
                },
                secondaryButton: .cancel(Text("Dismiss"))
            )
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: self.$isShowingMailView, crashReport: self.crashReport)
        }
    }

    func checkForCrashReport() {
        if let crashReport = UserDefaults.standard.string(forKey: "crashReport") {
            self.crashReport = crashReport
            self.crashReportExists = true
        } else {
            self.crashReportExists = false
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let crashReport: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true) {
                if result == .sent {
                    UserDefaults.standard.removeObject(forKey: "crashReport")
                }
                self.parent.isShowing = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["iOSDeveloper.ipa@gmail.com"])
        vc.setSubject("CrashReport on Date: \(Date())")
        vc.setMessageBody(crashReport, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
