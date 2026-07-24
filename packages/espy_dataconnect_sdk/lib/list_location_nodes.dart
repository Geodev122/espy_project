part of 'espy.dart';

class ListLocationNodesVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  ListLocationNodesVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<ListLocationNodesData> dataDeserializer = (dynamic json)  => ListLocationNodesData.fromJson(jsonDecode(json));
  Serializer<ListLocationNodesVariables> varsSerializer = (ListLocationNodesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListLocationNodesData, ListLocationNodesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListLocationNodesData, ListLocationNodesVariables> ref() {
    ListLocationNodesVariables vars= ListLocationNodesVariables(userId: userId,);
    return _dataConnect.query("ListLocationNodes", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListLocationNodesLocationNodes {
  final String id;
  final String? label;
  final ListLocationNodesLocationNodesCity city;
  final double lat;
  final double lng;
  final bool isMain;
  ListLocationNodesLocationNodes.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  label = json['label'] == null ? null : nativeFromJson<String>(json['label']),
  city = ListLocationNodesLocationNodesCity.fromJson(json['city']),
  lat = nativeFromJson<double>(json['lat']),
  lng = nativeFromJson<double>(json['lng']),
  isMain = nativeFromJson<bool>(json['isMain']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLocationNodesLocationNodes otherTyped = other as ListLocationNodesLocationNodes;
    return id == otherTyped.id && 
    label == otherTyped.label && 
    city == otherTyped.city && 
    lat == otherTyped.lat && 
    lng == otherTyped.lng && 
    isMain == otherTyped.isMain;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, label.hashCode, city.hashCode, lat.hashCode, lng.hashCode, isMain.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (label != null) {
      json['label'] = nativeToJson<String?>(label);
    }
    json['city'] = city.toJson();
    json['lat'] = nativeToJson<double>(lat);
    json['lng'] = nativeToJson<double>(lng);
    json['isMain'] = nativeToJson<bool>(isMain);
    return json;
  }

  ListLocationNodesLocationNodes({
    required this.id,
    this.label,
    required this.city,
    required this.lat,
    required this.lng,
    required this.isMain,
  });
}

@immutable
class ListLocationNodesLocationNodesCity {
  final String id;
  final String nameEn;
  final String? nameAr;
  ListLocationNodesLocationNodesCity.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLocationNodesLocationNodesCity otherTyped = other as ListLocationNodesLocationNodesCity;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    return json;
  }

  ListLocationNodesLocationNodesCity({
    required this.id,
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListLocationNodesData {
  final List<ListLocationNodesLocationNodes> locationNodes;
  ListLocationNodesData.fromJson(dynamic json):
  
  locationNodes = (json['locationNodes'] as List<dynamic>)
        .map((e) => ListLocationNodesLocationNodes.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLocationNodesData otherTyped = other as ListLocationNodesData;
    return locationNodes == otherTyped.locationNodes;
    
  }
  @override
  int get hashCode => locationNodes.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['locationNodes'] = locationNodes.map((e) => e.toJson()).toList();
    return json;
  }

  ListLocationNodesData({
    required this.locationNodes,
  });
}

@immutable
class ListLocationNodesVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListLocationNodesVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLocationNodesVariables otherTyped = other as ListLocationNodesVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  ListLocationNodesVariables({
    required this.userId,
  });
}

