import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../services/repository/repository.dart';

/// This method will get all business categories
/// Input: [NoParams] contains accessToken only
/// Output : [GetBusinessCategoriesResponse] contains category response
/// if unsuccessful the response will be [Failure]
class GetBusinessCategories
    implements UseCase<GetBusinessCategoriesResponse, NoParams> {
  final Repository _repository;

  GetBusinessCategories(this._repository);

  @override
  Future<Either<Failure, GetBusinessCategoriesResponse>> call(NoParams) {
    return _repository.getBusinessCategories(NoParams);
  }
}

class GetBusinessCategoriesResponse {
  GetBusinessCategoriesResponse({
    required this.categories,
  });

  List<Category> categories;

  factory GetBusinessCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      GetBusinessCategoriesResponse(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  int id;
  String categoryName;

  Category({
    required this.id,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class BranchLocation {
  String lat;
  String lng;
  String branchName;
  String city;
  BranchLocation(
      {this.lat = '', this.lng = '', this.city = '', this.branchName = ''});
}
