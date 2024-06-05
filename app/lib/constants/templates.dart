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

const String kTermsAndConditionsMarkdown = r'''
ACCEPTABLE USE POLICY
=====================

(Incorporating guidance to Members in managing encounters and relationships established with other Members)

**Guidelines**

The terms set out below, are terms that you have already agreed to in becoming a Member of Positive+1. The terms are part of the terms and conditions for use of the Positive+1 platform and are repeated here to help you access them when you want to check the requirements we make. When we refer to Service we mean the features available with your use of the App

**You must:**

*   Not use the App or any Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these terms, or act fraudulently or maliciously, for example, by hacking into or inserting malicious code, such as viruses, or harmful data, into the App, any Service or any operating system;
    
*   Not infringe our intellectual property rights or those of any third party in relation to your use of the App or any Service, including by the submission of any material (to the extent that such use is not licensed by these terms);
    
*   Not transmit any material that is defamatory, offensive or otherwise objectionable in relation to your use of the App or any Service;
    
*   Not use the App or any Service in a way that could damage, disable, overburden, impair or compromise our systems or security or interfere with other users;
    
*   Not collect or harvest any information or data from any Service or our systems or attempt to decipher any transmissions to or from the servers running any Service.
    
*   In addition, your use of the App must at all times be in compliance with and support the operation of our guidelines and principles of acceptable use contained within this policy, all of which are provided to you below.
    

**Upload only your own photos**

We take copyrights very seriously. If you don’t own the rights to a photo or video, please don’t post it.

**Respect all users**

We are a very diverse community. This means you should respect other people’s beliefs, interests, and property while on Positive+1. Positive+1 takes a strong stance against hate speech, rude or abusive behaviour, bullying, and misogyny. You should behave the same way on Positive+1 as you would in real life. Additionally, we encourage all of our users to report anyone who does not follow these behavioural guidelines. As a community rooted in kindness and respect, we expect all of our users to respect each other, themselves, and the Positive+1 team.

**Send original messages to other users**

We strongly advise against copying and pasting the same message to every connection. We encourage our users to read profiles, learn about other people’s interests, and send an appropriate, relevant message to each match. We promise this will increase your chances of engaging in interesting conversations.

**Don’t pretend you’re someone you’re not**

As previously stated, do not post photos that are not of you. It is policy to use a photo verification tool to let other Members know that your profile is legitimate.

**Positive+1 photo guidelines**

*   No children on their own. They must be in the photo with an adult, and fully clothed.
    
*   Your face must be clearly visible in all photos. No watermarks or text overlaid. No pornographic or nude material.
    
*   No graphic hunting photos.
    
*   No guns or violence
    
*   No other clothing or messages that would otherwise breach this acceptable use policy
    

**Don’t do anything illegal on our app**

Illegal activity will not be tolerated on Positive+1. This may result in being banned from the site, and/or being reported to the authorities.

**No soliciting**

Positive+1 isn’t for selling things. If you try to use it as a marketplace, you’ll be banned.

**No kids on their own, they must be in the photo with an adult & fully clothed**

Positive+1 is for 18+ years, therefore we don’t allow children to be alone in photos as representatives of their parents on Positive+1. In addition, all children must be completely clothed. This is safer for both children and their parents.

If you don’t follow these guidelines, you’ll receive a warning (unless our team decides to block without warning at our discretion). If you ignore this warning, you risk losing your account. These guidelines are designed to make Positive+1 a friendly and safe place for all our users.

TERMS AND CONDITIONS - PLEASE READ THESE LICENCE TERMS CAREFULLY
----------------------------------------------------------------

**1\. WHO WE ARE AND WHAT THIS AGREEMENT DOES**

1.1. We Positive Plus One Limited (CRN: 11394568) of 2 Collingwood Street, Newcastle, Newcastle-Upon-Tyne, England, NE1 1JF licence you to use:

1.1.1. the Positive+1 mobile application software, the data supplied with the software, (App) and any updates or supplements to it; and

1.1.2. the premium (paid for services that you may wish to take advantage of (whether available on a subscription or pay as you go (purchase of credits) basis).

1.2. When we refer to “Services” we refer to the functionality that we provide within the App from time to time. We distinguish Services that are only available on payment being made by you as explained later in these Terms.

**2\. YOUR PRIVACY**

2.1. We only use any personal data we collect through your use of the App and the Services in the ways set out in our Privacy Policy on our website.

2.2. Positive+1 does its utmost to ensure the safety of all Members. You must appreciate the way in which through your use of the App you are making personal information about yourself including your HIV status public to other Members.

2.3. Please be aware that internet transmissions are never completely private or secure and that any message or information you send using the App or any Service may be read or intercepted by others. We endeavour to mitigate this risk so far as reasonably practicable including through the provision of end to end encryption in relation to chat messages that you may transmit and receive.

**3\. ADDITIONAL TERMS FOR SPECIFIC SERVICES**

In addition your use of the App and Services that you subscribe to and purchase will be governed by the terms of use and privacy policies of Positive Plus One Limited and such other policies as we may notify you from time to time. Please review our Privacy Policy here [www.positiveplusone.com/privacy-policy](https://www.positiveplusone.com/privacy-policy) to check out other relevant organisations and their policies.

**4\. ELIGIBILITY**

4.1. Positive+1 makes this App available only to individuals who are 18 years of age or over. If you have reason to believe that the App is being used in breach of this condition we ask that you draw our attention to the circumstances using the ‘Raise a Red Flag’ function on the App.

4.2. Accordingly, you must be 18 years of age or over to accept these terms and purchase In-App Services, create an account with us and/or use the App. By creating an account and using the App whether with or without the Services, you represent and warrant to us that:

4.2.1. you can form a binding contract with Positive Plus One Limited;

4.2.2. you will comply with these terms;

4.2.3. you are at least 18 years old; and

4.2.4. you have read the ‘Guidelines’ and Acceptable Use Policy (incorporating User Guidance) (“Acceptable Use Policy”) and understand that you are required to use the App in accordance with these requirements.

**5\. CREATING AN ACCOUNT**

5.1. You can create an account by either:

5.1.1. through you Apple account;

5.1.2. by using your Facebook account; or

5.1.3. by using your Google account.

5.2. If you create an account using any of the above, you authorise Positive+1, to access, display and use certain information from your account. Please also refer to our Privacy Policy as this explains the data we access at this stage in your registration process.

5.3. By creating an account, you confirm that you understand that:

5.3.1. you are solely responsible for your interactions with other users when using the App; and

5.3.2. you are solely responsible for the content you make available through your published profile and the interactions you have with other users;

5.3.3. Positive Plus One Limited will always take steps to validate the identity of users. Please note that WE DO NOT conduct any background checks (and by law we are unable to carry out criminal background checks) on any user;

5.3.4. we are not responsible for the conduct of any users in relation to their interactions with you or other users of Positive+1; and

5.3.5. should you continue to engage with a user in another platform (e.g WhatsApp) we recommend that you apply a high level of personal security precautions.

5.4. Your login details must not be shared under any circumstances.

**6\. APP STORE TERMS ALSO APPLY**

The ways in which you can use the App may also be controlled by the rules and policies of the third party web or mobile application platforms or storefronts authorised by us (including but not limited to the Apple App Store and/or Google Play Store) (the “Appstore”) and such rules and policies will apply instead of these terms to the extent that there are differences between the two.

**7\. OPERATING SYSTEM REQUIREMENTS**

This App requires operating systems of iOS 10 or Android 5.1 (as applicable) or later.

**8\. SUPPORT FOR THE APP AND HOW TO TELL US ABOUT PROBLEMS**

8.1. Support. If you want to learn more about the App or the Service or have any problems using them please take a look at our support resources by using the ‘Raise a Red Flag’ function on the App.

8.2. Contact us (including with complaints). If you think the App or the Services are faulty or misdescribed or wish to contact us for any other reason please contact our customer service team by using the ‘Raise a Red Flag’ function on the App.

8.3. How we will communicate with you. If we have to contact you we will do so by email, by SMS or telephone using the contact details available to us. Please remember to keep your contact details up to date at all times.

8.4. Summary of your key legal rights (please review also paragraph 21)

8.4.1. We are under a legal duty to supply products that are in conformity with this contract. We summarise in this section your key legal rights in relation to the App. Nothing in these terms will affect your legal rights.

8.4.2. This is only a summary of your key legal rights. They are also subject to certain exceptions. For detailed information please visit the Citizens Advice website [https://www.adviceguide.org.uk](http://www.adviceguide.org.uk) or call 03454 04 05 06. Please note these details may change from time to time. If outside of the United Kingdom your rights may differ and you should seek advice from the most appropriate local consumer organisation.

8.4.3. The Consumer Rights Act 2015 says digital content must be as described, fit for purpose and of satisfactory quality.

8.4.4. It is generally recognised that notwithstanding our best efforts, the App may not be error free. We will always endeavour to correct problems by updating the App as quickly as possible when we become aware of an issue.

8.4.5. If the fault can’t be fixed, or if it hasn’t been fixed within a reasonable time and without significant inconvenience, you may be entitled to get some or all of your money back for any Premium Services (see below) you have been unable to take advantage of as a result of the fault.

8.4.6. If you can show the fault has damaged your device and we haven’t used reasonable care and skill, you may be entitled to a repair or compensation.

**9\. HOW YOU MAY USE THE APP, INCLUDING HOW MANY DEVICES YOU MAY USE IT ON**

9.1. In return for your agreeing to comply with these terms you may:

9.1.1. download a copy of the App to your devices as permitted by your App Store and view, and use the App including Services that you subscribe to on such devices for your personal purposes only;

9.1.2. receive and use any free supplementary software code or update of the App incorporating "patches" and corrections of errors or arising out of version updates as we may provide to you.

**10\. YOU MAY NOT TRANSFER THE APP TO SOMEONE ELSE**

Your account will be registered to you through your personal AppStore account. Accordingly, your right to use the App and the Services are personal to you. You may not otherwise transfer the App or the Services or any credits that you may have associated with the purchase of a Service to someone else, whether for money, for anything else or for free. If you sell any device on which the App is installed, you must remove the App from it.

**11\. CHANGES TO THESE TERMS**

11.1. We may need to change these terms to reflect changes in law or best practice or to deal with additional features which we introduce from time to time.

11.2. We will notify you of a change when you next start the App.

11.3. If you do not accept the notified changes your ability to enjoy the functionality of the App including the ability to take advantage of Services may be impaired.

**12\. UPDATE TO THE APP AND CHANGES TO THE SERVICE**

12.1. From time to time we will provide updates to the App to improve performance, enhance functionality, reflect changes to the operating system or address security issues. If you have automatic updating (where available) turned off or where functionality in your device does not provide for automatic updating you will need to manually update your device following the relevant AppStore guidance.

12.2. If you choose not to install such updates or if you opt out of automatic updates you may not be able to continue using the App and the Services.

12.3. We will not act in a way that is contrary to your rights or make your obligations owed to us more onerous where your consumer rights are relevant.

**13\. IF SOMEONE ELSE OWNS THE PHONE OR DEVICE YOU ARE USING**

If you download the App onto any phone or other device not owned by you, you must have the owner's permission to do so. You will be responsible for complying with these terms, whether or not you own the phone or other device.

**14\. THIRD PARTY STORES, PREMIUM SERVICES AND IN-APP PURCHASES**

14.1. We may make certain products and/or services available to you for a subscription fee including but not limited to Positive+1 Boost (“Subscription Services”). We also may make certain services available to you for a one-off fee including but not limited to Positive+1 Coins (“In-App Purchases”). In these terms Subscription Services and In-App Purchases are referred to as “Premium Services”.

14.2. If you choose to take advantage of any Premium Services, you accept and acknowledge that additional terms and conditions may apply to such services in addition to these terms and those such terms and conditions shall be incorporated into these terms.

14.3. If you choose to purchase a Premium Service you will do so through the App store and payment will be made through that Appstore’s available payment methods. Once you have requested to use such Premium Service you authorise us to charge you by your chosen payment method registered with the AppStore.

14.4. Subscription Services will be provided and charged for a period that may comprise one week, one month or any period as otherwise determined by us from time to time. If you choose to purchase a Subscription Service, your subscription will automatically renew (for the same term) until you terminate or cancel the subscription.

14.5. The payment for any subscription will be made via your App Store. If you cancel your Subscription Services during any given subscription term you will be permitted to use such Subscription Services until the end of that subscription term and your subscription will not be renewed after the current subscription term expires.

14.6. To cancel the Subscription Service follow the procedures required by the AppStore, making sure that you register the cancellation at least 24 hours prior to the renewal date.

14.7. In-App Purchases will be provided and charged as and when they are selected by you and payment will be made via your chosen payment method listed above. In-App Purchases will automatically expire on the first anniversary of purchase. Please note that expiry may be earlier in the event that we decide to terminate a particular Service (see the next paragraph).

14.8. We may from time to time change the services we provide and which are designated Premium Services. We will give not less than three months’ notice of any proposed changes. We may terminate the operation of any Service. Please ensure that any In-App purchases you have made are used prior to the termination of any Service that the In-App purchase may be applied to.

14.9. If we do not receive payment by you for the Premium Services and/or In-App Purchases you hereby undertake to pay all sums due to us immediately on demand.

14.10. Refunds are not available for Premium Services.

**15\. WE MAY COLLECT TECHNICAL DATA ABOUT YOUR DEVICE**

15.1. By using the App or any of the Services, you agree to us collecting and using technical information about the devices you use the App on and related software, hardware and peripherals to improve our products and to provide any Services to you.

**16\. WE MAY COLLECT LOCATION DATA (BUT YOU CAN TURN LOCATION SERVICES OFF) AND PUSH NOTIFICATIONS**

16.1. Certain Services (e.g. GPS and Bluetooth) will make use of location data sent from your devices. You can turn off this functionality at any time by turning off the location services settings for the App on the device. If you use these Services, you consent to us and our affiliates' and licensees' transmission, collection, retention, maintenance, processing and use of your location data and queries to provide and improve location-based products and services.

16.2. You may stop us collecting such data at any time by turning off the location services settings in the applicable settings in the App. But please remember that particular functionality in the App will be impaired or become unavailable through the non-availability of location based information.

16.3. We may provide you with emails, texts, push notifications, alerts and messaging of whatever kind relating to the App and the Services. To unsubscribe from communications by email, text and other forms of messaging please follow the instructions given in the communications and to turn off push notifications, please alter the applicable settings on your device.

**17\. WE ARE NOT RESPONSIBLE FOR OTHER WEBSITES YOU LINK TO**

17.1. The App may contain links to other independent websites which are not provided by us. Such independent sites are not under our control, and we are not responsible for and have not checked and approved their content or their privacy policies (if any).

17.2. You will need to make your own independent judgement about whether to use any such independent sites, including whether to buy any products or services offered by them.

**18\. LICENCE RESTRICTIONS**

18.1. You agree that you will:

18.1.1. not rent, lease, sub-license, loan, provide, or otherwise make available, the App or the Services in any form, in whole or in part to any person without prior written consent from us;

18.1.2. not copy the App, Documentation or Services, except as part of the normal use of the App or where it is necessary for the purpose of back-up or operational security;

18.1.3. not translate, merge, adapt, vary, alter or modify, the whole or any part of the App, Documentation or Services nor permit the App or the Services or any part of them to be combined with, or become incorporated in, any other programs, except as necessary to use the App and the Services on devices as permitted in these terms;

18.1.4. not disassemble, de-compile, reverse engineer or create derivative works based on the whole or any part of the App or the Services nor attempt to do any such things, except to the extent that (by virtue of sections 50B and 296A of the Copyright, Designs and Patents Act 1988) such actions cannot be prohibited because they are necessary to decompile the App to obtain the information necessary to create an independent program that can be operated with the App or with another program (Permitted Objective), and provided that the information obtained by you during such activities:

18.1.4.1. is not disclosed or communicated without the Licensor's prior written consent to any third party to whom it is not necessary to disclose or communicate it in order to achieve the Permitted Objective; and

18.1.4.2. is not used to create any software that is substantially similar in its expression to the App; and

18.1.4.3. is kept secure; and

18.1.4.4. is used only for the Permitted Objective; and

18.1.4.5. comply with all applicable technology control or export laws and regulations that apply to the technology used or supported by the App or any Service.

**19\. ACCEPTABLE USE RESTRICTIONS**

19.1. You must:

19.1.1. not use the App or any Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these terms, or act fraudulently or maliciously, for example, by hacking into or inserting malicious code, such as viruses, or harmful data, into the App, any Service or any operating system;

19.1.2. not infringe our intellectual property rights or those of any third party in relation to your use of the App or any Service, including by the submission of any material (to the extent that such use is not licensed by these terms);

19.1.3. not transmit any material that is defamatory, offensive or otherwise objectionable in relation to your use of the App or any Service;

19.1.4. not use the App or any Service in a way that could damage, disable, overburden, impair or compromise our systems or security or interfere with other users;

19.1.5. not collect or harvest any information or data from any Service or our systems or attempt to decipher any transmissions to or from the servers running any Service.

19.2. In addition your use of the App must at all times be in compliance with and support the operation of our guidance and principles of acceptable use all of which are provided to you in our Acceptable Use Policy (see links above).

19.3. We reserve the right to terminate your access to the App immediately and without prior notice in the event that there is evidence provided to or available to us that is considered by us to be credible that you are in breach of these licence terms or the Acceptable Use Policy or on any other basis where we consider it necessary in the interests of our other Members to terminate your access rights.

**20\. INTELLECTUAL PROPERTY RIGHTS**

All intellectual property rights in the App, and the Services throughout the world belong to us (or our licensors) and the rights in the App and any functionality that allows us to provide Services are licensed (not sold) to you. You have no intellectual property rights in, or to, the App or the Services other than the right to use them in accordance with these terms.

**21\. OUR RESPONSIBILITY FOR LOSS OR DAMAGE SUFFERED BY YOU**

21.1. Our Responsibility is Limited. The Services might not work perfectly or at all. We do not warrant that the Services will be error free, and they may be interrupted at any time. If errors do occur, we might not fix them immediately or at all but your rights as a consumer shall not be affected and we will at all times observe these.

21.2. Services may vary. The look and feel of the Services may vary from that shown in images on our website or any advertising.

21.3. User Content Generated. Any content generated by any of our Users is notwithstanding the requirements of our Acceptable Use Policy out of our control and we are not responsible for any actions, comments or materials uploaded by users of our Services.

21.4. We are responsible to you for foreseeable loss and damage caused by us. If we fail to comply with these terms, we are responsible for loss or damage you suffer that is a foreseeable result of our breaking these terms or our failing to use reasonable care and skill, but we are not responsible for any loss or damage that is not foreseeable. Loss or damage is foreseeable if either it is obvious that it will happen or if, at the time you accepted these terms, both we and you knew it might happen.

21.5. We do not exclude or limit in any way our liability to you where it would be unlawful to do so. This includes liability for death or personal injury caused by our negligence or the negligence of our employees, agents or subcontractors to the extent that we are at law deemed responsible (but not otherwise) or for fraud or fraudulent misrepresentation.

21.6. When we are liable for damage to your property. If defective digital content that we have supplied damages a device or digital content belonging to you, we will pay you compensation. However, we will not be liable for damage that you could have avoided by following our advice to apply an update offered to you free of charge or for damage that was caused by you failing to correctly follow installation instructions or to have in place the minimum system requirements advised by us.

21.7. We are not liable for business losses. The App is for domestic and private use. If you use the App for any commercial, business or resale purpose we will have no liability to you for any loss of profit, loss of business, business interruption, or loss of business opportunity.

21.8. Limitations to the App and the Services. The App and the Services are provided for the specific purposes described in our marketing literature and as appears in the AppStores only. You are strongly advised to follow guidance that we provide within the Acceptable Use Policy and to apply all other appropriate precautions when engaging with other users.

21.9. Please back-up content and data used with the App. We recommend that you back up any content and data used in connection with the App, to protect yourself in case of problems with the App or the Service.

21.10. Check that the App and the Services are suitable for you. The App and the Services have not been developed to meet your individual requirements. Please check that the facilities and functions of the App and the Services (as described on the relevant Appstore site meet your requirements.

21.11. We are not responsible for events outside our control. If availability of Services you have paid for under the App or the availability of App functionality is impaired or becomes unavailable for any reason or there is any temporary limitation in the functionality of the App caused by an event outside our control then on becoming aware we will contact you as soon as possible to let you know and we will take steps to minimise the effect of the delay. We will not be liable for delays caused by the event unless under rights available to you as a consumer we are responsible (see below as to what we mean by this). If there is a risk of substantial delay you may contact us to end your contract with us and receive a refund for any Services you have paid for but not received.

21.12. Our aggregate liability under these terms shall be capped at the value of the payments you have made for Premium Services in the 24 month period up to date upon which you cancel your contract with us.

21.13. You shall indemnify and hold harmless us against and you promise to pay to us, on demand all amounts in respect of any and all liabilities, costs, expenses, damages and losses (including but not limited to any direct, indirect or consequential losses, loss of profit, loss of reputation and all interest, penalties and legal costs (calculated on a full indemnity basis) and all other professional costs and expenses) suffered or incurred by us arising out of or in connection with a breach of these terms or Acceptable Use Policy.

**22\. WE MAY END YOUR RIGHTS TO USE THE APP AND THE SERVICES IF YOU BREAK THESE TERMS**

22.1. We may end your rights to use the App and withdraw any Services without liability to make any refund at any time in the circumstances referred to at paragraph 19.3. We may, at our absolute discretion, give you a reasonable opportunity to put right what you have done if appropriate.

22.2. We reserve the right to view, delete, remove, hide, disable or suspend your account or restrict other Users rights to access your Profile (including the right to suspend messaging functionality) in circumstances where you are found to be or may be in breach of these terms and conditions and/or our Acceptable Use Policy.

22.3. If we end your rights to use the App and/or withdraw your access to Services:

22.3.1. You must stop all activities authorised by these terms, including your use of the App and any Services to the extent that access is notified to you as withdrawn.

22.3.2. You must where your membership is withdrawn completely delete or remove the App from all devices in your possession and immediately destroy all copies of the App which you have and confirm to us that you have done this where we request this.

22.3.3. Where functionality permits this, we or the relevant AppStore on our behalf may remotely access your devices and remove the App and restrict your right to re-download as well as ceasing to provide you with access to the Services.

**23\. WE MAY TRANSFER THIS AGREEMENT TO SOMEONE ELSE**

We may transfer our rights and obligations under these terms to another organisation. We will always tell you in writing if this happens and we will ensure that the transfer will not affect your rights under the contract.

**24\. YOU NEED OUR CONSENT TO TRANSFER YOUR RIGHTS TO SOMEONE ELSE**

You may only transfer your rights or your obligations under these terms to another person if we agree in writing.

**25\. CANCELLATION**

Should you wish to cancel your account you can do so by going to the account settings on the App. Generally, refunds are not available for any payments made by you in relation to the App (including, for the avoidance of doubt, payments made in relation to Premium Services).

**26\. NO RIGHTS FOR THIRD PARTIES**

This agreement does not give rise to any rights under the Contracts (Rights of Third Parties) Act 1999 enabling any other party to enforce any term of this agreement.

**27\. IF A COURT FINDS PART OF THIS CONTRACT ILLEGAL, THE REST WILL CONTINUE IN FORCE**

Each of the paragraphs of these terms operates separately. If any court or relevant authority decides that any of them are unlawful, the remaining paragraphs will remain in full force and effect.

**28\. EVEN IF WE DELAY IN ENFORCING THIS CONTRACT, WE CAN STILL ENFORCE IT LATER**

Even if we delay in enforcing this contract, we can still enforce it later. If we do not insist immediately that you do anything you are required to do under these terms, or if we delay in taking steps against you in respect of your breaking this contract, that will not mean that you do not have to do those things and it will not prevent us taking steps against you at a later date.

**29\. WHICH LAWS APPLY TO THIS CONTRACT AND WHERE YOU MAY BRING LEGAL PROCEEDINGS**

29.1. These terms are governed by English law and you can bring legal proceedings in respect of the products in the English courts. If you live in Scotland you can bring legal proceedings in respect of the products in either the Scottish or the English courts. If you live in Northern Ireland you can bring legal proceedings in respect of the products in either the Northern Irish or the English courts.

29.2. You agree that we may enforce this Agreement in any other legal jurisdiction in which you are resident or present at the time any issue arises that requires the taking of legal proceedings.

''';
