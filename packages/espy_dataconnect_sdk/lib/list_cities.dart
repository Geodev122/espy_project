part of 'espy.dart';

class ListCitiesVariablesBuilder {
  String regionId;

  final FirebaseDataConnect _dataConnect;
  ListCitiesVariablesBuilder(this._dataConnect, {required  this.regionId,});
  Deserializer<ListCitiesData> dataDeserializer = (dynamic json)  => ListCitiesData.fromJson(jsonDecode(json));
  Serializer<ListCitiesVariables> varsSerializer = (ListCitiesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListCitiesData, ListCitiesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListCitiesData, ListCitiesVariables> ref() {
    ListCitiesVariables vars= ListCitiesVariables(regionId: regionId,);
    return _dataConnect.query("ListCities", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListCitiesCities {
  final String id;
  final String nameEn;
  final String? nameAr;
  final double? lat;
  final double? lng;
  final ListCitiesCitiesRegion region;
  ListCitiesCities.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  lat = json['lat'] == null ? null : nativeFromJson<double>(json['lat']),
  lng = json['lng'] == null ? null : nativeFromJson<double>(json['lng']),
  region = ListCitiesCitiesRegion.fromJson(json['region']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCitiesCities otherTyped = other as ListCitiesCities;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    lat == otherTyped.lat && 
    lng == otherTyped.lng && 
    region == otherTyped.region;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, lat.hashCode, lng.hashCode, region.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (lat != null) {
      json['lat'] = nativeToJson<double?>(lat);
    }
    if (lng != null) {
      json['lng'] = nativeToJson<double?>(lng);
    }
    json['region'] = region.toJson();
    return json;
  }

  ListCitiesCities({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.lat,
    this.lng,
    required this.region,
  });
}

@immutable
class ListCitiesCitiesRegion {
  final String id;
  ListCitiesCitiesRegion.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCitiesCitiesRegion otherTyped = other as ListCitiesCitiesRegion;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListCitiesCitiesRegion({
    required this.id,
  });
}

@immutable
class ListCitiesData {
  final List<ListCitiesCities> cities;
  ListCitiesData.fromJson(dynamic json):
  
  cities = (json['cities'] as List<dynamic>)
        .map((e) => ListCitiesCities.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCitiesData otherTyped = other as ListCitiesData;
    return cities == otherTyped.cities;
    
  }
  @override
  int get hashCode => cities.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cities'] = cities.map((e) => e.toJson()).toList();
    return json;
  }

  ListCitiesData({
    required this.cities,
  });
}

@immutable
class ListCitiesVariables {
  final String regionId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListCitiesVariables.fromJson(Map<String, dynamic> json):
  
  regionId = nativeFromJson<String>(json['regionId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCitiesVariables otherTyped = other as ListCitiesVariables;
    return regionId == otherTyped.regionId;
    
  }
  @override
  int get hashCode => regionId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['regionId'] = nativeToJson<String>(regionId);
    return json;
  }

  ListCitiesVariables({
    required this.regionId,
  });
}

