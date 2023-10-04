// import 'dart:convert';

// import 'package:happiness_club_merchant/utils/constants/app_strings.dart';
// //import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// abstract class RemoteConfigService {
//   /// This method initialize the firebase remote config
//   Future initialise();

//   /// This method returns the android app version in the remote config
//   String getAndroidAppVersion();

//   /// This method returns the ios app version in the remote config
//   String getIOSAppVersion();

//   /// This method shows personal registration option
//   bool shouldShowPersonalRegistration();

//   /// This method shows business registration
//   bool shouldShowBusinessRegistration();

//   /// This method shows freelancer registration
//   bool shouldShowFreelancerRegistration();

//   /// This method shows freelancer registration
//   String getBaseUrl();

//   /// This method shows profile
//   bool shouldShowProfile();

//   /// This method shows number of images or video upload
//   int getMediaUploadLimit();

//   /// This method shows wallet screen
//   bool shouldShowWallet();

//   /// This method shows reward screen
//   bool shouldShowRewardScreen();

//   ///this method will get twitter url
//   String getTwitterUrl();

//   ///this method will get facebook url
//   String getFacebookUrl();

//   ///this method will get privacy policy url
//   String getPrivacyPolicyUrl();

//   ///this method will get terms and condition url
//   String getTermsConditionUrl();

//   ///this method will get rating url of the app
//   String getAndroidRateUsUrl();

//   ///this method will get rating url of the app
//   String getIOSRateUsUrl();

//   /// This method shows reward screen
//   bool shouldShowEarnMoreScreen();

//   /// This method shows lost access to phone number
//   bool shouldShowLostAccessToPhoneNumber();

//   /// This method returns the English locale
//   Map<String, dynamic> getEnglishLocale();

//   /// This method returns the arabic AR
//   Map<String, dynamic> getArabic();

//   ///this method return rapyd supported country list
//   // List<RapydSupportedCountries> getRapydSupportedCountries();
// }

// class RemoteConfigServiceImp implements RemoteConfigService {
//   static String ANDROID_VERSION = 'android_version';
//   static String IOS_VERSION = 'ios_version';
//   static String PERSONAL_REGISTRATION = 'personal_registration';
//   static String BUSINESS_REGISTRATION = 'business_registration';
//   static String FREELANCER_REGISTRATION = 'freelancer_registration';
//   static String BASE_URL = 'url';
//   static String FACEBOOK_URL = 'facebook_link';
//   static String TWITTER_URL = 'twitter_link';
//   static String PRIVACY_POLICY_URL = 'privacy_policy_link';
//   static String TERMS_CONDITION_URL = 'terms_condition_link';
//   static String ANDROID_RATE_US_URL = 'android_rate_us_link';
//   static String IOS_RATE_US_URL = 'ios_rate_us_link';
//   static String RAPYD_SUPPORTED_COUNTRIES = 'rapyd_supported_countries';

//   /// Home Screen
//   static String POST_IMAGE_UPLOAD_COUNT = 'payment';
//   static String WALLET_SCREEN = 'wallet';
//   static String REWARD_SCREEN = 'reward_menu';
//   static String PROFILE_SCREEN = 'profile';
//   static String EARN_MORE_SCREEN = 'earn_more';
//   static String LOST_ACCESS_TO_PHONE = 'lost_access_to_phone';

//   /// Exchange minimum values
//   static String DOLLAR_MINIMUM_VALUE = 'dollar_min_value';
//   static String EURO_MINIMUM_VALUE = 'euro_min_value';
//   static String GBP_MINIMUM_VALUE = 'gbp_min_value';
//   static String PAYMENT_FEE = 'payment_fee';

//   /// Language
//   static String DEFAULT_LOCALE = 'en';
//   static String LOCALE_ARABIC = 'ar';

//   // TODO Change based on the current version of the app
//   final defaults = <String, dynamic>{
//     ANDROID_VERSION: ANDROID_VERSION_CONSTANT,
//     IOS_VERSION: IOS_VERSION_CONSTANT,
//     PERSONAL_REGISTRATION: true,
//     BUSINESS_REGISTRATION: true,
//     FREELANCER_REGISTRATION: true,
//     BASE_URL: '',
//     POST_IMAGE_UPLOAD_COUNT: 4,
//     WALLET_SCREEN: true,
//     REWARD_SCREEN: true,
//     PROFILE_SCREEN: true,
//     FACEBOOK_URL: 'https://www.facebook.com/casheroapp',
//     TWITTER_URL: 'https://twitter.com/casheroapp',
//     PRIVACY_POLICY_URL: terms_html,
//     TERMS_CONDITION_URL: privacy_policy_html,
//     ANDROID_RATE_US_URL:
//         'https://play.google.com/store/apps/details?id=com.rns.casheroapp',
//     IOS_RATE_US_URL: 'https://apps.apple.com/us/app/cashero/id1547603420',
//     EARN_MORE_SCREEN: true,
//     LOST_ACCESS_TO_PHONE: true,
//     DOLLAR_MINIMUM_VALUE: '0',
//     EURO_MINIMUM_VALUE: '0',
//     GBP_MINIMUM_VALUE: '0',
//     DEFAULT_LOCALE: jsonEncode(<String, dynamic>{}),
//     LOCALE_ARABIC: jsonEncode(<String, dynamic>{}),
//     PAYMENT_FEE: '0',
//   };

//  // final FirebaseRemoteConfig _remoteConfig;

//  // RemoteConfigServiceImp(FirebaseRemoteConfig remoteConfig)
//   //    : _remoteConfig = remoteConfig;

//   @override
//   Future initialise() async {
//     try {
//       setupDefaultValues();
//     //  await _remoteConfig.setDefaults(defaults);
//       await _fetchAndActivate();
//     } catch (exception) {}
//   }

//   void setupDefaultValues() async {
//     defaults[BASE_URL] = dotenv.env[BASE_URL];
//   }

//   Future _fetchAndActivate() async {
//     await _remoteConfig.fetchAndActivate();
//   }

