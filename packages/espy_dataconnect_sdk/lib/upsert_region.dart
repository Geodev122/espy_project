part of 'espy.dart';

class UpsertRegionVariablesBuilder {
  String id;
  String countryId;
  String nameEn;
  String nameAr;
  Optional<String> _regionCode = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertRegionVariablesBuilder regionCode(String? t) {
   _regionCode.value = t;
   return this;
  }

  UpsertRegionVariablesBuilder(this._dataConnect, {required  this.id,required  this.countryId,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertRegionData> dataDeserializer = (dynamic json)  => UpsertRegionData.fromJson(jsonDecode(json));
  Serializer<UpsertRegionVariables> varsSerializer = (UpsertRegionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertRegionData, UpsertRegionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertRegionData, UpsertRegionVariables> ref() {
    UpsertRegionVariables vars= UpsertRegionVariables(id: id,countryId: countryId,nameEn: nameEn,nameAr: nameAr,regionCode: _regionCode,);
    return _dataConnect.mutation("UpsertRegion", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertRegionRegionUpsert {
  final String id;
  UpsertRegionRegionUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertRegionRegionUpsert otherTyped = other as UpsertRegionRegionUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertRegionRegionUpsert({
    required this.id,
  });
}

@immutable
class UpsertRegionData {
  final UpsertRegionRegionUpsert region_upsert;
  UpsertRegionData.fromJson(dynamic json):
  
  region_upsert = UpsertRegionRegionUpsert.fromJson(json['region_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertRegionData otherTyped = other as UpsertRegionData;
    return region_upsert == otherTyped.region_upsert;
    
  }
  @override
  int get hashCode => region_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['region_upsert'] = region_upsert.toJson();
    return json;
  }

  UpsertRegionData({
    required this.region_upsert,
  });
}

@immutable
class UpsertRegionVariables {
  final String id;
  final String countryId;
  final String nameEn;
  final String nameAr;
  late final Optional<String>regionCode;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertRegionVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  countryId = nativeFromJson<String>(json['countryId']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']) {
  
  
  
  
  
  
    regionCode = Optional.optional(nativeFromJson, nativeToJson);
    regionCode.value = json['regionCode'] == null ? null : nativeFromJson<String>(json['regionCode']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertRegionVariables otherTyped = other as UpsertRegionVariables;
    return id == otherTyped.id && 
    countryId == otherTyped.countryId && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    regionCode == otherTyped.regionCode;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, countryId.hashCode, nameEn.hashCode, nameAr.hashCode, regionCode.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['countryId'] = nativeToJson<String>(countryId);
    json['nameEn'] = nativeToJson<String>(nameEn);
    json['nameAr'] = nativeToJson<String>(nameAr);
    if(regionCode.state == OptionalState.set) {
      json['regionCode'] = regionCode.toJson();
    }
    return json;
  }

  UpsertRegionVariables({
    required this.id,
    required this.countryId,
    required this.nameEn,
    required this.nameAr,
    required this.regionCode,
  });
}

