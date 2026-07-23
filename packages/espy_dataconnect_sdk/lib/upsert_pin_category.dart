part of 'espy.dart';

class UpsertPinCategoryVariablesBuilder {
  String id;
  String nameEn;
  String nameAr;
  Optional<String> _iconBase = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertPinCategoryVariablesBuilder iconBase(String? t) {
   _iconBase.value = t;
   return this;
  }

  UpsertPinCategoryVariablesBuilder(this._dataConnect, {required  this.id,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertPinCategoryData> dataDeserializer = (dynamic json)  => UpsertPinCategoryData.fromJson(jsonDecode(json));
  Serializer<UpsertPinCategoryVariables> varsSerializer = (UpsertPinCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertPinCategoryData, UpsertPinCategoryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertPinCategoryData, UpsertPinCategoryVariables> ref() {
    UpsertPinCategoryVariables vars= UpsertPinCategoryVariables(id: id,nameEn: nameEn,nameAr: nameAr,iconBase: _iconBase,);
    return _dataConnect.mutation("UpsertPinCategory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertPinCategoryPinCategoryUpsert {
  final String id;
  UpsertPinCategoryPinCategoryUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPinCategoryPinCategoryUpsert otherTyped = other as UpsertPinCategoryPinCategoryUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertPinCategoryPinCategoryUpsert({
    required this.id,
  });
}

@immutable
class UpsertPinCategoryData {
  final UpsertPinCategoryPinCategoryUpsert pinCategory_upsert;
  UpsertPinCategoryData.fromJson(dynamic json):
  
  pinCategory_upsert = UpsertPinCategoryPinCategoryUpsert.fromJson(json['pinCategory_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPinCategoryData otherTyped = other as UpsertPinCategoryData;
    return pinCategory_upsert == otherTyped.pinCategory_upsert;
    
  }
  @override
  int get hashCode => pinCategory_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pinCategory_upsert'] = pinCategory_upsert.toJson();
    return json;
  }

  UpsertPinCategoryData({
    required this.pinCategory_upsert,
  });
}

@immutable
class UpsertPinCategoryVariables {
  final String id;
  final String nameEn;
  final String nameAr;
  late final Optional<String>iconBase;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertPinCategoryVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']) {
  
  
  
  
  
    iconBase = Optional.optional(nativeFromJson, nativeToJson);
    iconBase.value = json['iconBase'] == null ? null : nativeFromJson<String>(json['iconBase']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPinCategoryVariables otherTyped = other as UpsertPinCategoryVariables;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    iconBase == otherTyped.iconBase;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, iconBase.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    json['nameAr'] = nativeToJson<String>(nameAr);
    if(iconBase.state == OptionalState.set) {
      json['iconBase'] = iconBase.toJson();
    }
    return json;
  }

  UpsertPinCategoryVariables({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.iconBase,
  });
}

