//
//  SupportView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
//
import SwiftUI
import MessageUI

struct SupportView: View {
    @State private var showMailComposer = false
    @State private var showPrivacySheet = false
    @State private var showSecuritySheet = false
    @State private var showAboutSheet = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    SupportButtonView(text: "Telegram", color: .blue, image: "paperplane.fill") {
                        openTelegram()
                    }
                    
                    SupportButtonView(text: "Gmail", color: .red, image: "envelope.fill") {
                        showMailComposer.toggle()
                    }
                    .sheet(isPresented: $showMailComposer) {
                        MailComposeViewController(toRecipients: ["akkavakmehmet@gmail.com"])
                    }

                    SupportButtonView(text: "WhatsApp", color: .green, image: "arrowshape.turn.up.forward.fill") {
                        shareViaWhatsApp()
                    }
                }
                HStack(spacing: 20) {
                    SupportButtonView(text: "Privacy", color: .yellow, image: "lock.fill") {
                        showPrivacySheet.toggle()
                    }
                    .sheet(isPresented: $showPrivacySheet) {
                        PrivacyView()
                    }
                    
                    SupportButtonView(text: "Security", color: .orange, image: "shield.fill") {
                        showSecuritySheet.toggle()
                    }
                    .sheet(isPresented: $showSecuritySheet) {
                        SecurityView()
                    }
                    
                    SupportButtonView(text: "About Chefino", color: .purple, image: "info.circle.fill") {
                        showAboutSheet.toggle()
                    }
                    .sheet(isPresented: $showAboutSheet) {
                        AboutView()
                    }
                }
            }
            .padding()
            .navigationTitle("Support")
        }
    }
    
    func openTelegram() {
        let telegramURL = URL(string: "tg://resolve?domain=Chefino")!
        let appStoreURL = URL(string: "https://apps.apple.com/us/app/telegram-messenger/id686449807")!
        
        if UIApplication.shared.canOpenURL(telegramURL) {
            UIApplication.shared.open(telegramURL)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    func shareViaWhatsApp() {
        let urlWhats = "whatsapp://send?text=Check out this cool app: https://example.com"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    let appStoreURL = URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997")!
                    UIApplication.shared.open(appStoreURL)
                }
            }
        }
    }
}

struct SupportButtonView: View {
    let text: String
    let color: Color
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                VStack {
                    Image(systemName: image)
                        .font(.title)
                        .foregroundColor(.white)
                    Text(text)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct PrivacyView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.largeTitle)
                .padding()
            ScrollView {
                Text("""
                    At Chefino, your privacy is of utmost importance to us. We are committed to safeguarding your personal information and ensuring transparency about how we collect, use, and protect it.

                    1. **Data Collection**:
                    We collect minimal personal data to provide and improve our services. This includes information you provide when creating an account, such as your name, email address, and contact information. We may also collect information about your usage of the app, including interactions, preferences, and feedback.

                    2. **Data Usage**:
                    The information we collect is used to:
                    - Provide, operate, and maintain our services
                    - Improve, personalize, and expand our services
                    - Understand and analyze how you use our services
                    - Develop new products, services, features, and functionality
                    - Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the service, and for marketing and promotional purposes
                    - Process transactions and send you related information, including purchase confirmations and invoices

                    3. **Data Sharing**:
                    We do not sell, trade, or otherwise transfer your personal information to outside parties. This does not include trusted third parties who assist us in operating our app, conducting our business, or serving our users, so long as those parties agree to keep this information confidential. We may also release your information when we believe release is appropriate to comply with the law, enforce our site policies, or protect ours or others' rights, property, or safety..
                    """)
                .padding()
            }
        }
    }
}

struct SecurityView: View {
    var body: some View {
        VStack {
            Text("Security Information")
                .font(.largeTitle)
                .padding()
            ScrollView {
                Text("""
                    At Chefino, we prioritize the security of your data. We implement industry-standard security measures to protect your information. Our app uses encryption to ensure that your data is transmitted securely. For more details on our security practices, please visit our website.

                    - **Encryption**: All data transmitted between your device and our servers is encrypted using Secure Socket Layer (SSL) technology, ensuring that your information is protected during transmission.
                    - **Data Storage**: Personal data is stored on secure servers with restricted access. We use advanced security protocols to safeguard your information from unauthorized access, alteration, or destruction.
                    - **Access Controls**: We implement strict access controls to ensure that only authorized personnel have access to your personal data. Our employees are trained in data protection and privacy practices.
                    - **Regular Audits**: We conduct regular security audits and assessments to identify and address potential vulnerabilities. Our systems are continuously monitored for security threats.
                    - **Two-Factor Authentication (2FA)**: We offer two-factor authentication as an additional security measure to protect your account. Enabling 2FA adds an extra layer of security by requiring a second form of verification in addition to your password.
                    - **Data Breach Response**: In the unlikely event of a data breach, we have a response plan in place to quickly address and mitigate the impact. We will notify affected users and take necessary steps to protect your information.

                    We are committed to maintaining the highest standards of data security and privacy. For more information about our security practices and how we protect your data, please visit our website or contact our support team..
                    """)
                .padding()
            }
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About Chefino")
                .font(.largeTitle)
                .padding()
            ScrollView {
                Text("""
                    Welcome to Chefino! Our app is designed to provide you with the best culinary experiences. Whether you are looking for recipes, cooking tips, or gastronomic news, Chefino has it all. Explore the app to discover new dishes, learn cooking techniques, and stay updated with the latest in the culinary world. Thank you for choosing Chefino!

                    **Our Mission**:
                    At Chefino, our mission is to bring the joy of cooking to everyone, from novice home cooks to seasoned chefs. We believe that cooking should be accessible, fun, and rewarding.

                    **Features**:
                    - **Extensive Recipe Collection**: Discover a wide range of recipes from various cuisines, complete with step-by-step instructions and photos.
                    - **Cooking Tips and Techniques**: Learn new cooking techniques and tips to enhance your culinary skills.
                    - **Gastronomic News**: Stay informed with the latest news and trends in the culinary world.
                    - **Interactive Community**: Share your own recipes, tips, and experiences with a community of fellow food enthusiasts.

                    **Why Choose Chefino**:
                    - **User-Friendly Interface**: Our app is designed with simplicity and ease of use in mind, ensuring a seamless experience for all users.
                    - **High-Quality Content**: All recipes and content are curated by professional chefs and food experts to guarantee quality and reliability.
                    - **Personalized Experience**: Customize your profile and preferences to receive recipe recommendations and content tailored to your tastes.

                    **Join Us**:
                    We invite you to join the Chefino community and embark on a culinary journey like no other. Whether you’re looking to try new recipes, improve your cooking skills, or connect with other food lovers, Chefino is here to support you every step of the way.

                    For more information or to get in touch with our support team, please visit our website or contact us at akkavakmehmet@gmail.com.
                    """)
                .padding()
            }
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
    SupportView()
    }
    }

    struct MailComposeViewController: UIViewControllerRepresentable {
    var toRecipients: [String]
        class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController

        init(_ parent: MailComposeViewController) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeViewController>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(toRecipients)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeViewController>) {}
    }
