part of 'espy.dart';

class UpdateUserLastActiveVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  UpdateUserLastActiveVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateUserLastActiveData> dataDeserializer = (dynamic json)  => UpdateUserLastActiveData.fromJson(jsonDecode(json));
  Serializer<UpdateUserLastActiveVariables> varsSerializer = (UpdateUserLastActiveVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserLastActiveData, UpdateUserLastActiveVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserLastActiveData, UpdateUserLastActiveVariables> ref() {
    UpdateUserLastActiveVariables vars= UpdateUserLastActiveVariables(id: id,);
    return _dataConnect.mutation("UpdateUserLastActive", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateUserLastActiveUserUpdate {
  final String id;
  UpdateUserLastActiveUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserLastActiveUserUpdate otherTyped = other as UpdateUserLastActiveUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateUserLastActiveUserUpdate({
    required this.id,
  });
}

@immutable
class UpdateUserLastActiveData {
  final UpdateUserLastActiveUserUpdate? user_update;
  UpdateUserLastActiveData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : UpdateUserLastActiveUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserLastActiveData otherTyped = other as UpdateUserLastActiveData;
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

  UpdateUserLastActiveData({
    this.user_update,
  });
}

@immutable
class UpdateUserLastActiveVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateUserLastActiveVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserLastActiveVariables otherTyped = other as UpdateUserLastActiveVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateUserLastActiveVariables({
    required this.id,
  });
}

