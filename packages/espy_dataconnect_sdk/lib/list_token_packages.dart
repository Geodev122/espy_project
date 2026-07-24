part of 'espy.dart';

class ListTokenPackagesVariablesBuilder {
  Optional<UserRole> _targetRole = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
  Optional<bool> _isActive = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListTokenPackagesVariablesBuilder targetRole(UserRole? t) {
   _targetRole.value = t;
   return this;
  }
  ListTokenPackagesVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }

  ListTokenPackagesVariablesBuilder(this._dataConnect, );
  Deserializer<ListTokenPackagesData> dataDeserializer = (dynamic json)  => ListTokenPackagesData.fromJson(jsonDecode(json));
  Serializer<ListTokenPackagesVariables> varsSerializer = (ListTokenPackagesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListTokenPackagesData, ListTokenPackagesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListTokenPackagesData, ListTokenPackagesVariables> ref() {
    ListTokenPackagesVariables vars= ListTokenPackagesVariables(targetRole: _targetRole,isActive: _isActive,);
    return _dataConnect.query("ListTokenPackages", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListTokenPackagesTokenPackages {
  final String id;
  final String nameEn;
  final String? nameAr;
  final int tokenCount;
  final double price;
  final double? discountRate;
  final EnumValue<UserRole> targetRole;
  final bool isActive;
  ListTokenPackagesTokenPackages.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  tokenCount = nativeFromJson<int>(json['tokenCount']),
  price = nativeFromJson<double>(json['price']),
  discountRate = json['discountRate'] == null ? null : nativeFromJson<double>(json['discountRate']),
  targetRole = userRoleDeserializer(json['targetRole']),
  isActive = nativeFromJson<bool>(json['isActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTokenPackagesTokenPackages otherTyped = other as ListTokenPackagesTokenPackages;
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
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    json['tokenCount'] = nativeToJson<int>(tokenCount);
    json['price'] = nativeToJson<double>(price);
    if (discountRate != null) {
      json['discountRate'] = nativeToJson<double?>(discountRate);
    }
    json['targetRole'] = 
    userRoleSerializer(targetRole)
    ;
    json['isActive'] = nativeToJson<bool>(isActive);
    return json;
  }

  ListTokenPackagesTokenPackages({
    required this.id,
    required this.nameEn,
    this.nameAr,
    required this.tokenCount,
    required this.price,
    this.discountRate,
    required this.targetRole,
    required this.isActive,
  });
}

@immutable
class ListTokenPackagesData {
  final List<ListTokenPackagesTokenPackages> tokenPackages;
  ListTokenPackagesData.fromJson(dynamic json):
  
  tokenPackages = (json['tokenPackages'] as List<dynamic>)
        .map((e) => ListTokenPackagesTokenPackages.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTokenPackagesData otherTyped = other as ListTokenPackagesData;
    return tokenPackages == otherTyped.tokenPackages;
    
  }
  @override
  int get hashCode => tokenPackages.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tokenPackages'] = tokenPackages.map((e) => e.toJson()).toList();
    return json;
  }

  ListTokenPackagesData({
    required this.tokenPackages,
  });
}

@immutable
class ListTokenPackagesVariables {
  late final Optional<UserRole>targetRole;
  late final Optional<bool>isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListTokenPackagesVariables.fromJson(Map<String, dynamic> json) {
  
  
    targetRole = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
    targetRole.value = json['targetRole'] == null ? null : UserRole.values.byName(json['targetRole']);
  
  
    isActive = Optional.optional(nativeFromJson, nativeToJson);
    isActive.value = json['isActive'] == null ? null : nativeFromJson<bool>(json['isActive']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTokenPackagesVariables otherTyped = other as ListTokenPackagesVariables;
    return targetRole == otherTyped.targetRole && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([targetRole.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(targetRole.state == OptionalState.set) {
      json['targetRole'] = targetRole.toJson();
    }
    if(isActive.state == OptionalState.set) {
      json['isActive'] = isActive.toJson();
    }
    return json;
  }

  ListTokenPackagesVariables({
    required this.targetRole,
    required this.isActive,
  });
}