//   @override
//   String getAndroidAppVersion() {
//     return _remoteConfig.getString(ANDROID_VERSION);
//   }

//   @override
//   String getIOSAppVersion() {
//     return _remoteConfig.getString(IOS_VERSION);
//   }

//   @override
//   bool shouldShowFreelancerRegistration() {
//     return _remoteConfig.getBool(FREELANCER_REGISTRATION);
//   }

//   @override
//   bool shouldShowBusinessRegistration() {
//     return _remoteConfig.getBool(BUSINESS_REGISTRATION);
//   }

//   @override
//   bool shouldShowPersonalRegistration() {
//     return _remoteConfig.getBool(PERSONAL_REGISTRATION);
//   }

//   @override
//   String getBaseUrl() {
//     return _remoteConfig.getString(BASE_URL);
//   }

//   @override
//   int getMediaUploadLimit() {
//     return _remoteConfig.getInt(POST_IMAGE_UPLOAD_COUNT);
//   }

//   @override
//   bool shouldShowProfile() {
//     return _remoteConfig.getBool(PROFILE_SCREEN);
//   }

//   @override
//   bool shouldShowWallet() {
//     return _remoteConfig.getBool(WALLET_SCREEN);
//   }

//   @override
//   bool shouldShowRewardScreen() {
//     return _remoteConfig.getBool(REWARD_SCREEN);
//   }

//   @override
//   String getTwitterUrl() {
//     return _remoteConfig.getString(TWITTER_URL);
//   }

//   @override
//   String getFacebookUrl() {
//     return _remoteConfig.getString(FACEBOOK_URL);
//   }

//   @override
//   String getPrivacyPolicyUrl() {
//     return _remoteConfig.getString(PRIVACY_POLICY_URL);
//   }

//   @override
//   String getTermsConditionUrl() {
//     return _remoteConfig.getString(TERMS_CONDITION_URL);
//   }

//   @override
//   String getAndroidRateUsUrl() {
//     return _remoteConfig.getString(ANDROID_RATE_US_URL);
//   }

//   @override
//   String getIOSRateUsUrl() {
//     return _remoteConfig.getString(IOS_RATE_US_URL);
//   }

//   @override
//   bool shouldShowEarnMoreScreen() {
//     return _remoteConfig.getBool(EARN_MORE_SCREEN);
//   }

//   @override
//   bool shouldShowLostAccessToPhoneNumber() {
//     return _remoteConfig.getBool(LOST_ACCESS_TO_PHONE);
//   }

//   @override
//   Map<String, dynamic> getEnglishLocale() {
//     return _remoteConfig.getString(DEFAULT_LOCALE).isEmpty
//         ? {}
//         : jsonDecode(_remoteConfig.getString(DEFAULT_LOCALE));
//   }

//   @override
//   Map<String, dynamic> getArabic() {
//     return _remoteConfig.getString(LOCALE_ARABIC).isEmpty
//         ? {}
//         : jsonDecode(_remoteConfig.getString(LOCALE_ARABIC));
//   }

//   static String privacy_policy_html = '''
//     <html>
      
//       <head>
//           <meta name="viewport" content="width=device-width, initial-scale=1.0">
//           <link
//               href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap"
//               rel="stylesheet">
//           <style>
//               body {
//                   font-family: 'Roboto', sans-serif;
//                   margin: 0;
//                   padding: 0;
//               }
      
//               .outer {
//                   box-sizing: border-box;
//                   display: block;
//                   margin: 0 auto;
//                   padding: 2.5rem 1.25rem;
//               }
      
//               h1 {
//                   font-size: 1.5rem;
//                   line-height: 40px;
//                   padding: 2rem 0;
//                   text-align: left;
//                   font-weight: 500;
//               }
      
//               h4 {
//                   font-size: 1.125rem;
//                   line-height: 30px;
//                   font-weight: 500;
//               }
      
//               ul {
//                   padding: 0 0 0 1rem;
//               }
      
//               li::marker {
//                   font-size: 1.125rem;
//               }
      
