part of 'espy.dart';

class ListTemplatesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListTemplatesVariablesBuilder(this._dataConnect, );
  Deserializer<ListTemplatesData> dataDeserializer = (dynamic json)  => ListTemplatesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListTemplatesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListTemplatesData, void> ref() {
    
    return _dataConnect.query("ListTemplates", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListTemplatesTemplates {
  final String id;
  final String? accentColor;
  final String? iconName;
  final List<String>? visibleFields;
  final String? configJson;
  ListTemplatesTemplates.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  accentColor = json['accentColor'] == null ? null : nativeFromJson<String>(json['accentColor']),
  iconName = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']),
  visibleFields = json['visibleFields'] == null ? null : (json['visibleFields'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  configJson = json['configJson'] == null ? null : nativeFromJson<String>(json['configJson']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTemplatesTemplates otherTyped = other as ListTemplatesTemplates;
    return id == otherTyped.id && 
    accentColor == otherTyped.accentColor && 
    iconName == otherTyped.iconName && 
    visibleFields == otherTyped.visibleFields && 
    configJson == otherTyped.configJson;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, accentColor.hashCode, iconName.hashCode, visibleFields.hashCode, configJson.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (accentColor != null) {
      json['accentColor'] = nativeToJson<String?>(accentColor);
    }
    if (iconName != null) {
      json['iconName'] = nativeToJson<String?>(iconName);
    }
    if (visibleFields != null) {
      json['visibleFields'] = visibleFields?.map((e) => nativeToJson<String>(e)).toList();
    }
    if (configJson != null) {
      json['configJson'] = nativeToJson<String?>(configJson);
    }
    return json;
  }

  ListTemplatesTemplates({
    required this.id,
    this.accentColor,
    this.iconName,
    this.visibleFields,
    this.configJson,
  });
}

@immutable
class ListTemplatesData {
  final List<ListTemplatesTemplates> templates;
  ListTemplatesData.fromJson(dynamic json):
  
  templates = (json['templates'] as List<dynamic>)
        .map((e) => ListTemplatesTemplates.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTemplatesData otherTyped = other as ListTemplatesData;
    return templates == otherTyped.templates;
    
  }
  @override
  int get hashCode => templates.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['templates'] = templates.map((e) => e.toJson()).toList();
    return json;
  }

  ListTemplatesData({
    required this.templates,
  });
}

