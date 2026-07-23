part of 'espy.dart';

class ToggleUserActiveStatusVariablesBuilder {
  String id;
  bool isActive;

  final FirebaseDataConnect _dataConnect;
  ToggleUserActiveStatusVariablesBuilder(this._dataConnect, {required  this.id,required  this.isActive,});
  Deserializer<ToggleUserActiveStatusData> dataDeserializer = (dynamic json)  => ToggleUserActiveStatusData.fromJson(jsonDecode(json));
  Serializer<ToggleUserActiveStatusVariables> varsSerializer = (ToggleUserActiveStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ToggleUserActiveStatusData, ToggleUserActiveStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ToggleUserActiveStatusData, ToggleUserActiveStatusVariables> ref() {
    ToggleUserActiveStatusVariables vars= ToggleUserActiveStatusVariables(id: id,isActive: isActive,);
    return _dataConnect.mutation("ToggleUserActiveStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ToggleUserActiveStatusUserUpdate {
  final String id;
  ToggleUserActiveStatusUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleUserActiveStatusUserUpdate otherTyped = other as ToggleUserActiveStatusUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ToggleUserActiveStatusUserUpdate({
    required this.id,
  });
}

@immutable
class ToggleUserActiveStatusData {
  final ToggleUserActiveStatusUserUpdate? user_update;
  ToggleUserActiveStatusData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : ToggleUserActiveStatusUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleUserActiveStatusData otherTyped = other as ToggleUserActiveStatusData;
    return user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => user_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  ToggleUserActiveStatusData({
    this.user_update,
  });
}

@immutable
class ToggleUserActiveStatusVariables {
  final String id;
  final bool isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ToggleUserActiveStatusVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  isActive = nativeFromJson<bool>(json['isActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleUserActiveStatusVariables otherTyped = other as ToggleUserActiveStatusVariables;
    return id == otherTyped.id && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['isActive'] = nativeToJson<bool>(isActive);
    return json;
  }

  ToggleUserActiveStatusVariables({
    required this.id,
    required this.isActive,
  });
}

