part of 'espy.dart';

class ListAppConfigsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListAppConfigsVariablesBuilder(this._dataConnect, );
  Deserializer<ListAppConfigsData> dataDeserializer = (dynamic json)  => ListAppConfigsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListAppConfigsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListAppConfigsData, void> ref() {
    
    return _dataConnect.query("ListAppConfigs", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListAppConfigsAppConfigs {
  final String key;
  final String value;
  ListAppConfigsAppConfigs.fromJson(dynamic json):
  
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

    final ListAppConfigsAppConfigs otherTyped = other as ListAppConfigsAppConfigs;
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

  ListAppConfigsAppConfigs({
    required this.key,
    required this.value,
  });
}

@immutable
class ListAppConfigsData {
  final List<ListAppConfigsAppConfigs> appConfigs;
  ListAppConfigsData.fromJson(dynamic json):
  
  appConfigs = (json['appConfigs'] as List<dynamic>)
        .map((e) => ListAppConfigsAppConfigs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAppConfigsData otherTyped = other as ListAppConfigsData;
    return appConfigs == otherTyped.appConfigs;
    
  }
  @override
  int get hashCode => appConfigs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['appConfigs'] = appConfigs.map((e) => e.toJson()).toList();
    return json;
  }

  ListAppConfigsData({
    required this.appConfigs,
  });
}

