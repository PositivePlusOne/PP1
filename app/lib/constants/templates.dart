// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';

String userReportTemplate(Profile reportee, Profile reporter, String comment) {
  final reportData = {
    'reporterId': reporter.flMeta?.id,
    'reporterDisplayName': reporter.displayName,
    'reportedUserId': reportee.flMeta?.id,
    'reportedUserDisplayName': reportee.displayName,
    'comment': comment,
  };

  final reportJson = json.encode(reportData);
  return reportJson;
}

String postReportTemplate(String reportedPostID, Profile reportee, Profile reporter, String comment) {
  final reportData = {
    'reporterId': reporter.flMeta?.id,
    'reporterDisplayName': reporter.displayName,
    'reportedUserId': reportee.flMeta?.id,
    'reportedUserDisplayName': reportee.displayName,
    'reportedPostID': reportedPostID,
    'comment': comment,
  };

  final reportJson = json.encode(reportData);
  return reportJson;
}

const String kTermsAndConditionsMarkdown =
    '''
# ACCEPTABLE USE POLICY

## Guidelines

The terms set out below are part of the terms and conditions for the use of the Positive+1 platform. They are provided to ensure a respectful and lawful use of the Positive+1 App and Services.

### You must:

- Not use the App or any Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these terms.
- Not infringe our intellectual property rights or those of any third party in relation to your use of the App or any Service.
- Not transmit any material that is defamatory, offensive, or otherwise objectionable in relation to your use of the App or any Service.
- Not use the App or any Service in a way that could damage, disable, overburden, impair, or compromise our systems or security or interfere with other users.
- Not collect or harvest any information or data from any Service or our systems or attempt to decipher any transmissions to or from the servers running any Service.

### Positive+1 Community Guidelines:

- **Upload only your own photos**: Respect copyright laws.
- **Respect all users**: Promote diversity and kindness within the community.
- **Send original messages to other users**: Personalize your interactions.
- **Don’t pretend you’re someone you’re not**: Use photo verification tools to authenticate your identity.
- **Follow Positive+1 photo guidelines**: Ensure photos are appropriate and meet our guidelines.
- **Don’t do anything illegal on our app**: Illegal activity is strictly prohibited.
- **No soliciting**: Positive+1 is not a marketplace.

## TERMS AND CONDITIONS - PLEASE READ THESE LICENCE TERMS CAREFULLY

### 1. WHO WE ARE AND WHAT THIS AGREEMENT DOES

1.1. We, Positive Plus One Limited, license you to use the Positive+1 mobile application software and any updates or supplements to it.

### 2. YOUR PRIVACY

2.1. Your personal data is used only as set out in our Privacy Policy.

### 3. ADDITIONAL TERMS FOR SPECIFIC SERVICES

Your use of the App and Services is governed by additional terms, including our Privacy Policy.

### 4. ELIGIBILITY

4.1. The App is available to individuals who are 18 years of age or over.

### 5. CREATING AN ACCOUNT

You can create an account using your Apple, Facebook, or Google account.

### 6. APP STORE TERMS ALSO APPLY

The use of the App is also controlled by the Appstore's rules and policies.

### 7. OPERATING SYSTEM REQUIREMENTS

Requires iOS 10 or Android 5.1 or later.

### 8. SUPPORT FOR THE APP AND HOW TO TELL US ABOUT PROBLEMS

For support or to report problems, use the ‘Raise a Red Flag’ function on the App.

### 9. HOW YOU MAY USE THE APP, INCLUDING HOW MANY DEVICES YOU MAY USE IT ON

9.1. In return for agreeing to comply with these terms, you may:
- Download a copy of the App to your devices as permitted by your App Store and use the App including Services that you subscribe to on such devices for your personal purposes only.
- Receive and use any free supplementary software code or updates of the App incorporating "patches" and corrections of errors or arising out of version updates as we may provide to you.

### 10. YOU MAY NOT TRANSFER THE APP TO SOMEONE ELSE

Your account will be registered to you through your personal AppStore account. Accordingly, your right to use the App and the Services are personal to you. You may not otherwise transfer the App or the Services or any credits that you may have associated with the purchase of a Service to someone else. If you sell any device on which the App is installed, you must remove the App from it.

### 11. CHANGES TO THESE TERMS

11.1. We may need to change these terms to reflect changes in law or best practice or to deal with additional features which we introduce.
11.2. We will notify you of a change when you next start the App.
11.3. If you do not accept the notified changes your ability to enjoy the functionality of the App including the ability to take advantage of Services may be impaired.

### 12. UPDATE TO THE APP AND CHANGES TO THE SERVICE

12.1. From time to time we will provide updates to the App to improve performance, enhance functionality, reflect changes to the operating system, or address security issues.
12.2. If you choose not to install such updates or if you opt out of automatic updates you may not be able to continue using the App and the Services.

### 13. IF SOMEONE ELSE OWNS THE PHONE OR DEVICE YOU ARE USING

If you download the App onto any phone or other device not owned by you, you must have the owner's permission to do so. You will be responsible for complying with these terms, whether or not you own the phone or other device.

### 14. THIRD PARTY STORES, PREMIUM SERVICES AND IN-APP PURCHASES

14.1. We may make certain products and/or services available to you for a subscription fee including but not limited to Positive+1 Boost (“Subscription Services”) and Positive+1 Coins (“In-App Purchases”). These are collectively referred to as “Premium Services”.
14.2. If you choose to take advantage of any Premium Services, additional terms and conditions may apply.
14.3. Purchases of Premium Services will be made through the App store and charged to your chosen payment method registered with the AppStore.
14.4. Subscription Services automatically renew until cancelled. To cancel, follow the procedures required by the AppStore.
14.5. In-App Purchases are charged as selected by you and will automatically expire on the first anniversary of purchase unless used prior to the termination of any Service.

### 15. WE MAY COLLECT TECHNICAL DATA ABOUT YOUR DEVICE

By using the App or any of the Services, you agree to us collecting and using technical information about the devices you use the App on to improve our products and to provide any Services to you.

### 16. LOCATION DATA AND PUSH NOTIFICATIONS

16.1. We use location data from your devices for certain Services, which you can disable at any time by turning off the location services settings for the App on the device.
16.2. You may stop us from collecting such data at any time by turning off the location services settings in the App.
16.3. We may provide you with communications related to the App and the Services. To unsubscribe, follow the instructions provided in the communications.

### 17. LINKS TO OTHER WEBSITES

17.1. The App may contain links to other independent websites not provided by us. We are not responsible for the content or privacy policies of these sites.
17.2. You will need to make your own judgement about whether to use any such independent sites.

### 18. LICENCE RESTRICTIONS

You agree not to:
- Rent, lease, sub-license, loan, or provide the App or Services in any form to any person without prior written consent.
- Copy, except as part of the normal use of the App or for back-up purposes.
- Translate, merge, adapt, vary, alter, or modify the App or Services, except as necessary to use the App on devices as permitted by these terms.
- Disassemble, decompile, reverse engineer, or create derivative works based on the App or Services, except as permitted by law.

### 19. ACCEPTABLE USE RESTRICTIONS

You must not:
- Use the App or any Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these terms.
- Infringe our or any third party's intellectual property rights.
- Transmit any material that is defamatory, offensive, or otherwise objectionable.
- Use the App or any Service in a way that could damage, disable, overburden, impair or compromise our systems or security or interfere with other users.
- Collect or harvest any information or data from any Service or attempt to decipher any transmissions.

### 20. INTELLECTUAL PROPERTY RIGHTS

All intellectual property rights in the App, and the Services throughout the world belong to us or our licensors. You have no intellectual property rights in, or to, the App or the Services other than the right to use them in accordance with these terms.

### 21. OUR RESPONSIBILITY FOR LOSS OR DAMAGE SUFFERED BY YOU

21.1. **Our Responsibility is Limited.** The Services might not work perfectly or at all. We do not warrant that the Services will be error-free, and they may be interrupted at any time.
21.2. **Services May Vary.** The look and feel of the Services may vary from that shown in images on our website or any advertising.
21.3. **User Content Generated.** Any content generated by any of our Users is out of our control, and we are not responsible for any actions, comments, or materials uploaded by users of our Services.
21.4. **We are responsible to you for foreseeable loss and damage caused by us.** If we fail to comply with these terms, we are responsible for loss or damage you suffer that is a foreseeable result of our breaking these terms or our failing to use reasonable care and skill.
21.5. **We do not exclude or limit in any way our liability to you where it would be unlawful to do so.** This includes liability for death or personal injury caused by our negligence or the negligence of our employees, agents, or subcontractors; for fraud or fraudulent misrepresentation.
21.6. **When we are liable for damage to your property.** If defective digital content that we have supplied damages a device or digital content belonging to you and this was caused by our failure to use reasonable care and skill, we will either repair the damage or pay you compensation.
21.7. **We are not liable for business losses.** The App is for domestic and private use. If you use the App for any commercial, business, or resale purpose, we will have no liability to you for any loss of profit, loss of business, business interruption, or loss of business opportunity.

### 22. WE MAY END YOUR RIGHTS TO USE THE APP AND THE SERVICES IF YOU BREAK THESE TERMS

We may end your rights to use the App and withdraw any Services without liability to make any refund at any time if you break these terms.

### 23. WE MAY TRANSFER THIS AGREEMENT TO SOMEONE ELSE

We may transfer our rights and obligations under these terms to another organisation. We will always tell you in writing if this happens and we will ensure that the transfer will not affect your rights under the contract.

### 24. YOU NEED OUR CONSENT TO TRANSFER YOUR RIGHTS TO SOMEONE ELSE

You may only transfer your rights or your obligations under these terms to another person if we agree in writing.

### 25. CANCELLATION

Should you wish to cancel your account, you can do so by going to the account settings on the App. Generally, refunds are not available for any payments made by you in relation to the App (including, for the avoidance of doubt, payments made in relation to Premium Services).

### 26. NO RIGHTS FOR THIRD PARTIES

This agreement does not give rise to any rights under the Contracts (Rights of Third Parties) Act 1999 to enforce any term of this agreement.

### 27. IF A COURT FINDS PART OF THIS CONTRACT ILLEGAL, THE REST WILL CONTINUE IN FORCE

Each of the paragraphs of these terms operates separately. If any court or relevant authority decides that any of them are unlawful, the remaining paragraphs will remain in full force and effect.

### 28. EVEN IF WE DELAY IN ENFORCING THIS CONTRACT, WE CAN STILL ENFORCE IT LATER

Even if we delay in enforcing this contract, we can still enforce it later. If we do not insist immediately that you do anything you are required to do under these terms, or if we delay in taking steps against you in respect of your breaking this contract, that will not mean that you do not have to do those things and it will not prevent us taking steps against you at a later date.

### 29. WHICH LAWS APPLY TO THIS CONTRACT AND WHERE YOU MAY BRING LEGAL PROCEEDINGS

These terms are governed by English law and you can bring legal proceedings in respect of the products in the English courts. If you live in Scotland you can bring legal proceedings in either the Scottish or the English courts. If you live in Northern Ireland, you can bring legal proceedings in respect of the products in either the Northern Irish or the English courts.
''';
