//
//  ChangeSettingView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/28/22.
//

import SwiftUI

struct ChangeSettingView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel : RegistrationViewModel
    @ObservedObject var settingsData : SettingViewModel
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing, 5)
                    }
                    
                    Text("Settings")
                        .font(Font.custom("DM Sans", size: 30))
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                }
                .padding(.all, 20)
                
                NavigationLink( destination:BugReportView(settingsData: settingsData)
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                ){
                    EditNaviButton(type: "I Found a Bug!", value: "")
                }
                
                NavigationLink( destination:InviteOnboardView()
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                ){
                    EditNaviButton(type: "Invite a Friend", value: "")
                }
                
                NavigationLink(destination: ServiceView(
                                settingsData: settingsData,
                                policy: "Privacy Policy:\n\nWe take your privacy seriously and are committed to protecting it. This privacy policy explains how we collect, use, and disclose your personal information when you use our app CloseCircle.\n\nWhen you use our app, we may collect personal information that you provide us, such as your name and email address. We may also collect information about your device, including your IP address, operating system, and browser type.\n\nWe may use your personal information to provide and improve our app and to communicate with you. We may also use your information to send you marketing messages, but you can opt out of receiving these messages at any time.\n\nWe may share your personal information with third-party service providers that help us operate our app, such as hosting providers and payment processors. We may also share your information if we are required to do so by law or if we believe that such action is necessary to protect our rights or the rights of others.\n\nWe take reasonable measures to protect your personal information from unauthorized access, use, and disclosure. However, no method of transmission over the internet or method of electronic storage is completely secure, and we cannot guarantee absolute security.\n\nOur app CloseCircle is not intended for children under 13 years of age, and we do not knowingly collect personal information from children under 13. If we learn that we have collected personal information from a child under 13, we will take steps to delete the information as soon as possible.\n\nWe may update our privacy policy from time to time. If we make material changes to our policy, we will notify you by email or by posting a notice on our app. Your continued use of our app after such modifications will constitute your agreement to the updated policy.\n\nIf you have any questions or concerns about our privacy policy, please contact us at [email protected]"
                            )
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                ) {
                    EditNaviButton(type: "Privacy Policy", value: "")
                }
                
                NavigationLink( destination:ServiceView(
                    settingsData: settingsData,
                    policy: "TERMS OF SERVICE AGREEMENT Welcome to CloseCircle. By accessing or using the App, you agree to be bound by the following terms and conditions (the 'Terms of Service'). Please read these Terms of Service carefully before accessing or using the App. If you do not agree to these Terms of Service, you may not access or use the App. Use of the App 1.1. You must be at least 13 years old to use the App. 1.2. You may use the App only for lawful purposes and in accordance with these Terms of Service. 1.3.You may not use the App to: (a) Upload or transmit any content that is unlawful, harmful, threatening, abusive, harassing, defamatory, vulgar, obscene, or otherwise objectionable.(b) Interfere with or disrupt the App, servers or networks connected to the App, or violate the regulations, policies or procedures of such networks.(c) Attempt to gain unauthorized access to any portion or feature of the App, or any other systems or networks connected to the App or to any server used by the App.(d) Use any robot, spider or other automatic device, process or means to access the App for any purpose 1.4. We reserve the right to refuse service, terminate accounts, or remove or edit content in our sole discretion.Intellectual Property 2.1. The App and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by us, our licensors, or other providers of such material and are protected by United States and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws. 2.2. These Terms of Service permit you to use the App for your personal, non-commercial use only. You must not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any of the material on our App, except as follows:(a) Your computer may temporarily store copies of such materials in RAM incidental to your accessing and viewing those materials.(b) You may store files that are automatically cached by your Web browser for display enhancement purposes.(c) You may print or download one copy of a reasonable number of pages of the App for your own personal, non-commercial use and not for further reproduction, publication, or distribution.2.3. If you print, copy, modify, download, or otherwise use or provide any other person with access to any part of the App in breach of the Terms of Service, your right to use the App will stop immediately and you must, at our option, return or destroy any copies of the materials you have made.Disclaimer of Warranties; Limitation of Liabilite. 3.1. We do not warrant or represent that the App will be error-free, uninterrupted, or secure. 3.2. Your use of the App is at your own risk. The App is provided on an 'AS IS' and AS AVAILABLE basis. To the maximum extent permitted by law, we disclaim all warranties, express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, and non-infringement. 3.3. In no event shall we or our affiliates be liable for any indirect, incidental, special, punitive, or consequential damages arising out of or in connection with your use of the App, including but not limited to damages for loss of profits, loss of data")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                ){
                    EditNaviButton(type: "Terms of Service", value: "")
                }
                
                Spacer()
                
                Button(action: {
                   viewModel.signOut()
                },label: {
                   Text("Log Out")
                       .font(Font.custom("DM Sans", size: 18))
                       .fontWeight(.bold)
                       .padding()
                       .frame(width:UIScreen.main.bounds.width-20, height: 50, alignment: .leading)
                       .background(Color(hex: 0xE4E7EC))
                       .cornerRadius(7)
               })
               .padding()
               .padding(.top,10)
                
            }
            .navigationBarHidden(true)
            .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
}

