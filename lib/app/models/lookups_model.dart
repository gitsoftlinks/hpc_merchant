
import 'package:equatable/equatable.dart';

class LookUpsGetResponse {
  final int totalCount;
  final List<Item> items;

  LookUpsGetResponse({
    required this.totalCount,
    required this.items,
  });

  factory LookUpsGetResponse.empty(){
    return LookUpsGetResponse(totalCount: 0, items: []);
  }


  factory LookUpsGetResponse.fromJson(Map<String, dynamic> json) => LookUpsGetResponse(
    totalCount: json["totalCount"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );
}

class Item extends Equatable {
  final int value;
  final String name;
  final bool enabled;
  final int? sequence;
  final int? parentId;
  final int? lookupGroupId;
  final int id;

  const Item({
    required this.value,
    required this.name,
    required this.enabled,
    required this.sequence,
    required this.parentId,
    required this.lookupGroupId,
    required this.id,
  });

  factory Item.empty() {
    return const Item(value: 0, name: '', enabled: false, sequence: null, parentId: null, lookupGroupId: null, id: 0);
  }


  factory Item.fromJson(Map<String, dynamic> json) => Item(
    value: json["value"],
    name: json["name"],
    enabled: json["enabled"],
    sequence: json["sequence"],
    parentId: json["parentId"],
    lookupGroupId: json["lookupGroupId"],
    id: json["id"],
  );

  @override
  List<Object?> get props => [value, name, enabled, sequence, parentId, lookupGroupId, id];

}
