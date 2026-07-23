part of 'espy.dart';

class CreateLocationNodeVariablesBuilder {
  String cityId;
  String label;
  double lat;
  double lng;
  bool isMain;

  final FirebaseDataConnect _dataConnect;
  CreateLocationNodeVariablesBuilder(this._dataConnect, {required  this.cityId,required  this.label,required  this.lat,required  this.lng,required  this.isMain,});
  Deserializer<CreateLocationNodeData> dataDeserializer = (dynamic json)  => CreateLocationNodeData.fromJson(jsonDecode(json));
  Serializer<CreateLocationNodeVariables> varsSerializer = (CreateLocationNodeVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateLocationNodeData, CreateLocationNodeVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateLocationNodeData, CreateLocationNodeVariables> ref() {
    CreateLocationNodeVariables vars= CreateLocationNodeVariables(cityId: cityId,label: label,lat: lat,lng: lng,isMain: isMain,);
    return _dataConnect.mutation("CreateLocationNode", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateLocationNodeLocationNodeInsert {
  final String id;
  CreateLocationNodeLocationNodeInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLocationNodeLocationNodeInsert otherTyped = other as CreateLocationNodeLocationNodeInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateLocationNodeLocationNodeInsert({
    required this.id,
  });
}

@immutable
class CreateLocationNodeData {
  final CreateLocationNodeLocationNodeInsert locationNode_insert;
  CreateLocationNodeData.fromJson(dynamic json):
  
  locationNode_insert = CreateLocationNodeLocationNodeInsert.fromJson(json['locationNode_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLocationNodeData otherTyped = other as CreateLocationNodeData;
    return locationNode_insert == otherTyped.locationNode_insert;
    
  }
  @override
  int get hashCode => locationNode_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['locationNode_insert'] = locationNode_insert.toJson();
    return json;
  }

  CreateLocationNodeData({
    required this.locationNode_insert,
  });
}

@immutable
class CreateLocationNodeVariables {
  final String cityId;
  final String label;
  final double lat;
  final double lng;
  final bool isMain;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateLocationNodeVariables.fromJson(Map<String, dynamic> json):
  
  cityId = nativeFromJson<String>(json['cityId']),
  label = nativeFromJson<String>(json['label']),
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

    final CreateLocationNodeVariables otherTyped = other as CreateLocationNodeVariables;
    return cityId == otherTyped.cityId && 
    label == otherTyped.label && 
    lat == otherTyped.lat && 
    lng == otherTyped.lng && 
    isMain == otherTyped.isMain;
    
  }
  @override
  int get hashCode => Object.hashAll([cityId.hashCode, label.hashCode, lat.hashCode, lng.hashCode, isMain.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cityId'] = nativeToJson<String>(cityId);
    json['label'] = nativeToJson<String>(label);
    json['lat'] = nativeToJson<double>(lat);
    json['lng'] = nativeToJson<double>(lng);
    json['isMain'] = nativeToJson<bool>(isMain);
    return json;
  }

  CreateLocationNodeVariables({
    required this.cityId,
    required this.label,
    required this.lat,
    required this.lng,
    required this.isMain,
  });
}

