//
//  PrivacyViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/5/24.
//

import UIKit

class PrivacyViewController: UIViewController {

    let privacyPolicyTextView: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.isScrollEnabled = true
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.textColor = .black
            return textView
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(privacyPolicyTextView)
            setupConstraints()
            loadPrivacyPolicy()
        }
        
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                privacyPolicyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                privacyPolicyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                privacyPolicyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                privacyPolicyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
        
        private func loadPrivacyPolicy() {
            
            let privacyPolicyText = """
            PRIVACY POLICY

            Effective Date: 08/01/2024

            Welcome to JoinMe! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our social media app. By using JoinMe, you agree to the collection and use of information in accordance with this policy.

            1. INFORMATION WE COLLECT

            1.1 Personal Information
            We may collect personal information that you provide directly to us, such as your name, email address, profile picture, and any other details you choose to provide when creating or updating your account.

            1.2 Usage Data
            We automatically collect information about your interactions with the app, such as your IP address, device type, browser type, and usage patterns. This helps us improve our services and understand user behavior.

            1.3 Communication Data
            If you contact us for support or feedback, we may collect information from your communications with us.

            2. HOW WE USE YOUR INFORMATION

            2.1 To Provide and Improve Our Services
            We use your information to operate and maintain JoinMe, personalize your experience, and improve our app based on your feedback and usage patterns.

            2.2 To Communicate With You
            We may use your contact information to send you updates, promotional materials, or other information related to JoinMe. You can opt out of these communications at any time.

            2.3 For Research and Analytics
            We use aggregated data for research and analytics to understand user needs and enhance our app’s functionality.

            3. HOW WE SHARE YOUR INFORMATION

            3.1 With Your Consent
            We may share your information with third parties if you provide your explicit consent for us to do so.

            3.2 Service Providers
            We may share your information with third-party service providers who assist us in operating JoinMe, such as hosting services or analytics providers. These parties are contractually obligated to protect your information and use it only for the purposes for which it was shared.

            3.3 Legal Requirements
            We may disclose your information if required to do so by law or in response to valid legal requests.

            4. DATA SECURITY

            We implement reasonable measures to protect your information from unauthorized access, alteration, or disclosure. However, no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.

            5. YOUR CHOICES

            5.1 Access and Update
            You can access and update your personal information through your account settings on JoinMe.

            5.2 Opt-Out
            You can opt out of receiving promotional communications from us by following the unsubscribe instructions in those messages or adjusting your account settings.

            5.3 Deleting Your Account
            If you wish to delete your account, please contact us at [support@joinme.com]. We will process your request as soon as possible.

            6. CHANGES TO THIS PRIVACY POLICY

            We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy on JoinMe. Your continued use of the app after any changes constitutes your acceptance of the revised policy.

            7. CONTACT US

            If you have any questions about this Privacy Policy or our practices, please contact us at:

            Email: support@joinme.com

            Thank you for using JoinMe! :)
            """
            
            privacyPolicyTextView.text = privacyPolicyText
        }

}
