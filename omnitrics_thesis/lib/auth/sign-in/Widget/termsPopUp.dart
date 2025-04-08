import 'package:flutter/material.dart';

class termsPop extends StatelessWidget {
  const termsPop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.deepPurple, width: 1),
                ),
                insetPadding: const EdgeInsets.all(20.0),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // Header and Last Updated
                        Text(
    'Last updated May 05, 2025',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        SizedBox(height: 10),
                        
                        // Overview
                        Text(
    'This Privacy Notice for Purple Inc. ("we," "us," or "our"), describes how and why we might access, collect, store, use, and/or share ("process") your personal information when you use our services ("Services"), including when you:',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Padding(
    padding: EdgeInsets.only(left: 16.0),
    child: Text(
      '• Download and use our mobile application (OmniTrics), or any other application of ours that links to this Privacy Notice',
      style: TextStyle(fontSize: 14),
    ),
                        ),
                        SizedBox(height: 10),
                        Padding(
    padding: EdgeInsets.only(left: 16.0),
    child: Text(
      '• Use OmniTrics. A mobile application to assist color-blind users using Image Processing',
      style: TextStyle(fontSize: 14),
    ),
                        ),
                        SizedBox(height: 10),
                        Padding(
    padding: EdgeInsets.only(left: 16.0),
    child: Text(
      '• Engage with us in other related ways, including any sales, marketing, or events',
      style: TextStyle(fontSize: 14),
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Questions or concerns?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        SizedBox(height: 5),
                        Text(
    'Reading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at omnitrics.db@gmail.com.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        
                        // Summary of Key Points
                        Text(
    'SUMMARY OF KEY POINTS',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'This summary provides key points from our Privacy Notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for.',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'What personal information do we process? ',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        Text(
    'When you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use. Learn more about personal information you disclose to us.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Do we process any sensitive personal information? ',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        Text(
    'Some of the information may be considered "special" or "sensitive" in certain jurisdictions, for example your racial or ethnic origins, sexual orientation, and religious beliefs. We may process sensitive personal information when necessary with your consent or as otherwise permitted by applicable law. Learn more about sensitive information we process.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // Table of Contents
                        Text(
    'TABLE OF CONTENTS',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        SizedBox(height: 10),
                        Text('1. WHAT INFORMATION DO WE COLLECT?', style: TextStyle(fontSize: 14)),
                        Text('2. HOW DO WE PROCESS YOUR INFORMATION?', style: TextStyle(fontSize: 14)),
                        Text('3. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?', style: TextStyle(fontSize: 14)),
                        Text('4. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?', style: TextStyle(fontSize: 14)),
                        Text('5. HOW DO WE HANDLE YOUR SOCIAL LOGINS?', style: TextStyle(fontSize: 14)),
                        Text('6. HOW LONG DO WE KEEP YOUR INFORMATION?', style: TextStyle(fontSize: 14)),
                        Text('7. HOW DO WE KEEP YOUR INFORMATION SAFE?', style: TextStyle(fontSize: 14)),
                        Text('8. DO WE COLLECT INFORMATION FROM MINORS?', style: TextStyle(fontSize: 14)),
                        Text('9. WHAT ARE YOUR PRIVACY RIGHTS?', style: TextStyle(fontSize: 14)),
                        Text('10. CONTROLS FOR DO-NOT-TRACK FEATURES', style: TextStyle(fontSize: 14)),
                        Text('11. DO WE MAKE UPDATES TO THIS NOTICE?', style: TextStyle(fontSize: 14)),
                        Text('12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?', style: TextStyle(fontSize: 14)),
                        Text('13. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 20),
                        
                        // 1. WHAT INFORMATION DO WE COLLECT?
                        Text(
    '1. WHAT INFORMATION DO WE COLLECT?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Personal information you disclose to us',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        Text(
    'In Short: We collect personal information that you provide to us.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We collect personal information that you voluntarily provide to us when you register on the Services, express an interest in obtaining information about us or our products and Services, when you participate in activities on the Services, or otherwise when you contact us.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Personal Information Provided by You. The personal information that we collect depends on the context of your interactions with us and the Services, the choices you make, and the products and features you use. The personal information we collect may include the following:',
    style: TextStyle(fontSize: 14),
                        ),
                        Text('• names', style: TextStyle(fontSize: 14)),
                        Text('• email addresses', style: TextStyle(fontSize: 14)),
                        Text('• passwords', style: TextStyle(fontSize: 14)),
                        Text('• usernames', style: TextStyle(fontSize: 14)),
                        Text('• gender', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 10),
                        Text(
    'Sensitive Information. When necessary, with your consent or as otherwise permitted by applicable law, we process the following categories of sensitive information:',
    style: TextStyle(fontSize: 14),
                        ),
                        Text('• health data', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 10),
                        Text(
    'Social Media Login Data. We may provide you with the option to register with us using your existing social media account details, like your Facebook, X, or other social media account. If you choose to register in this way, we will collect certain profile information about you from the social media provider, as described in the section called "HOW DO WE HANDLE YOUR SOCIAL LOGINS?" below.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Application Data. If you use our application(s), we also may collect the following information if you choose to provide us with access or permission:',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Mobile Device Access. We may request access or permission to certain features from your mobile device, including your mobile device\'s camera, sensors, storage, and other features. If you wish to change our access or permissions, you may do so in your device\'s settings.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Mobile Device Data. We automatically collect device information (such as your mobile device ID, model, and manufacturer), operating system, version information and system configuration information, device and application identification numbers, browser type and version, hardware model, Internet service provider and/or mobile carrier, and Internet Protocol (IP) address (or proxy server). If you are using our application(s), we may also collect information about the phone network associated with your mobile device, your mobile device’s operating system or platform, the type of mobile device you use, your mobile device’s unique device ID, and information about the features of our application(s) you accessed.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'All personal information that you provide to us must be true, complete, and accurate, and you must notify us of any changes to such personal information.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Information automatically collected',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
    ),
                        ),
                        Text(
    'In Short: Some information — such as your Internet Protocol (IP) address and/or browser and device characteristics — is collected automatically when you visit our Services.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We automatically collect certain information when you visit, use, or navigate the Services. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about how and when you use our Services, and other technical information. This information is primarily needed to maintain the security and operation of our Services, and for our internal analytics and reporting purposes.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'The information we collect includes:',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        Text(
    '• Log and Usage Data. Log and usage data is service-related, diagnostic, usage, and performance information our servers automatically collect when you access or use our Services and which we record in log files. Depending on how you interact with us, this log data may include your IP address, device information, browser type, and settings and information about your activity in the Services (such as the date/time stamps associated with your usage, pages and files viewed, searches, and other actions you take such as which features you use), device event information (such as system activity, error reports (sometimes called "crash dumps"), and hardware settings).',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• Device Data. We collect device data such as information about your computer, phone, tablet, or other device you use to access the Services. Depending on the device used, this device data may include information such as your IP address (or proxy server), device and application identification numbers, location, browser type, hardware model, Internet service provider and/or mobile carrier, operating system, and system configuration information.',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• Location Data. We collect location data such as information about your device\'s location, which can be either precise or imprecise. How much information we collect depends on the type and settings of the device you use to access the Services. For example, we may use GPS and other technologies to collect geolocation data that tells us your current location (based on your IP address). You can opt out of allowing us to collect this information either by refusing access to the information or by disabling your Location setting on your device. However, if you choose to opt out, you may not be able to use certain aspects of the Services.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 2. HOW DO WE PROCESS YOUR INFORMATION?
                        Text(
    '2. HOW DO WE PROCESS YOUR INFORMATION?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We process your personal information for a variety of reasons, depending on how you interact with our Services, including:',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
                        ),
                        Text(
    '• To facilitate account creation and authentication and otherwise manage user accounts.',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• To request feedback and contact you about your use of our Services.',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• To deliver targeted advertising and develop personalized content tailored to your interests and location.',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• To evaluate and improve our Services, products, marketing, and your experience.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 3. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?
                        Text(
    '3. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: We may share information in specific situations described in this section and/or with the following categories of third parties.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Vendors, Consultants, and Other Third-Party Service Providers. We may share your data with third-party vendors, service providers, contractors, or agents ("third parties") who perform services for us or on our behalf and require access to such information to do that work. We have contracts in place with our third parties, which are designed to help safeguard your personal information. This means that they cannot do anything with your personal information unless we have instructed them to do it. They will also not share your personal information with any organization apart from us. They also commit to protect the data they hold on our behalf and to retain it for the period we instruct.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'The categories of third parties we may share personal information with are as follows:',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        Text(
    '• Data Storage Service Providers',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• User Account Registration & Authentication Services',
    style: TextStyle(fontSize: 14),
                        ),
                        Text(
    '• Data Analytics Services',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We also may need to share your personal information in the following situations:',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
                        ),
                        Text(
    '• Business Transfers. We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 4. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?
                        Text(
    '4. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: We may use cookies and other tracking technologies to collect and store your information.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We may use cookies and similar tracking technologies (like web beacons and pixels) to gather information when you interact with our Services. Some online tracking technologies help us maintain the security of our Services and your account, prevent crashes, fix bugs, save your preferences, and assist with basic site functions.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We also permit third parties and service providers to use online tracking technologies on our Services for analytics and advertising, including to help manage and display advertisements, tailor advertisements to your interests, or send abandoned shopping cart reminders (depending on your communication preferences).',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Notice.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Google Analytics',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        Text(
    'We may share your information with Google Analytics to track and analyze the use of the Services. The Google Analytics Advertising Features that we may use include: Google Analytics Demographics and Interests Reporting. To opt out of being tracked by Google Analytics across the Services, visit https://tools.google.com/dlpage/gaoptout. You can opt out of Google Analytics Advertising Features through Ads Settings and Ad Settings for mobile apps. Other opt out means include http://optout.networkadvertising.org/ and http://www.networkadvertising.org/mobile-choice. For more information on the privacy practices of Google, please visit the Google Privacy & Terms page.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 5. HOW DO WE HANDLE YOUR SOCIAL LOGINS?
                        Text(
    '5. HOW DO WE HANDLE YOUR SOCIAL LOGINS?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: If you choose to register or log in to our Services using a social media account, we may have access to certain information about you.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Our Services offer you the ability to register and log in using your third-party social media account details (like your Facebook or X logins). Where you choose to do this, we will receive certain profile information about you from your social media provider. The profile information we receive may vary depending on the social media provider concerned, but will often include your name, email address, friends list, and profile picture, as well as other information you choose to make public on such a social media platform.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We will use the information we receive only for the purposes that are described in this Privacy Notice or that are otherwise made clear to you on the relevant Services.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 6. HOW LONG DO WE KEEP YOUR INFORMATION?
                        Text(
    '6. HOW LONG DO WE KEEP YOUR INFORMATION?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: We keep your information for as long as necessary to fulfill the purposes outlined in this Privacy Notice unless otherwise required by law.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We will only keep your personal information for as long as it is necessary for the purposes set out in this Privacy Notice, unless a longer retention period is required or permitted by law (such as tax, accounting, or other legal requirements). No purpose in this notice will require us keeping your personal information for longer than the period of time in which users have an account with us.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'When we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 7. HOW DO WE KEEP YOUR INFORMATION SAFE?
                        Text(
    '7. HOW DO WE KEEP YOUR INFORMATION SAFE?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: We aim to protect your personal information through a system of organizational and technical security measures.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We have implemented appropriate and reasonable technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information. Although we will do our best to protect your personal information, transmission of personal information to and from our Services is at your own risk. You should only access the Services within a secure environment.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 8. DO WE COLLECT INFORMATION FROM MINORS?
                        Text(
    '8. DO WE COLLECT INFORMATION FROM MINORS?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: We do not knowingly collect data from or market to children under 18 years of age.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We do not knowingly collect, solicit data from, or market to children under 18 years of age, nor do we knowingly sell such personal information. By using the Services, you represent that you are at least 18 or that you are the parent or guardian of such a minor and consent to such minor dependent’s use of the Services. If we learn that personal information from users less than 18 years of age has been collected, we will deactivate the account and take reasonable measures to promptly delete such data from our records. If you become aware of any data we may have collected from children under age 18, please contact us at omnitrics.db@gmail.com.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 9. WHAT ARE YOUR PRIVACY RIGHTS?
                        Text(
    '9. WHAT ARE YOUR PRIVACY RIGHTS?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: You may review, change, or terminate your account at any time, depending on your country, province, or state of residence.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Withdrawing your consent: If we are relying on your consent to process your personal information, which may be express and/or implied consent depending on the applicable law, you have the right to withdraw your consent at any time. You can withdraw your consent at any time by contacting us using the contact details provided in the section "HOW CAN YOU CONTACT US ABOUT THIS NOTICE?" below. However, please note that this will not affect the lawfulness of the processing before its withdrawal nor, when applicable law allows, will it affect the processing of your personal information conducted in reliance on lawful processing grounds other than consent.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Account Information',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        Text(
    'If you would at any time like to review or change the information in your account or terminate your account, you can log in to your account settings and update your user account. Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our legal terms and/or comply with applicable legal requirements.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'If you have questions or comments about your privacy rights, you may email us at omnitrics.db@gmail.com.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 10. CONTROLS FOR DO-NOT-TRACK FEATURES
                        Text(
    '10. CONTROLS FOR DO-NOT-TRACK FEATURES',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track ("DNT") feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage, no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this Privacy Notice.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 11. DO WE MAKE UPDATES TO THIS NOTICE?
                        Text(
    '11. DO WE MAKE UPDATES TO THIS NOTICE?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'In Short: Yes, we will update this notice as necessary to stay compliant with relevant laws.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
    'We may update this Privacy Notice from time to time. The updated version will be indicated by an updated "Revised" date at the top of this Privacy Notice. If we make material changes to this Privacy Notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this Privacy Notice frequently to be informed of how we are protecting your information.',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        
                        // 12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?
                        Text(
    '12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'If you have questions or comments about this notice, you may email us at omnitrics.db@gmail.com or contact us by post at:',
    style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text('Purple Inc.', style: TextStyle(fontSize: 14)),
                        Text('808 San Marcelino Street 1000 Manila Metro Manila', style: TextStyle(fontSize: 14)),
                        Text('Manila, Metro Manila 1004', style: TextStyle(fontSize: 14)),
                        Text('Philippines', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 20),
                        
                        // 13. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?
                        Text(
    '13. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple,
      fontSize: 14,
    ),
                        ),
                        SizedBox(height: 10),
                        Text(
    'Based on the applicable laws of your country, you may have the right to request access to the personal information we collect from you, details about how we have processed it, correct inaccuracies, or delete your personal information. You may also have the right to withdraw your consent to our processing of your personal information. These rights may be limited in some circumstances by applicable law. To request to review, update, or delete your personal information, please fill out and submit a data subject access request.',
    style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
  }
}