//               li,
//               p {
//                   font-size: 1rem;
//                   line-height: 26px;
//                   margin: 0 0 1rem;
//                   text-align: justify;
//                   font-weight: 400;
//               }
//           </style>
//       </head>
//       <body>
//           <div class="outer">
//               <h1>PRIVACY POLICY</h1>
//               <h4>GENERAL</h4>
//               <p>This Privacy Policy explains how Cashero Financial OÜ (“Cashero” or “we,” “us,” or “our”)
//                   collects, uses, and discloses information about you when you visit, access, or use Cashero app
//                   (hereinafter the “Site”), Cashero app (hereinafter the “App”) software, and other online products
//                   and services (collectively, the “Services”) or when you otherwise interact with us. By visiting the
//                   Site or otherwise using our Services, you acknowledge the practices described in this Privacy
//                   Policy. We will occasionally change this Privacy Policy. We encourage you to review the Privacy
//                   Policy whenever you access the Services, the Site or use the App or otherwise interact with us to
//                   stay informed about our information practices and the choices available to you.</p>
//               <p>“Personal Information” refers to information that identifies an individual, such as name, address,
//                   e-mail address, financial information, and banking details. “Personal Information” does not
//                   include anonymized and/or aggregated data that does not identify a specific user. Cashero is
//                   committed to protecting and respecting your privacy. The purpose of this Privacy Policy is to
//                   describe:</p>
//               <ul>
//                   <li>The types of Personal Information we collect and how it may be used;</li>
//                   <li>How and why we may disclose your Personal Information to third parties;</li>
//                   <li>The transfer of your Personal Information;</li>
//                   <li>Your right to access, correct, update, and delete your Personal Information;</li>
//                   <li>The security measures we use to protect and prevent the loss, misuse, or alteration of
//                       Personal Information; and</li>
//                   <li>Company’s retention of your Personal Information.</li>
//                   <li>This Privacy Policy also covers some basics of our use of cookies, however, for more
//                       details please see also our Cookie Policy;</li>
//               </ul>
//               <p>We control the ways of collecting your Personal Information and determine goals for which We
//                   use Personal Information. We are a “data controller” within the meaning of the General Data
//                   Protection Regulation (EU) 2016/679 (hereinafter referred to as “GDPR”) and other applicable
//                   European laws on data protection.</p>
//               <h4>COLLECTION AND USE OF PERSONAL INFORMATION</h4>
//               <h4>PERSONAL INFORMATION WE COLLECT</h4>
//               <p>We collect the following Personal Information:</p>
//               <ul>
//                   <li>Contact information, such as name, home address, e-mail address, and telephone number,
//                       IP address, etc;
//                   </li>
//                   <li>Account information, such as username and password;</li>
//                   <li>Financial information, such as bank account numbers, bank statement, trading activity, and
//                       history, commissions charged, etc;</li>
//                   <li>Identity verification information, such as images of your government-issued ID, passport,
//                       national ID card, driving license, or other documents requested by our compliance
//                       department;</li>
//                   <li>Residence verification information, such as Utility bill details or similar information.</li>
//                   <li>Other information, obtained during our KYC procedures, such as information about your
//                       financial state and source of funds;</li>
//                   <li>We also automatically collect certain computer, device, and browsing information when
//                       you access the Site, the App, or use the Services. This information is aggregated to provide
//                       statistical data about our users' browsing actions and patterns, and does not personally
//                       identify individuals.</li>
//               </ul>
//               <p>This information may include:</p>
//               <ul>
//                   <li>The information about the computer or mobile device you use to access our Site or App,
//                       including the hardware model, operating system and version, the web browser you use, IP
//                       addresses, and other device identifiers.</li>
//                   <li>The Site and App usage information, the server log information, which may include (but
//                       is not limited to) your login details, the date and time of visits, the pages viewed, your IP
//                       address, time spent at our Site, App, and the app you visit just before and just after our Site
//                       or App.</li>
//                   <li>The bandwidth upload and download speeds, the amount of free and used storage space on
//                       your device, and other statistics about your device.</li>
//                   <li>We may automatically capture, store and otherwise process information about you even if
//                       you abandon the completion of an online application or registration form.</li>
//               </ul>
//               <h4>USE OF COOKIES AND SIMILAR TECHNOLOGY</h4>
//               <p>The Site is using cookies. Cookies are small text files that are placed on your computer by apps
//                   that you visit. They are widely used to make apps work, or work more efficiently, as well as to
//                   provide information to the owners of the site. Cookies are typically stored on your computer's hard
//                   drive.</p>
//               <p>Our Site uses cookies to enable you to use the Site, the Services we offer, and the materials on the
//                   Site. Cookies are also used to distinguish you from other users of our Site. This helps us to provide
//                   you with a good experience when you browse our Site and also allows us to improve our Site.</p>
//               <p>For detailed information on the cookies we use and the purposes for which we use them see our
//                   Cookie Policy.
//               </p>
//               <h4>HOW WE USE YOUR PERSONAL INFORMATION</h4>
//               <p>We may use your Personal Information to:</p>
//               <ul>
//                   <li>Process your transactions. We will process your Personal Information only for the
//                       purpose(s) for which it has been provided to us;</li>
//                   <li>Fulfill our legal or regulatory requirements;</li>
//                   <li>Verify your identity following the applicable legislation and the Company’s Anti Money
//                       Laundering policy, as well as address other law enforcement needs. We also may share
//                       your information with other financial institutions and with tax authorities if such actions
//                       are required from us due to any applicable legislation;</li>
//                   <li>Detect, investigate and prevent fraudulent transactions or unauthorized or illegal activities;</li>
//                   <li>Protect our rights and property;</li>
//                   <li>Personalize your Services experience;</li>
//                   <li>Analyze the Site usage and improve our Site and offerings. Analyzing and tracking data to
//                       determine the usefulness or popularity of certain content and to better understand the online
//                       activity of our Site users;</li>
//                   <li>Help us respond to your customer service requests and support needs, answer your inquiry
//                       or respond to a communication from you;</li>
//                   <li>Contact you about the Services. The email address you provide may be used to
//                       communicate information and updates related to your use of the Services. We may alsooccasionally
//                       communicate technical notices, support or administrative notifications,
//                       company news, updates, promotions, and related information relating to similar products
//                       and the Services provided by Cashero;</li>
//                   <li>Administer a contest, promotion, survey, or other features as will be more explained on the
//                       Site;</li>
//                   <li>Link, connect or combine Personal Information we collect from or about you with other
//                       Personal Information; and</li>
//                   <li>Carry out any other purpose or reason for which the Information was collected;</li>
//                   <li>We do not perform behavioral tracking of a customer's activities on our Site or across
//                       different app, nor do we allow third-party data collection through our services. If you wish
//                       to stop receiving marketing communications from us, please contact us to opt-out.</li>
//               </ul>
//               <h4>DISCLOSING AND TRANSFERRING PERSONAL INFORMATION</h4>
//               <p>We may disclose your Personal Information to third parties and legal and regulatory authorities,
//                   and transfer your Personal Information as described below:</p>
//               <h4>DISCLOSURES TO THIRD PARTIES</h4>
//               <ul>
//                   <li>In processing your transactions, we may share some of your Personal Information with our
//                       third-party service providers who help with our business operations. Your information will
//                       not be sold, exchanged, or shared with any third parties without your consent, except to
//                       provide Services or as required by law. By using the Site or Services you consent to the
//                       disclosure of your Personal Information as described in this Privacy Policy. Non-personally
//                       identifiable visitor information may be provided to third parties for marketing, advertising,
//                       or other uses.</li>
//                   <li>Company’s third-party service providers are contractually bound to protect and use such
//                       information only for the purposes for which it was disclosed, except as otherwise required
//                       or permitted by law. We ensure that such third parties will be bound by terms no less
//                       protective than those described in this Privacy Policy, or those we are subject to under
//                       applicable data protection laws.</li>
//               </ul>
//               <h4>DISCLOSURES TO LEGAL AUTHORITIES</h4>
//               <p>We may share your Personal Information with law enforcement, data protection authorities,
//                   government officials, and other authorities when:</p>
//               <ul>
//                   <li>Compelled by subpoena, court order, or other legal procedure;</li>
//                   <li>We believe that the disclosure is necessary to prevent physical harm or financial loss;</li>
//                   <li>Disclosure is necessary to report suspected illegal activity;</li>
//                   <li>Disclosure is necessary to investigate violations of this Privacy Policy or any of our
//                       agreements with you.</li>
//               </ul>
//               <h4>INTERNATIONAL TRANSFERS OF PERSONAL INFORMATION</h4>
//               <p>We store and process your Personal Information in data centers around the world, wherever
//                   Company facilities or service providers are located. As such, we may transfer your Personal
//                   Information between such data centers. Such transfers are undertaken following our legal and
//                   regulatory obligations and are performed only via protected channels.</p>
//               <h4>OTHER CIRCUMSTANCES FOR DISCLOSURE OF PERSONAL INFORMATION</h4>
//               <p>We also can disclose your Personal Information in the following circumstances:</p>
//               <ul>
//                   <li>with your consent or at your instruction. Certain information you may choose to share may
//                       be displayed publicly, such as your username and any content you post when you use
//                       interactive areas of our Site;
//                   </li>
//                   <li>with our current or future parent companies, affiliates, subsidiaries, and with other
//                       companies under common control or ownership with us or our offices internationally. We
//                       ensure that listed parties will be bound by terms no less protective than those described in
//                       this Privacy Policy, or those we are subject to under applicable data protection laws;</li>
//                   <li>if the sharing of Personal Information is necessary for the protection of our rights and
//                       property, or rights and property of the above listed current or future parent companies,
//                       affiliates, subsidiaries, and with other companies under common control or ownership with
//                       us or our offices.</li>
//               </ul>
//               <h4>EXTERNAL APPS</h4>
//               <p>Occasionally, the Site may provide references or links to other apps (“External Apps”). We do not
//                   control these External Apps third-party sites or any of the content contained therein. You agree
//                   that we are in no way responsible or liable for External apps referenced or linked from the Site
//                   including, but not limited to, Site content, policies, failures, promotions, products, services or
//                   actions and/or any damages, losses, failures or problems caused by, related to, or arising from
//                   those sites. External Apps have separate and independent privacy policies. We encourage you to
//                   review the policies, rules, terms, and regulations of each site that you visit. We seek to protect
//                   theintegrity of our Site and welcome any feedback about External App information provided on the
//                   Site.</p>
//               <h4>YOUR RIGHTS REGARDING YOUR PERSONAL
//                   INFORMATION</h4>
//               <p>You can exercise all rights foreseen by legislation, if this does not contradict the legal requirements
//                   concerning the prevention of money laundering and terrorist financing laws, our record-keeping
//                   obligations, etc.</p>
//               <p>You have the following rights:</p>
//               <ul>
//                   <li>the right to be informed about the fact that we're processing your Personal Information and
//                       which data exactly we are processing, the right to data portability. In certain circumstances,
//                       you have the right to obtain all your Personal Information we store in a machine-readable
//                       format;</li>
//                   <li>the right to object to the processing of your Personal Information;</li>
//                   <li>the right not to be subject to automated decision-making including profiling if it doesn't
//                       intervene in performing the contract between you and us;</li>
//                   <li>the right to access your Personal Information, to correct, update, and block inaccurate
//                       and/or incorrect data;</li>
//                   <li>the right to withdraw your consent of Personal Information processing;</li>
//                   <li>the right to erase your Personal Information from our servers upon your justified request
//                       (a right to be forgotten).</li>
//               </ul>
//               <p>To exercise these rights, contact us.</p>
//               <p>Within 40 days of receipt of your written request, we will provide you with your Personal
//                   Information, including the purposes for which it was used and to whom it was disclosed following
//                   applicable legislation. We reserve the right to request additional information from you, that may
//                   be necessary to provide the duly response to your request following applicable legislation and you
//                   agree with such our right. Also, if you wish to correct, update, and block inaccurate and/or incorrect
//                   data, we have a right to request a confirmation of correct data from you, for example, official
//                   documents containing such data.</p>
//               <p>Please note that if we are unable to verify your identity by e-mail messages or at your application
//                   to the call center, or in the case of reasonable doubts concerning your identity, we may ask you to
//                   provide proof of identity, including by personal appearance in our office. This is the only way we
//                   can avoid disclosing your Personal Information to a person who can perpetrate your identity.</p>
//               <p>In some cases, we will not be able to change your Personal Information. In particular, such a case
//                   can include the event when your personal information has already been used during the execution
//                   of any agreement or transaction specified in any official document, etc. You have the right to
//                   withdraw consent to personal data processing. You may also exercise your right to be forgotten
//                   and erase your Personal information from our servers. In cases stipulated in Article 17 of GDPR,
//                   we will delete your Personal Information we process, except for that Personal Information which
//                   we are obliged to store by the requirements set forth by the applicable legislation.</p>
//               <p>Please be advised, that in case of realization of your right of withdrawal of consent to personal
//                   data processing or right to be forgotten, we will not be able to provide you our products or services,
//                   and we have a special right to terminate all our current agreements with you with the application
//                   of legal consequences of such termination, and you irrevocably acknowledge such our right.</p>
//               <p>To withdraw the consent to personal data processing and/or exercise your rights to be forgotten
//                   please contact us. Furthermore, in this case, for safety, we may request you to present your ID
//                   document, including directly at our office.</p>
//               <h4>SECURITY OF PERSONAL INFORMATION</h4>
//               <p>We use a variety of security measures to ensure the confidentiality of your Personal Information
//                   and to protect your Personal Information from loss, theft, unauthorized access, misuse, alteration,
//                   or destruction. These security measures include, but are not limited to: Password protected
//                   directories and databases.</p>
//               <p>Secure Sockets Layered (SSL) technology to ensure that your information is fully encrypted and
//                   sent across the Internet securely.</p>
//               <p>Limited access to hosting servers using 2FA and traffic encryption.</p>
//               <p>All financially sensitive and/or credit information is transmitted via SSL technology and encrypted
//                   in our database. Only authorized Company personnel is permitted access to your Personal
//                   Information, and personnel is required to treat the information as highly confidential. The security
//                   measures will be reviewed regularly in light of new and relevant legal and technical developments.</p>
//               <h4>RETENTION OF PERSONAL INFORMATION</h4>
//               <p>We retain Personal Information for as long as necessary to fulfill purposes described in this Privacy
//                   Policy, subject to our own legal and regulatory obligations. By our record-keeping obligations, we
//                   will retain account and other Personal Information for at least five years after termination of the
//                   respective agreement.</p>
//               <h4>UPDATES TO THIS PRIVACY POLICY</h4>
//               <p>This Privacy Policy may be revised, modified, updated, and/or supplemented at any time, without
//                   prior notice, at the sole discretion of Cashero. When we make changes to this Privacy Policy, we
//                   make the amended Privacy Policy available on our Site.</p>
      
