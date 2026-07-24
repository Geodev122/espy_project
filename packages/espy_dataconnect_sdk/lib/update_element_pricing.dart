part of 'espy.dart';

class UpdateElementPricingVariablesBuilder {
  String id;
  int tokenCost;
  Optional<int> _validityDays = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateElementPricingVariablesBuilder validityDays(int? t) {
   _validityDays.value = t;
   return this;
  }

  UpdateElementPricingVariablesBuilder(this._dataConnect, {required  this.id,required  this.tokenCost,});
  Deserializer<UpdateElementPricingData> dataDeserializer = (dynamic json)  => UpdateElementPricingData.fromJson(jsonDecode(json));
  Serializer<UpdateElementPricingVariables> varsSerializer = (UpdateElementPricingVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateElementPricingData, UpdateElementPricingVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateElementPricingData, UpdateElementPricingVariables> ref() {
    UpdateElementPricingVariables vars= UpdateElementPricingVariables(id: id,tokenCost: tokenCost,validityDays: _validityDays,);
    return _dataConnect.mutation("UpdateElementPricing", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateElementPricingElementPricingUpsert {
  final String id;
  UpdateElementPricingElementPricingUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateElementPricingElementPricingUpsert otherTyped = other as UpdateElementPricingElementPricingUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateElementPricingElementPricingUpsert({
    required this.id,
  });
}

@immutable
class UpdateElementPricingData {
  final UpdateElementPricingElementPricingUpsert elementPricing_upsert;
  UpdateElementPricingData.fromJson(dynamic json):
  
  elementPricing_upsert = UpdateElementPricingElementPricingUpsert.fromJson(json['elementPricing_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateElementPricingData otherTyped = other as UpdateElementPricingData;
    return elementPricing_upsert == otherTyped.elementPricing_upsert;
    
  }
  @override
  int get hashCode => elementPricing_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['elementPricing_upsert'] = elementPricing_upsert.toJson();
    return json;
  }

  UpdateElementPricingData({
    required this.elementPricing_upsert,
  });
}

@immutable
class UpdateElementPricingVariables {
  final String id;
  final int tokenCost;
  late final Optional<int>validityDays;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateElementPricingVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  tokenCost = nativeFromJson<int>(json['tokenCost']) {
  
  
  
  
    validityDays = Optional.optional(nativeFromJson, nativeToJson);
    validityDays.value = json['validityDays'] == null ? null : nativeFromJson<int>(json['validityDays']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateElementPricingVariables otherTyped = other as UpdateElementPricingVariables;
    return id == otherTyped.id && 
    tokenCost == otherTyped.tokenCost && 
    validityDays == otherTyped.validityDays;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, tokenCost.hashCode, validityDays.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['tokenCost'] = nativeToJson<int>(tokenCost);
    if(validityDays.state == OptionalState.set) {
      json['validityDays'] = validityDays.toJson();
    }
    return json;
  }

  UpdateElementPricingVariables({
    required this.id,
    required this.tokenCost,
    required this.validityDays,
  });
}

