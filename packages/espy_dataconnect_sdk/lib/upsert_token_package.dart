part of 'espy.dart';

class UpsertTokenPackageVariablesBuilder {
  String id;
  String nameEn;
  Optional<String> _nameAr = Optional.optional(nativeFromJson, nativeToJson);
  int tokenCount;
  double price;
  Optional<double> _discountRate = Optional.optional(nativeFromJson, nativeToJson);
  UserRole targetRole;
  bool isActive;

  final FirebaseDataConnect _dataConnect;  UpsertTokenPackageVariablesBuilder nameAr(String? t) {
   _nameAr.value = t;
   return this;
  }
  UpsertTokenPackageVariablesBuilder discountRate(double? t) {
   _discountRate.value = t;
   return this;
  }

  UpsertTokenPackageVariablesBuilder(this._dataConnect, {required  this.id,required  this.nameEn,required  this.tokenCount,required  this.price,required  this.targetRole,required  this.isActive,});
  Deserializer<UpsertTokenPackageData> dataDeserializer = (dynamic json)  => UpsertTokenPackageData.fromJson(jsonDecode(json));
  Serializer<UpsertTokenPackageVariables> varsSerializer = (UpsertTokenPackageVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertTokenPackageData, UpsertTokenPackageVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertTokenPackageData, UpsertTokenPackageVariables> ref() {
    UpsertTokenPackageVariables vars= UpsertTokenPackageVariables(id: id,nameEn: nameEn,nameAr: _nameAr,tokenCount: tokenCount,price: price,discountRate: _discountRate,targetRole: targetRole,isActive: isActive,);
    return _dataConnect.mutation("UpsertTokenPackage", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertTokenPackageTokenPackageUpsert {
  final String id;
  UpsertTokenPackageTokenPackageUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTokenPackageTokenPackageUpsert otherTyped = other as UpsertTokenPackageTokenPackageUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertTokenPackageTokenPackageUpsert({
    required this.id,
  });
}

@immutable
class UpsertTokenPackageData {
  final UpsertTokenPackageTokenPackageUpsert tokenPackage_upsert;
  UpsertTokenPackageData.fromJson(dynamic json):
  
  tokenPackage_upsert = UpsertTokenPackageTokenPackageUpsert.fromJson(json['tokenPackage_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTokenPackageData otherTyped = other as UpsertTokenPackageData;
    return tokenPackage_upsert == otherTyped.tokenPackage_upsert;
    
  }
  @override
  int get hashCode => tokenPackage_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tokenPackage_upsert'] = tokenPackage_upsert.toJson();
    return json;
  }

  UpsertTokenPackageData({
    required this.tokenPackage_upsert,
  });
}

@immutable
class UpsertTokenPackageVariables {
  final String id;
  final String nameEn;
  late final Optional<String>nameAr;
  final int tokenCount;
  final double price;
  late final Optional<double>discountRate;
  final UserRole targetRole;
  final bool isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertTokenPackageVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  tokenCount = nativeFromJson<int>(json['tokenCount']),
  price = nativeFromJson<double>(json['price']),
  targetRole = UserRole.values.byName(json['targetRole']),
  isActive = nativeFromJson<bool>(json['isActive']) {
  
  
  
  
    nameAr = Optional.optional(nativeFromJson, nativeToJson);
    nameAr.value = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  
  
  
  
    discountRate = Optional.optional(nativeFromJson, nativeToJson);
    discountRate.value = json['discountRate'] == null ? null : nativeFromJson<double>(json['discountRate']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTokenPackageVariables otherTyped = other as UpsertTokenPackageVariables;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    tokenCount == otherTyped.tokenCount && 
    price == otherTyped.price && 
    discountRate == otherTyped.discountRate && 
    targetRole == otherTyped.targetRole && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, tokenCount.hashCode, price.hashCode, discountRate.hashCode, targetRole.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if(nameAr.state == OptionalState.set) {
      json['nameAr'] = nameAr.toJson();
    }
    json['tokenCount'] = nativeToJson<int>(tokenCount);
    json['price'] = nativeToJson<double>(price);
    if(discountRate.state == OptionalState.set) {
      json['discountRate'] = discountRate.toJson();
    }
    json['targetRole'] = 
    targetRole.name
    ;
    json['isActive'] = nativeToJson<bool>(isActive);
    return json;
  }

  UpsertTokenPackageVariables({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.tokenCount,
    required this.price,
    required this.discountRate,
    required this.targetRole,
    required this.isActive,
  });
}

