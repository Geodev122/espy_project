part of 'espy.dart';

class ListElementPricingVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListElementPricingVariablesBuilder(this._dataConnect, );
  Deserializer<ListElementPricingData> dataDeserializer = (dynamic json)  => ListElementPricingData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListElementPricingData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListElementPricingData, void> ref() {
    
    return _dataConnect.query("ListElementPricing", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListElementPricingElementPricings {
  final String id;
  final int tokenCost;
  final int? validityDays;
  final Timestamp? updatedAt;
  ListElementPricingElementPricings.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  tokenCost = nativeFromJson<int>(json['tokenCost']),
  validityDays = json['validityDays'] == null ? null : nativeFromJson<int>(json['validityDays']),
  updatedAt = json['updatedAt'] == null ? null : Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListElementPricingElementPricings otherTyped = other as ListElementPricingElementPricings;
    return id == otherTyped.id && 
    tokenCost == otherTyped.tokenCost && 
    validityDays == otherTyped.validityDays && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, tokenCost.hashCode, validityDays.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['tokenCost'] = nativeToJson<int>(tokenCost);
    if (validityDays != null) {
      json['validityDays'] = nativeToJson<int?>(validityDays);
    }
    if (updatedAt != null) {
      json['updatedAt'] = updatedAt!.toJson();
    }
    return json;
  }

  ListElementPricingElementPricings({
    required this.id,
    required this.tokenCost,
    this.validityDays,
    this.updatedAt,
  });
}

@immutable
class ListElementPricingData {
  final List<ListElementPricingElementPricings> elementPricings;
  ListElementPricingData.fromJson(dynamic json):
  
  elementPricings = (json['elementPricings'] as List<dynamic>)
        .map((e) => ListElementPricingElementPricings.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListElementPricingData otherTyped = other as ListElementPricingData;
    return elementPricings == otherTyped.elementPricings;
    
  }
  @override
  int get hashCode => elementPricings.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['elementPricings'] = elementPricings.map((e) => e.toJson()).toList();
    return json;
  }

  ListElementPricingData({
    required this.elementPricings,
  });
}

