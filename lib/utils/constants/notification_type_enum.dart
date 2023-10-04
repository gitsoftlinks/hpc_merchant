// ignore_for_file: constant_identifier_names

enum NotificationTypeEnum {
  none,
  post_like,
  post_dislike,
  post_comment,
  post_comment_reply,
  post_share,
  business_product_bought,
  friend_request
}

extension NotificationTypeEnumPar on String {
  NotificationTypeEnum toNotificationTypeEnum() {
    return NotificationTypeEnum.values.firstWhere(
        (e) =>
            e.toString().toLowerCase() ==
            'NotificationTypeEnum.$this'.toLowerCase(),
        orElse: () => NotificationTypeEnum.none); //return null if not found
  }
}
