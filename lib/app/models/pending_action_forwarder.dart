import 'package:get_it/get_it.dart';
import 'package:happiness_club_merchant/utils/router/models/page_config.dart';

import '../../services/dynamic_link_core_logic/usecases/save_pending_action.dart';
import '../../utils/router/app_state.dart';
import '../../utils/router/models/page_action.dart';
import '../../utils/router/ui_pages.dart';

class PendingActionForwarder {
  //

  static void movePendingAction(String type, {dynamic data}) {
    // switch (type) {
    //   case SavePendingAction.postDetailAction:
    //     GetIt.I.get<AppState>().currentAction = PageAction(
    //         state: PageState.addPage,
    //         page: PageConfiguration.withArguments(PostDetailsScreenConfig, {
    //           'postId': data['post_id'].toString(),
    //           'categoryId': data['category_id'].toString(),
    //           'isCommentClicked': data['isCommentClicked']
    //         }));
    //     return;
    //   case SavePendingAction.orderDetailAction:
    //     GetIt.I.get<AppState>().currentAction = PageAction(
    //         state: PageState.addPage, page: OrdersAndPurchasesScreenConfig);
    //     return;
    //  }
  }
}