//           </div>
//       </body>
    
//     </html>
//   ''';

//   static String terms_html = '''
//     <html>
    
//       <head>
//           <meta name="viewport" content="width=device-width, initial-scale=1.0">
//           <link
//               href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap"
//               rel="stylesheet">
//           <style>
//               body {
//                   font-family: 'Roboto', sans-serif;
//                   margin: 0;
//                   padding: 0;
//               }
      
//               .outer {
//                   box-sizing: border-box;
//                   display: block;
//                   margin: 0 auto;
//                   padding: 2.5rem 1.25rem;
//               }
      
//               h1 {
//                   font-size: 1.5rem;
//                   line-height: 40px;
//                   padding: 2rem 0;
//                   text-align: left;
//                     font-weight: 500;
//               }
      
//               h4 {
//                   font-size: 1.125rem;
//                   line-height: 30px;
//                     font-weight: 500;
//               }
      
//               li {
//                   font-size: 0.875rem;
//                   line-height: 26px;
//                   margin: 0 0 1rem;
//               }
      
//               p {
//                   font-size: 1rem;
//                   line-height: 26px;
//                   margin: 0 0 1rem;
//                   text-align: justify;
//                   font-weight: 400;
//               }
      
//               ol {
//                   counter-reset: orderedList;
//                   list-style: none;
//                   padding: 0 0 0 1rem;
//               }
      
