part of 'espy.dart';

class ListRegionsVariablesBuilder {
  String countryId;

  final FirebaseDataConnect _dataConnect;
  ListRegionsVariablesBuilder(this._dataConnect, {required  this.countryId,});
  Deserializer<ListRegionsData> dataDeserializer = (dynamic json)  => ListRegionsData.fromJson(jsonDecode(json));
  Serializer<ListRegionsVariables> varsSerializer = (ListRegionsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListRegionsData, ListRegionsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListRegionsData, ListRegionsVariables> ref() {
    ListRegionsVariables vars= ListRegionsVariables(countryId: countryId,);
    return _dataConnect.query("ListRegions", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListRegionsRegions {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? regionCode;
  ListRegionsRegions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  regionCode = json['regionCode'] == null ? null : nativeFromJson<String>(json['regionCode']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRegionsRegions otherTyped = other as ListRegionsRegions;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    regionCode == otherTyped.regionCode;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, regionCode.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (regionCode != null) {
      json['regionCode'] = nativeToJson<String?>(regionCode);
    }
    return json;
  }

  ListRegionsRegions({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.regionCode,
  });
}

@immutable
class ListRegionsData {
  final List<ListRegionsRegions> regions;
  ListRegionsData.fromJson(dynamic json):
  
  regions = (json['regions'] as List<dynamic>)
        .map((e) => ListRegionsRegions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRegionsData otherTyped = other as ListRegionsData;
    return regions == otherTyped.regions;
    
  }
  @override
  int get hashCode => regions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['regions'] = regions.map((e) => e.toJson()).toList();
    return json;
  }

  ListRegionsData({
    required this.regions,
  });
}

@immutable
class ListRegionsVariables {
  final String countryId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListRegionsVariables.fromJson(Map<String, dynamic> json):
  
  countryId = nativeFromJson<String>(json['countryId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRegionsVariables otherTyped = other as ListRegionsVariables;
    return countryId == otherTyped.countryId;
    
  }
  @override
  int get hashCode => countryId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['countryId'] = nativeToJson<String>(countryId);
    return json;
  }

  ListRegionsVariables({
    required this.countryId,
  });
}

