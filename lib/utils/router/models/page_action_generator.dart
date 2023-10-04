
import 'package:logger/logger.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:happiness_club_merchant/utils/router/models/page_config.dart';

import '../../constants/app_state_enum.dart';
import '../app_state.dart';

class PageActionGenerator {
  PageAction getPageConfigBasedOnState(AppStateEnum appStateEnum) {
    var log = Logger();

    log.i(appStateEnum);

    // switch (appStateEnum) {
    //   case AppStateEnum.NONE:
    //     return PageAction(state: PageState.replaceAll, page: LoginRegisterConfig);
    //   // case AppStateEnum.EMAIL_VERIFICATION:
    //   //   return PageAction(state: PageState.replace, page: AddEmailConfig);
    //   // case AppStateEnum.EMAIL_VERIFIED:
    //   //   return PageAction(state: PageState.replace, page: EmailVerifiedConfig);
    //   default:
    //     break;
    // }

    return PageAction(state: PageState.replace, page: LoginRegisterConfig);
  }
}
