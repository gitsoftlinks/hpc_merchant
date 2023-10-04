import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../app/app_usecase/get_access_token.dart';
import '../../../utils/router/app_state.dart';
import '../../../utils/router/models/page_action.dart';
import '../../../utils/router/models/page_config.dart';
import '../../../utils/router/ui_pages.dart';
import '../../error/failure.dart';
import '../../usecases/usecase.dart';
import '../dynamic_link_logic.dart';

class PostDetailHandler implements DynamicLinkHandler {
  final Uri _uri;
  // final GetAppState _getAppState;
  final AppState _appState;
  final GetSavedAccessToken _getSavedAccessToken;

  PostDetailHandler({
    required Uri uri,
    required AppState appState,
    // required GetAppState getAppState,
    required GetSavedAccessToken getSavedAccessToken,
  })  : _uri = uri,
        _appState = appState,
        // _getAppState = getAppState,
        _getSavedAccessToken = getSavedAccessToken;

  @override
  Future<Either<Failure, bool>> handle() async {
    var accessToken = await getAccessToken();
    final String? postId =
        _uri.hasQuery ? _uri.queryParameters['post_id'] : null;
    final String? postCategoryId =
        _uri.hasQuery ? _uri.queryParameters['category_id'] : null;
    var log = Logger();
    log.i('-------------------d1');

    if (accessToken.isEmpty) {
      _appState.currentAction =
          PageAction(state: PageState.replaceAll, page: LoginRegisterConfig);
      return const Right(true);
    }

    log.i('-------------------d2');

    if (postId != null &&
        postId.isNotEmpty &&
        postCategoryId != null &&
        postCategoryId.isNotEmpty) {
      ///move to post detail screen
      //   _appState.currentAction = PageAction(state: PageState.addPage, page: PageConfiguration.withArguments(PostDetailsScreenConfig, {'postId': postId, 'categoryId': postCategoryId}));
    } else {
      _appState.currentAction =
          PageAction(state: PageState.replaceAll, page: SplashPageConfig);
    }
    return const Right(false);
  }

  Future<String> getAccessToken() async {
    var accessTokenEither = await _getSavedAccessToken.call(NoParams());
    if (accessTokenEither.isLeft()) {
      return '';
    }

    return accessTokenEither.getOrElse(() => '');
  }
}
