import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../utils/constants/dynamic_link_constants.dart';
import '../../utils/globals.dart';
import '../error/failure.dart';
import 'handlers/post_detail_handler.dart';

/// This class will handle our dynamic link for each use case
abstract class DynamicLinkHandler {
  Future<Either<Failure, bool>> handle();
}

/// This abstract is for dynamic link factory to create Handlers at runtime for different uris
abstract class DynamicLinkHandlerFactory {
  ///This method is responsible for generating the link
  /// Input: [uri] is the link in the dynamic link
  /// Output: [DynamicLinkHandler] the handler of the link
  DynamicLinkHandler generateLink(Uri uri);
}

/// This class contains the end points for each of the recognized dynamic link and creates handler for each use case
class DynamicLinkHandlerFactoryImp implements DynamicLinkHandlerFactory {
  @override
  DynamicLinkHandler generateLink(Uri uri) {
    if (uri.toString().contains(DynamicLinkQueryConstants.postDetail)) {
      return PostDetailHandler(
          uri: uri,
          appState: sl(),
          getSavedAccessToken: sl());
    }

    return DefaultHandler();
  }
}

class DefaultHandler implements DynamicLinkHandler {
  @override
  Future<Either<Failure, bool>> handle() async {
    // return Left(CacheFailure(SOMETHING_WENT_WRONG));
    /// Only so that the splash screen doesn't stop and continue in its path
    return const Right(false);
  }
}
