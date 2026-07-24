part of 'espy.dart';

class UpdateAppConfigVariablesBuilder {
  String key;
  String value;

  final FirebaseDataConnect _dataConnect;
  UpdateAppConfigVariablesBuilder(this._dataConnect, {required  this.key,required  this.value,});
  Deserializer<UpdateAppConfigData> dataDeserializer = (dynamic json)  => UpdateAppConfigData.fromJson(jsonDecode(json));
  Serializer<UpdateAppConfigVariables> varsSerializer = (UpdateAppConfigVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateAppConfigData, UpdateAppConfigVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateAppConfigData, UpdateAppConfigVariables> ref() {
    UpdateAppConfigVariables vars= UpdateAppConfigVariables(key: key,value: value,);
    return _dataConnect.mutation("UpdateAppConfig", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateAppConfigAppConfigUpsert {
  final String key;
  UpdateAppConfigAppConfigUpsert.fromJson(dynamic json):
  
  key = nativeFromJson<String>(json['key']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAppConfigAppConfigUpsert otherTyped = other as UpdateAppConfigAppConfigUpsert;
    return key == otherTyped.key;
    
  }
  @override
  int get hashCode => key.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['key'] = nativeToJson<String>(key);
    return json;
  }

  UpdateAppConfigAppConfigUpsert({
    required this.key,
  });
}

@immutable
class UpdateAppConfigData {
  final UpdateAppConfigAppConfigUpsert appConfig_upsert;
  UpdateAppConfigData.fromJson(dynamic json):
  
  appConfig_upsert = UpdateAppConfigAppConfigUpsert.fromJson(json['appConfig_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAppConfigData otherTyped = other as UpdateAppConfigData;
    return appConfig_upsert == otherTyped.appConfig_upsert;
    
  }
  @override
  int get hashCode => appConfig_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['appConfig_upsert'] = appConfig_upsert.toJson();
    return json;
  }

  UpdateAppConfigData({
    required this.appConfig_upsert,
  });
}

@immutable
class UpdateAppConfigVariables {
  final String key;
  final String value;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateAppConfigVariables.fromJson(Map<String, dynamic> json):
  
  key = nativeFromJson<String>(json['key']),
  value = nativeFromJson<String>(json['value']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAppConfigVariables otherTyped = other as UpdateAppConfigVariables;
    return key == otherTyped.key && 
    value == otherTyped.value;
    
  }
  @override
  int get hashCode => Object.hashAll([key.hashCode, value.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['key'] = nativeToJson<String>(key);
    json['value'] = nativeToJson<String>(value);
    return json;
  }

  UpdateAppConfigVariables({
    required this.key,
    required this.value,
  });
}

