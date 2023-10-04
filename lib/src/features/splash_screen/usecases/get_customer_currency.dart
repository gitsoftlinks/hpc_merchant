import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';


/// This method returns the customer currencies from server
/// Input: [CustomerCurrencyGetParams] contains the user's location country code and accessToken
/// Output : [CustomerCurrencyGetResponse] contains the supported currency response
/// if unsuccessful the response will be [Failure]
class CustomerCurrencyGet implements UseCase<CustomerCurrencyGetResponse, CustomerCurrencyGetParams>{
  final Repository _repository;

  CustomerCurrencyGet(this._repository);

  @override
  Future<Either<Failure, CustomerCurrencyGetResponse>> call(CustomerCurrencyGetParams params) {
    return _repository.getCustomerCurrency(params);
  }
}

class CustomerCurrencyGetParams extends Equatable{
  final String countryCode;
  final String accessToken;

  const CustomerCurrencyGetParams({required this.countryCode, required this.accessToken});

  factory CustomerCurrencyGetParams.withAccessToken({required String accessToken, required CustomerCurrencyGetParams params}){
    return CustomerCurrencyGetParams(countryCode: params.countryCode, accessToken: accessToken);
  }


  @override
  List<Object?> get props => [countryCode];
}


class CustomerCurrencyGetResponse extends Equatable{
  final String id;
  final String currencyCode;
  final String? currencyName;
  final String? currencySymbol;
  final bool enabled;
  final double? exchangeRate;

  const CustomerCurrencyGetResponse({
    required this.id,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.enabled,
    required this.exchangeRate,
  });

  factory CustomerCurrencyGetResponse.empty(){
    return const CustomerCurrencyGetResponse(id: '', currencyCode: 'USD', currencyName: 'USD', currencySymbol: '\$', enabled: false, exchangeRate: 0);
  }

  factory CustomerCurrencyGetResponse.fromJson(Map<String, dynamic> json) => CustomerCurrencyGetResponse(
    id: json["id"],
    currencyCode: json["currencyCode"],
    currencyName: json["currencyName"],
    currencySymbol: json["currencySymbol"],
    enabled: json["enabled"],
    exchangeRate: json["exchangeRate"]
  );

  @override
  List<Object?> get props => [id, currencyCode, currencyName, currencySymbol, enabled, exchangeRate];

}
