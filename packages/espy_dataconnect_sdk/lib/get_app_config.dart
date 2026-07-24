part of 'espy.dart';

class GetAppConfigVariablesBuilder {
  String key;

  final FirebaseDataConnect _dataConnect;
  GetAppConfigVariablesBuilder(this._dataConnect, {required  this.key,});
  Deserializer<GetAppConfigData> dataDeserializer = (dynamic json)  => GetAppConfigData.fromJson(jsonDecode(json));
  Serializer<GetAppConfigVariables> varsSerializer = (GetAppConfigVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAppConfigData, GetAppConfigVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetAppConfigData, GetAppConfigVariables> ref() {
    GetAppConfigVariables vars= GetAppConfigVariables(key: key,);
    return _dataConnect.query("GetAppConfig", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAppConfigAppConfig {
  final String key;
  final String value;
  GetAppConfigAppConfig.fromJson(dynamic json):
  
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

    final GetAppConfigAppConfig otherTyped = other as GetAppConfigAppConfig;
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

  GetAppConfigAppConfig({
    required this.key,
    required this.value,
  });
}

@immutable
class GetAppConfigData {
  final GetAppConfigAppConfig? appConfig;
  GetAppConfigData.fromJson(dynamic json):
  
  appConfig = json['appConfig'] == null ? null : GetAppConfigAppConfig.fromJson(json['appConfig']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAppConfigData otherTyped = other as GetAppConfigData;
    return appConfig == otherTyped.appConfig;
    
  }
  @override
  int get hashCode => appConfig.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (appConfig != null) {
      json['appConfig'] = appConfig!.toJson();
    }
    return json;
  }

  GetAppConfigData({
    this.appConfig,
  });
}

@immutable
class GetAppConfigVariables {
  final String key;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAppConfigVariables.fromJson(Map<String, dynamic> json):
  
  key = nativeFromJson<String>(json['key']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAppConfigVariables otherTyped = other as GetAppConfigVariables;
    return key == otherTyped.key;
    
  }
  @override
  int get hashCode => key.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['key'] = nativeToJson<String>(key);
    return json;
  }

  GetAppConfigVariables({
    required this.key,
  });
}