//               ol li:before {
//                   content: counter(orderedList) ") ";
//                   counter-increment: orderedList;
//                   margin: 0 0 0 -1rem;
//               }
      
//               a {
//                   text-decoration: none;
//               }
//           </style>
//       </head>
//       <body>
//           <div class="outer">
//               <h1>TERMS AND CONDITIONS</h1>
//               <p>These Terms and Conditions (hereinafter the “Terms”) is a binding legal agreement between you,
//                   whether personally or on behalf of an entity (“you”) and Cashero Financial OÜ (hereinafter
//                   “Company”, “Our”, “Us”, “We”, “Cashero”) having its registered address at Keemia 4, Tallinn,
//                   Estonia 10616, concerning your access to and use of the <a href="https://cashero.com/" target="_blank"
//                       rel="noreferrer noopener">www.cashero.com</a> app as well as any
//                   other media form, media channel, mobile app or mobile application related, linked, or service
//                   provided by Cashero, or otherwise connected thereto (collectively, the “Site”). Both, individual
//                   (private persons) and business (corporate and institutions) customers are subjected to this
//                   agreement. These Terms are made to ensure quality and safety of use on the Site. You agree that
//                   by accessing the Site, you have read, understood, and agreed to be bound by all of these Terms. IF
//                   YOU DO NOT AGREE WITH ALL OF THESE TERMS, THEN YOU ARE EXPRESSLY
//                   PROHIBITED FROM USING THE SITE AND YOU MUST DISCONTINUE USE
//                   IMMEDIATELY.</p>
//               <p>Supplemental terms and conditions or documents that may be posted on the Site from time to time
//                   are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion,
//                   to make changes or modifications to these Terms at any time and for any reason. We will alert you
//                   about any changes by updating the “Last updated” date of these Terms, and you waive any right
//                   to receive specific notice of each such change. It is your responsibility to periodically review these
//                   Terms to stay informed of updates. You will be subject to and will be deemed to have been made
//                   aware of and to have accepted, the changes in any revised Terms by your continued use of the Site
//                   after the date such revised Terms are posted.</p>
//               <p>This information provided on the Site is not intended for distribution to or use by any person or
//                   entity in any jurisdiction or country where such distribution or use would be contrary to law or
//                   regulation or which would subject us to any registration requirement within such jurisdiction or
//                   country. Accordingly, those persons who choose to access the Site from other locations do so on
//                   their own initiative and are solely responsible for compliance with local laws, if and to the extent
//                   local laws are applicable.</p>
//               <h4>DESCRIPTION OF SERVICE</h4>
//               <p>Cashero is a secure mobile-based application that provides a secure platform for high-yield
//                   savings, multi-currency wallets, and instant, fee-free internal and cross-border payments. Cashero
//                   allows users to deposit GBP, EUR, and USD to generate interest. Interest is generated by
//                   converting deposited GBP, EUR, and USD into a basket of cryptocurrency stablecoins i.e. DAI
//                   and USDC, which are invested into Decentralized Finance lending protocols. Users can withdraw
//                   their deposits and interest from Cashero in GBP, EUR, USD, or their local currency.</p>
//               <p>Cashero does not provide a cryptocurrency exchange service and does not allow cryptocurrency
//                   deposits for its customers.</p>
//               <p>Cashero has established two companies to separate elements of the business. Cashero
//                   Financial OÜ for traditional financial transactions and Cashero Investment OÜ for those
//                   that involve virtual currencies. Cashero Financial OÜ will hold the financial institution
//                   license and Cashero Investment OÜ will hold the virtual currency service license. Both of
//                   these companies are fully owned by UK registered company Romans 828 Ltd.</p>
//               <h4>INTELLECTUAL PROPERTY RIGHTS</h4>
//               <p>Unless otherwise indicated, the Site is our proprietary property and all source code, databases,
//                   functionality, software, app designs, audio, video, text, photographs, and graphics on the Site
//                   (collectively, the “Content”) and the trademarks, service marks, and logos contained therein (the
//                   “Marks”) are owned or controlled by us or licensed to us, and are protected by copyright and
//                   trademark laws and various other intellectual property rights and unfair competition laws,
//                   international copyright laws, and international conventions. The Content and the Marks are
//                   provided on the Site “AS IS” for your information and personal use only. Except as expressly
//                   provided in these Terms, no part of the Site and no content or marks may be copied, reproduced,
//                   aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted,
//                   distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without
//                   our express prior written permission.</p>
//               <p>Provided that you are eligible to use the Site, you are granted a limited license to access and use
//                   the Site and to download or print a copy of any portion of the content to which you have properly
//                   gained access solely for your personal, non-commercial use. We reserve all rights not expressly
//                   granted to you in and to the Site, the content, and the marks.</p>
//               <h4>USER REPRESENTATIONS</h4>
//               <p>By using the Site, you hereby confirm you are fully aware, agree, represent, and warrant that:</p>
//               <ol>
//                   <li>All registration information you submit will be true, accurate, current, and complete;</li>
//                   <li>You will maintain the accuracy of such information and promptly update such registration
//                       information as necessary;</li>
//                   <li>You have the legal capacity and you agree to comply with these Terms;</li>
//                   <li>You are of legal age and capabilities to form and understand a binding legal contract;</li>
//                   <li>You are not a minor in the jurisdiction in which you reside;</li>
//                   <li>You have not been banned or restricted previously from using the Site;</li>
//                   <li>You will not access the Site through automated or non-human means, whether through a bot,
//                       script, or otherwise;</li>
//                   <li>You will not use the Site for any illegal or unauthorized purpose; and</li>
//                   <li>Your use of the Site will not violate any applicable law or regulation.</li>
//               </ol>
//               <p>If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the
//                   right to suspend or terminate your account and refuse any and all current or future use of the Site
//                   (or any portion thereof).</p>
//               <h4>USER CONTENT</h4>
//               <p>You may post, upload, input, provide, or submit personal data and information to us, including but
//                   not limited to, name, email address, phone number, IP address, text, code, or other information
//                   and materials, or sign up for our mailing list (hereinafter collectively “User Content”), as a
//                   customer you must ensure that the User Content provided at that or at any other time is true,
//                   accurate, current, and complete; and any User Content that is post, upload, input, provide, or
//                   submit to us or our Site does not breach or infringe the intellectual property rights of any third-
//                   party.</p>
//               <p>The Site does not own, control, or endorse any User Content transmitted, stored, or processed via
//                   the Site or provided in any other way by the customers, and the Site is not responsible or liable for
//                   any User Content. You agree to not hold the Site or any of its employees, directors, partners, third-
//                   party providers accountable nor liable in any way to the User Content. You are solely responsible
//                   and liable for all your User Content and use of any interactive features, links, information, or
//                   content on the Company Apps. The Customer represents and warrants that (i) you own all
//                   intellectual property rights (or have obtained all necessary permissions) to provide User Content
//                   and to grant licenses in these Terms; (ii) User Content does not violate any agreements or
//                   confidentiality obligations; and (iii) User Content does not violate, infringe, or misappropriate any
//                   intellectual property rights or other proprietary rights, including the right of publicity or privacy,
//                   of any person or entity.</p>
//               <p>You, the Customer, are solely responsible for maintaining the confidentiality of your User Content
//                   and any of your non-public information. You must notify us immediately of any unauthorized use
//                   of your User Content, or any other breach of security. We are not liable for any losses or damages
//                   that you may incur as a result of someone else using your User Content, either with or without
//                   your knowledge. However, you may be held liable for losses incurred by The Company Parties or
//                   another party, due to someone else using your User Content. You may not use anyone else’s User
//                   Content or account at any time without permission from such person or entity.</p>
//               <p>By posting, uploading, inputting, providing, or submitting your User Content to us, you grant The
//                   Company, its affiliates, and any necessary sub-licensees, a non-exclusive, worldwide, perpetual
//                   right and permission to use, reproduce, copy, edit, modify, translate, reformat, create derivative
//                   works from, distribute, transmit, publicly perform, and publicly display your User Content and
//                   sub-license such rights to others.
//               </p>
//               <p>You must immediately update and inform us of any changes to your User Content by updating
//                   your data. Contact us, for us to communicate with you effectively and provide accurate and current
//                   information. Although we have no obligation to screen, edit, or monitor User Content, we reserve
//                   the right and have absolute discretion to remove, screen, or edit User Content. Furthermore, if we
//                   have reason to believe that there is likely to be a breach of security, misuse of our Site, or any
//                   breach of your obligations under these terms or the Privacy Policy, we may suspend your use of
//                   the Site at any time and for any reason. Any User Content submitted by you for our Site may be
//                   accessed by us globally.</p>
      
      
//               <h4>PROHIBITED ACTIVITIES</h4>
//               <p>You may not access or use the Site for any purpose other than that for which we make the Site
//                   available. The Site may not be used in connection with any commercial endeavors except those
//                   that are specifically endorsed or approved by us:</p>
//               <p>As a user of the Site, you agree not to:</p>
//               <ol>
//                   <li>Systematically retrieve data or other content from the Site to create or compile, directly or
//                       indirectly, a collection, compilation, database, or directory without written permission from us;</li>
//                   <li>Trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account
//                       information such as user passwords;</li>
//                   <li>Circumvent, disable, or otherwise interfere with security-related features of the Site, including
//                       features that prevent or restrict the use or copying of any content or enforce limitations on the use
//                       of the Site and/or the content contained therein;</li>
//                   <li>Disparage, tarnish, or otherwise harm, in our opinion, us and/or the Site;</li>
//                   <li>Use any information obtained from the Site to harass, abuse, or harm another person;</li>
//                   <li>Make improper use of our support services or submit false reports of abuse or misconduct;</li>
//                   <li>Use the Site in a manner inconsistent with any applicable laws or regulations;</li>
//                   <li>Use the Site to advertise or offer to sell goods and services;</li>
//                   <li>Engage in unauthorized framing of or linking to the Site;</li>
//                   <li>Upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other
//                       material, including excessive use of capital letters and spamming (continuous posting of repetitive
//                       text), that interferes with any party’s uninterrupted use and enjoyment of the Site or modifies,
//                       impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance
//                       of the Site;</li>
//                   <li>Engage in any automated use of the system, such as using scripts to send comments or
//                       messages, or using any data mining, robots, or similar data gathering and extraction tools;</li>
//                   <li>Delete the copyright or other proprietary rights notice from any content;</li>
//                   <li>Attempt to impersonate another user or person or use the username of another user;</li>
//                   <li>Sell or otherwise transfer your profile;</li>
//                   <li>Upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or
//                       active information collection or transmission mechanism, including without limitation, clear
//                       graphics interchange formats (“gifs”) 1x1 pixels, web bugs, cookies, or other similar devices
//                       (sometimes referred to as “spyware” or “passive collection mechanisms” or “pcms”);</li>
//                   <li>Interfere with, disrupt, or create an undue burden on the Site or the networks or services
//                       connected to the Site;</li>
//                   <li>Harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing
//                       any portion of the Site to you;</li>
//                   <li>Attempt to bypass any measures of the Site designed to prevent or restrict access to the Site,
//                       or any portion of the Site;</li>
//                   <li>Copy or adapt the Site’s software, including but not limited to Flash, PHP, HTML, JavaScript,
//                       or other code;</li>
//                   <li>Decipher, decompile, disassemble, or reverse engineer any of the software comprising or in
//                       any way making up a part of the Site;</li>
//                   <li>Except as may be the result of a standard search engine or Internet browser usage, use, launch,
//                       develop, or distribute any automated system, including without limitation, any spider, robot, cheat
//                       utility, scraper, or offline reader that accesses the Site, or using or launching any unauthorized
//                       script or other software;</li>
//                   <li>Make any unauthorized use of the Site, including collecting usernames and/or email addresses
//                       of users by electronic or other means to send unsolicited email, or create user accounts by
//                       automated means or under pretenses;</li>
//                   <li>Use the Site as part of any effort to compete with us or otherwise use the Site and/or the content
//                       for any revenue-generating endeavor or commercial enterprise.</li>
//               </ol>
//               <h4>CONTRIBUTION LICENSE</h4>
//               <p>You and the Site agree that we may access, store, process, and use any information and personal
//                   data that you provide following the terms of the Privacy Policy and your choices (including
//                   settings).</p>
//               <p>By submitting suggestions or other feedback regarding the Site, you agree that we can use and
//                   share such feedback for any purpose without compensation to you.</p>
//               <p>We do not assert any ownership over your Contributions. You retain full ownership of all of your
//                   Contributions and any intellectual property rights or other proprietary rights associated with your
//                   contributions. We are not liable for any statements or representations in your Contributions
//                   provided by you in any area on the site. You are solely responsible for your contributions to the
//                   site and you expressly agree to exonerate us from any and all responsibility and to refrain from
//                   any legal action against us regarding your contributions.</p>
//               <h4>THIRD-PARTY APP AND CONTENT</h4>
//               <p>The Site may contain (or you may be sent via the Site) links to other apps (“Third-Party Apps”) as
//                   well as articles, photographs, text, graphics, pictures, designs, music, sound, video, information,
//                   applications, software, and other content or items belonging to or originating from third
//                   parties(“Third-Party Content”). Such Third-Party Apps and Third-Party Content are not investigated,
//                   monitored, or checked for accuracy, appropriateness, or completeness by us, and we are not
//                   responsible for any Third-Party Apps accessed through the Site or any Third-Party content posted
//                   on, available through, or installed from the Site, including the content, accuracy, offensiveness,
//                   opinions, reliability, privacy practices, or other policies of or contained in the Third-Party Apps or
//                   the Third-Party Content. Inclusion of linking to, or permitting the use or installation of any Third-
//                   Party Apps or any Third-Party Content does not imply approval or endorsement thereof by us. If
//                   you decide to leave the Site and access the Third-Party Apps or to use or install any Third-Party
//                   Content, you do so at your own risk, and you should be aware these Terms no longer govern. You
//                   should review the applicable terms and policies, including privacy and data gathering practices, of
//                   any app to which you navigate from the Site or relating to any applications you use or install from
//                   the Site. Any purchases you make through Third-Party Apps will be through other apps and from
//                   other companies, and we take no responsibility whatsoever to such purchases which are
//                   exclusively between you and the applicable third party. You agree and acknowledge that we do
//                   not endorse the products or services offered on Third-Party Apps and you shall hold us harmless
//                   from any harm caused by your purchase of such products or services. Additionally, you shall hold
//                   us harmless from any losses sustained by you or harm caused to you relating to or resulting in any
//                   way from any Third-Party Content or any contact with Third-Party Apps.</p>
//               <h4>SITE MANAGEMENT</h4>
//               <p>We reserve the right, but no obligation, to:</p>
//               <ol>
//                   <li>Monitor the Site for violations of these Terms;</li>
//                   <li>Take appropriate legal action against anyone who, in our sole discretion, violates the law or
//                       these Terms, including without limitation, reporting such user to law enforcement authorities;</li>
//                   <li>In our sole discretion and without limitation, refuse, restrict access to, limit the availability of,
//                       or disable (to the extent technologically feasible) any of your contributions or any portion thereof;
//                   </li>
//                   <li>In our sole discretion and without limitation, notice, or liability, to remove from the Site or
//                       otherwise disable all files and content that are excessive in size or are in any way burdensome to
//                       our systems; and</li>
//                   <li>Otherwise manage the Site in a manner designed to protect our rights and property and to
//                       facilitate the proper functioning of the Site.</li>
//               </ol>
//               <h4>PRIVACY POLICY</h4>
//               <p>We care about data privacy and security. Please refer to our <a
//                       href="https://www.cashero.com/privacy-policy/" target="_blank" rel="noreferrer noopener">Privacy
//                       Policy</a>.</p>
//               <h4>TERM AND TERMINATION</h4>
//               <p>These Terms shall remain in full force and effect while you use the Site. Without limiting any
//                   other provision of these Terms, we reserve the right to, in our sole discretion and without notice
//                   or liability, deny access to and use of the Site (including blocking certain IP addresses), to any
//                   person for any reason for no reason, including without limitation for breach of any representation,
//                   warranty, or covenant contained in these Terms or of any applicable law or regulation. We may
//                   terminate your use or participation in the Site and any content or information that you posted at
//                   any time, without warning, at our sole discretion.</p>
//               <h4>MODIFICATIONS AND INTERRUPTIONS</h4>
//               <p>We reserve the right to change, modify, or remove the contents of the Site at any time or for any
//                   reason at our sole discretion without notice. However, we have no obligation to update any
//                   information on our Site. We also reserve the right to modify or discontinue all or part of the Site
//                   without notice at any time. We will not be liable to you or any third party for any modification,
//                   price change, suspension, or discontinuance of the Site.</p>
//               <p>We reserve the right to change, revise, update, suspend, discontinue, or otherwise modify the Site
//                   at any time or for any reason without notice to you. You agree that we have no liability whatsoever
//                   for any loss, damage, or inconvenience caused by your inability to access or use the Site during
//                   any downtime or discontinuance of the Site.</p>
//               <h4>FORCE MAJEURE</h4>
//               <p>Force Majeure is the event where circumstances are beyond our control, including but not limited
//                   to, electricity blackouts, natural disasters, cyber-attacks, war, strike, riot, crime, epidemic or any
//                   other event that is beyond the Site’s reasonable abilities to control (hereinafter “Force Majeure”)
//                   the Site may experience delays or failure to deliver the Services. In such a case you agree to not
//                   hold the Site accountable for any delays in Services, loss of Transactions, or loss of funds.</p>
//               <h4>INDEMNIFICATION AND LIABILITIES</h4>
//               <p>Except if otherwise required by law, or the regulation under which we operate, in no other event
//                   the Site, our directors, employees, partners, third-party providers, be liable to any or all damages,
//                   including but not limited to, suspension of funds on customer account in our Sites or any other
//                   external accounts, mistakes in data, loss of data, loss of information, errors, unauthorized access
//                   to our records, interruptions, loss of files, defects, viruses, occurring directly, indirectly, or
//                   otherwise arising as a result of using our services or inability of using our services on our Sites, to
//                   the maximum extent allowed by laws of the applicable jurisdiction. You agree to indemnify and
//                   not hold the Site, our directors, employees, partners, third-party providers accountable for any
//                   claim, demand, action, damage, loss, cost, or expense, including but not limited to, attorneys’ fees,
//                   arising out or relating to the use of our Services and the Sites.</p>
//               <h4>GOVERNING LAW AND DISPUTES</h4>
//               <p>These Terms and any non-contractual obligation arising out of or in connection with these Terms
//                   shall be governed by the laws of the Republic of Estonia. Any dispute, controversy, or claim arising
//                   out of these Terms or any non-contractual obligation arising out of or in connection with these
//                   Terms shall be resolved through direct negotiations between the Site and the customer or if the
//                   parties are unable to resolve the dispute through negotiations, then the dispute shall be settled in
//                   Harju County Court according to the laws of the Republic of Estonia. If your habitual residence is
//                   in the EU, and you are a consumer, you additionally possess the protection provided to you by the
//                   obligatory provision of the law or your country of residence.</p>
//               <h4>CORRECTIONS</h4>
//               <p>There may be information on the Site that contains typographical errors, inaccuracies, or
//                   omissions, including descriptions, pricing, availability, and various other information. We reservethe right
//                   to correct any error, inaccuracies, or omissions and to change or update the information
//                   on the Site at any time, without prior notice.</p>
//               <h4>DISCLAIMER</h4>
//               <p>The Site is provided on an as-is and as-available basis. You agree that your use of the Site and our
//                   services will be at your sole risk. To the fullest extent permitted by law, we disclaim all warranties,
//                   express or implied, in connection with the Site and your use thereof, including, without limitation,
//                   the implied warranties of merchantability, fitness for a particular purpose, and non-infringement.
//                   We make no warranties or representations about the accuracy or completeness of the Site’s content
//                   or the content of any apps linked to the Site and we will assume no liability or responsibility for
//                   any 1) errors, mistakes, or inaccuracies of content and materials, 2) any authorized access to or use
//                   of our secure servers and/or financial information stored therein, 3) any interruption or cessation
//                   of transmission to or from the Site 4) any bugs, viruses, trojan horses, or the like which may be
//                   transmitted to or through the Site by any third party, and/or 6) any errors or omissions in any
//                   content and materials or for any loss or damage of any content and materials or for any loss or
//                   damage of any kind incurred as a result of the use of any content posted, transmitted, or otherwise
//                   made available via the Site. We do not warrant, endorse, guarantee, or assume responsibility for
//                   any product or service advertised or offered by a third party through the Site, any hyperlinked app,
//                   or any app or mobile application featured in any banner or other advertising, and we will not be a
//                   party to or in any way responsible for monitoring any transaction between you and any third-party
//                   providers of products or services. As with the purchase of a product or service through any medium
//                   or in any environment, you should use your best judgment and exercise caution where appropriate.</p>
//               <h4>CONTACT US</h4>
//               <p>To resolve a complaint regarding the Site or to receive further information regarding the use of the
//                   Site, please contact us.</p>
//           </div>
//       </body>
    
//     </html>
//   ''';

//   // @override
//   // List<RapydSupportedCountries> getRapydSupportedCountries() {
//   //   var data = _remoteConfig.getAll()[RAPYD_SUPPORTED_COUNTRIES];
//   //
//   //   var list = List.from(jsonDecode(data!.asString())).map((e) => RapydSupportedCountries.fromJson(e)).toList();
//   //   return list;
//   // }
// }
