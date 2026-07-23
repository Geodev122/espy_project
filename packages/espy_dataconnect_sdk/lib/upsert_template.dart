part of 'espy.dart';

class UpsertTemplateVariablesBuilder {
  String id;
  Optional<List<String>> _visibleFields = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
  Optional<String> _configJson = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertTemplateVariablesBuilder visibleFields(List<String>? t) {
   _visibleFields.value = t;
   return this;
  }
  UpsertTemplateVariablesBuilder configJson(String? t) {
   _configJson.value = t;
   return this;
  }

  UpsertTemplateVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpsertTemplateData> dataDeserializer = (dynamic json)  => UpsertTemplateData.fromJson(jsonDecode(json));
  Serializer<UpsertTemplateVariables> varsSerializer = (UpsertTemplateVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertTemplateData, UpsertTemplateVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertTemplateData, UpsertTemplateVariables> ref() {
    UpsertTemplateVariables vars= UpsertTemplateVariables(id: id,visibleFields: _visibleFields,configJson: _configJson,);
    return _dataConnect.mutation("UpsertTemplate", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertTemplateTemplateUpsert {
  final String id;
  UpsertTemplateTemplateUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTemplateTemplateUpsert otherTyped = other as UpsertTemplateTemplateUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertTemplateTemplateUpsert({
    required this.id,
  });
}

@immutable
class UpsertTemplateData {
  final UpsertTemplateTemplateUpsert template_upsert;
  UpsertTemplateData.fromJson(dynamic json):
  
  template_upsert = UpsertTemplateTemplateUpsert.fromJson(json['template_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTemplateData otherTyped = other as UpsertTemplateData;
    return template_upsert == otherTyped.template_upsert;
    
  }
  @override
  int get hashCode => template_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['template_upsert'] = template_upsert.toJson();
    return json;
  }

  UpsertTemplateData({
    required this.template_upsert,
  });
}

@immutable
class UpsertTemplateVariables {
  final String id;
  late final Optional<List<String>>visibleFields;
  late final Optional<String>configJson;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertTemplateVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    visibleFields = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
    visibleFields.value = json['visibleFields'] == null ? null : (json['visibleFields'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  
  
    configJson = Optional.optional(nativeFromJson, nativeToJson);
    configJson.value = json['configJson'] == null ? null : nativeFromJson<String>(json['configJson']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTemplateVariables otherTyped = other as UpsertTemplateVariables;
    return id == otherTyped.id && 
    visibleFields == otherTyped.visibleFields && 
    configJson == otherTyped.configJson;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, visibleFields.hashCode, configJson.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(visibleFields.state == OptionalState.set) {
      json['visibleFields'] = visibleFields.toJson();
    }
    if(configJson.state == OptionalState.set) {
      json['configJson'] = configJson.toJson();
    }
    return json;
  }

  UpsertTemplateVariables({
    required this.id,
    required this.visibleFields,
    required this.configJson,
  });
}

