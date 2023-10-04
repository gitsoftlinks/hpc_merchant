import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  String hostUrl;
  BaseUrl(this.hostUrl);

  Account get account => Account(hostUrl);
  Post get post => Post(hostUrl);
  User get user => User(hostUrl);
  Business get business => Business(hostUrl);
  GoogleLocation get googleMapLocation => GoogleLocation(hostUrl);
  Message get message => Message(hostUrl);
}

class Account {
  String hostUrl;

  Account(this.hostUrl);

  String get baseUrl => "$hostUrl/public/api/v1.1";
  String get login => "$baseUrl/login";
  String get logout => "$baseUrl/logout";
  String get forgetPasswordSendOtp => "$baseUrl/forgot_pass";
  String get activateAccountSendOtp => "$baseUrl/email_varification";
  String get activateAccountVerifyOtp => "$baseUrl/email_code_varification";
  String get forgetPasswordVerifyOtp => "$baseUrl/confirm_code";
  String get resetPasswordVerifyOtp => "$baseUrl/password_reset";
}

class Business {
  String hostUrl;

  Business(this.hostUrl);

  String get baseUrl => "$hostUrl/public/api/v1.1";
  String get updateBusiness => "$baseUrl/update-business";
  String get createBusinessAccount => "$baseUrl/create-newbusiness";
  String get getBusinessCategories => "$baseUrl/getBusinessCategories";
  String get getAllBusinesses => "$baseUrl/business-listing-by-user";
  String get getBusinessById => "$baseUrl/business-detail";
  String get addBusinessProduct => "$baseUrl/add-business-product";
  String get updateBusinessProduct => '$baseUrl/update-business-product';
  String get getAllProducts => "$baseUrl/business-product-list";
  String get getProductsDetail => "$baseUrl/business-product-detail";
  String get createOrder => "$baseUrl/createOrder";

  String get getOrders => "$baseUrl/getBusinessOrders";

  String get getPurchases => "$baseUrl/getUserPurchases";

  String get deleteBusiness => "$baseUrl/business-delete";

  String get deleteProduct => "$baseUrl/business-product-delete";
}

class Post {
  String hostUrl;

  String get deletePost => '$baseUrl/post-delete?id=';

  Post(this.hostUrl);

  String get baseUrl => "$hostUrl/public/api/v1.1";

  String get sendFriendRequest => "$baseUrl/send-friend-request";

  String get unFriendUrl => "$baseUrl/unfriend";

  String get cancelFriendRequest => "$baseUrl/cancel-friend-request";

  String get userDetailsData => "$baseUrl/get-user-detailById?user_id=";
  String get deleteSavePost => "$baseUrl/delete-saved-post?id=";
  String get orderStatusUpdate => "$baseUrl/order-status-update";
  String get removeBusinessRole => "$baseUrl/delete-business-role";
  String get searchBusiness => "$baseUrl/search-business?search_value=";
  String get searchINPOst => "$baseUrl/search-in-post?search_value=";
  String get hastTagUrl => "$baseUrl/get-hash-tag?hash_tag=";
  String get userSearch => "$baseUrl/chat-user-serach?user_name=";
  String get friendsList => "$baseUrl/get-user-friends";
  String get addBusinessRole => "$baseUrl/add-business-role";
  String get notFriendList => "$baseUrl/get-users-notfriend";
  String get getPostCategories => "$baseUrl/get-all-postcategories";
  String get getAllPosts => "$baseUrl/get-all-postListing";
  String get createNewPost => "$baseUrl/create-newPost";
  String get likeDislikePost => "$baseUrl/like-dislike-insert";
  String get getPostListings => "$baseUrl/postListing";
  String get getShopPostListings => "$baseUrl/shopListing";
  String get getPollListings => "$baseUrl/pollListing";
  String get getProjectsListings => "$baseUrl/projectsListing";
  String get getPostById => "$baseUrl/get-postDetail-by-id";
  String get insertComments => "$baseUrl/comment-insert";
  String get createPoll => "$baseUrl/create-newPoll";
  String get insertPollVote => "$baseUrl/pollVoting";
  String get saveSharedPost => "$baseUrl/sharedPostSaved-ByUser";
  String get savePost => "$baseUrl/postSaved-ByUser";
  String get getSavedPost => "$baseUrl/postGet-ByUser";
  String get getAllEvents => "$baseUrl/events-list";
  String get getUserEventList => "$baseUrl/user-events-list";
  String get createEvent => "$baseUrl/create-event";
  String get editEvent => "$baseUrl/user-events-update";
  String get deleteEvent => "$baseUrl/user-events-delete";
  String get getCommentsByPostId => "$baseUrl/comment-get-ByPost";
  String get getUserList => "$baseUrl/get-user-list";
  String get getUserPosts => "$baseUrl/get-post-by-user";
  String get updatePost => "$baseUrl/update-post";
  String get sharePost => "$baseUrl/shared-post-in-app";
  String get repostData => "$baseUrl/re-post-by-user";
  String get deletePostAttachments => "$baseUrl/post-attachment-delete";

  String get searchInSuggestionList =>
      "$baseUrl/serach-suggested-friends?user_name=";

  String get acceptFroiendRequest => "$baseUrl/accept-friend-request";

  String get rejectFroiendRequest => "$baseUrl/reject-friend-request";

  String get searchInFriends => "$baseUrl/search-friends?user_name=";

  get thridPartyLogin => "$baseUrl/login_3rdparty";
}

class User {
  //

  String hostUrl;
  User(this.hostUrl);

  String get baseUrl => "";
  String get registerUser =>
      "https://hpcstaging.happinessclub.ae/api/auth/register-user";
  String get registerGuest => "$baseUrl/register-guest-user";
  String get getUserDetail => "$baseUrl/get-user-detail";
  String get updateUser => "$baseUrl/update-user-info";
  String get getProfessions => "$baseUrl/get-all-professions";
  String get updateProfileSetting => "$baseUrl/update-profile-setting";
}

class Message {
  String hostUrl;
  Message(this.hostUrl);

  String get baseUrl => "$hostUrl/public/api/v1.1";
  String get sendMessage => "$baseUrl/message-sent";
  String get getChatByUserId => "$baseUrl/chat-message-by-user";
  String get getChatHistory => "$baseUrl/get-user-chat-list";
  String get updateFCMToken => "$baseUrl/updateFCMToken";
  String get getUserNotification => "$baseUrl/user-notifications";
  String get markNotificationReed => "$baseUrl/mark-notifications-read";
}

class GoogleLocation {
  String hostUrl;
  GoogleLocation(this.hostUrl);

  String get baseUrl => "$hostUrl/public/api/v1.1";
  String get saveInterestedArea => "$baseUrl/user-intrusted-area";
  String get getInterestedAreas => "$baseUrl/get-user-intrusted-area";
  String get deleteInterestedAreas => "$baseUrl/delete-user-intrusted-area";

  String searchPlace({required String input}) {
    return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&inputtype=textquery&key=${dotenv.env["google_map_key"]}";
  }

  String placeDetails({required String placeId}) {
    return "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${dotenv.env["google_map_key"]}";
  }

  String latlngDetails({required String latlng}) {
    return "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latlng&key=${dotenv.env["google_map_key"]}";
  }
}
