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
  final ListTemplatesTemplatesCategory category;
  ListTemplatesTemplates.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  accentColor = json['accentColor'] == null ? null : nativeFromJson<String>(json['accentColor']),
  iconName = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']),
  visibleFields = json['visibleFields'] == null ? null : (json['visibleFields'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  configJson = json['configJson'] == null ? null : nativeFromJson<String>(json['configJson']),
  category = ListTemplatesTemplatesCategory.fromJson(json['category']);
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
    configJson == otherTyped.configJson && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, accentColor.hashCode, iconName.hashCode, visibleFields.hashCode, configJson.hashCode, category.hashCode]);
  

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
    json['category'] = category.toJson();
    return json;
  }

  ListTemplatesTemplates({
    required this.id,
    this.accentColor,
    this.iconName,
    this.visibleFields,
    this.configJson,
    required this.category,
  });
}

@immutable
class ListTemplatesTemplatesCategory {
  final String id;
  final String nameEn;
  final String? nameAr;
  ListTemplatesTemplatesCategory.fromJson(dynamic json):
  
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

    final ListTemplatesTemplatesCategory otherTyped = other as ListTemplatesTemplatesCategory;
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

  ListTemplatesTemplatesCategory({
    required this.id,
    required this.nameEn,
    this.nameAr,
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

