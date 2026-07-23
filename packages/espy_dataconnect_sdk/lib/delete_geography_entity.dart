part of 'espy.dart';

class DeleteGeographyEntityVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteGeographyEntityVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteGeographyEntityData> dataDeserializer = (dynamic json)  => DeleteGeographyEntityData.fromJson(jsonDecode(json));
  Serializer<DeleteGeographyEntityVariables> varsSerializer = (DeleteGeographyEntityVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteGeographyEntityData, DeleteGeographyEntityVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteGeographyEntityData, DeleteGeographyEntityVariables> ref() {
    DeleteGeographyEntityVariables vars= DeleteGeographyEntityVariables(id: id,);
    return _dataConnect.mutation("DeleteGeographyEntity", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteGeographyEntityCountryDelete {
  final String id;
  DeleteGeographyEntityCountryDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteGeographyEntityCountryDelete otherTyped = other as DeleteGeographyEntityCountryDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteGeographyEntityCountryDelete({
    required this.id,
  });
}

@immutable
class DeleteGeographyEntityData {
  final DeleteGeographyEntityCountryDelete? country_delete;
  DeleteGeographyEntityData.fromJson(dynamic json):
  
  country_delete = json['country_delete'] == null ? null : DeleteGeographyEntityCountryDelete.fromJson(json['country_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteGeographyEntityData otherTyped = other as DeleteGeographyEntityData;
    return country_delete == otherTyped.country_delete;
    
  }
  @override
  int get hashCode => country_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (country_delete != null) {
      json['country_delete'] = country_delete!.toJson();
    }
    return json;
  }

  DeleteGeographyEntityData({
    this.country_delete,
  });
}

@immutable
class DeleteGeographyEntityVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteGeographyEntityVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteGeographyEntityVariables otherTyped = other as DeleteGeographyEntityVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteGeographyEntityVariables({
    required this.id,
  });
}

