part of 'espy.dart';

class UpsertCityVariablesBuilder {
  String id;
  String regionId;
  String nameEn;
  String nameAr;
  Optional<double> _lat = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _lng = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertCityVariablesBuilder lat(double? t) {
   _lat.value = t;
   return this;
  }
  UpsertCityVariablesBuilder lng(double? t) {
   _lng.value = t;
   return this;
  }

  UpsertCityVariablesBuilder(this._dataConnect, {required  this.id,required  this.regionId,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertCityData> dataDeserializer = (dynamic json)  => UpsertCityData.fromJson(jsonDecode(json));
  Serializer<UpsertCityVariables> varsSerializer = (UpsertCityVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCityData, UpsertCityVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCityData, UpsertCityVariables> ref() {
    UpsertCityVariables vars= UpsertCityVariables(id: id,regionId: regionId,nameEn: nameEn,nameAr: nameAr,lat: _lat,lng: _lng,);
    return _dataConnect.mutation("UpsertCity", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCityCityUpsert {
  final String id;
  UpsertCityCityUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCityCityUpsert otherTyped = other as UpsertCityCityUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertCityCityUpsert({
    required this.id,
  });
}

@immutable
class UpsertCityData {
  final UpsertCityCityUpsert city_upsert;
  UpsertCityData.fromJson(dynamic json):
  
  city_upsert = UpsertCityCityUpsert.fromJson(json['city_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCityData otherTyped = other as UpsertCityData;
    return city_upsert == otherTyped.city_upsert;
    
  }
  @override
  int get hashCode => city_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['city_upsert'] = city_upsert.toJson();
    return json;
  }

  UpsertCityData({
    required this.city_upsert,
  });
}

@immutable
class UpsertCityVariables {
  final String id;
  final String regionId;
  final String nameEn;
  final String nameAr;
  late final Optional<double>lat;
  late final Optional<double>lng;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCityVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  regionId = nativeFromJson<String>(json['regionId']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']) {
  
  
  
  
  
  
    lat = Optional.optional(nativeFromJson, nativeToJson);
    lat.value = json['lat'] == null ? null : nativeFromJson<double>(json['lat']);
  
  
    lng = Optional.optional(nativeFromJson, nativeToJson);
    lng.value = json['lng'] == null ? null : nativeFromJson<double>(json['lng']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCityVariables otherTyped = other as UpsertCityVariables;
    return id == otherTyped.id && 
    regionId == otherTyped.regionId && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    lat == otherTyped.lat && 
    lng == otherTyped.lng;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, regionId.hashCode, nameEn.hashCode, nameAr.hashCode, lat.hashCode, lng.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['regionId'] = nativeToJson<String>(regionId);
    json['nameEn'] = nativeToJson<String>(nameEn);
    json['nameAr'] = nativeToJson<String>(nameAr);
    if(lat.state == OptionalState.set) {
      json['lat'] = lat.toJson();
    }
    if(lng.state == OptionalState.set) {
      json['lng'] = lng.toJson();
    }
    return json;
  }

  UpsertCityVariables({
    required this.id,
    required this.regionId,
    required this.nameEn,
    required this.nameAr,
    required this.lat,
    required this.lng,
  });
}

