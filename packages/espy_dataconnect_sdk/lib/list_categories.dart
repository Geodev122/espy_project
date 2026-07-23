part of 'espy.dart';

class ListCategoriesVariablesBuilder {
  Optional<String> _sectorId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListCategoriesVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }

  ListCategoriesVariablesBuilder(this._dataConnect, );
  Deserializer<ListCategoriesData> dataDeserializer = (dynamic json)  => ListCategoriesData.fromJson(jsonDecode(json));
  Serializer<ListCategoriesVariables> varsSerializer = (ListCategoriesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListCategoriesData, ListCategoriesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListCategoriesData, ListCategoriesVariables> ref() {
    ListCategoriesVariables vars= ListCategoriesVariables(sectorId: _sectorId,);
    return _dataConnect.query("ListCategories", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListCategoriesCategories {
  final String id;
  final String nameEn;
  final String? nameAr;
  final EnumValue<UserRole> targetRole;
  final ListCategoriesCategoriesTemplate? template;
  ListCategoriesCategories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  targetRole = userRoleDeserializer(json['targetRole']),
  template = json['template'] == null ? null : ListCategoriesCategoriesTemplate.fromJson(json['template']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCategoriesCategories otherTyped = other as ListCategoriesCategories;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    targetRole == otherTyped.targetRole && 
    template == otherTyped.template;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, targetRole.hashCode, template.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    json['targetRole'] = 
    userRoleSerializer(targetRole)
    ;
    if (template != null) {
      json['template'] = template!.toJson();
    }
    return json;
  }

  ListCategoriesCategories({
    required this.id,
    required this.nameEn,
    this.nameAr,
    required this.targetRole,
    this.template,
  });
}

@immutable
class ListCategoriesCategoriesTemplate {
  final String? accentColor;
  final String? iconName;
  final List<String>? visibleFields;
  ListCategoriesCategoriesTemplate.fromJson(dynamic json):
  
  accentColor = json['accentColor'] == null ? null : nativeFromJson<String>(json['accentColor']),
  iconName = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']),
  visibleFields = json['visibleFields'] == null ? null : (json['visibleFields'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCategoriesCategoriesTemplate otherTyped = other as ListCategoriesCategoriesTemplate;
    return accentColor == otherTyped.accentColor && 
    iconName == otherTyped.iconName && 
    visibleFields == otherTyped.visibleFields;
    
  }
  @override
  int get hashCode => Object.hashAll([accentColor.hashCode, iconName.hashCode, visibleFields.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (accentColor != null) {
      json['accentColor'] = nativeToJson<String?>(accentColor);
    }
    if (iconName != null) {
      json['iconName'] = nativeToJson<String?>(iconName);
    }
    if (visibleFields != null) {
      json['visibleFields'] = visibleFields?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  ListCategoriesCategoriesTemplate({
    this.accentColor,
    this.iconName,
    this.visibleFields,
  });
}

@immutable
class ListCategoriesData {
  final List<ListCategoriesCategories> categories;
  ListCategoriesData.fromJson(dynamic json):
  
  categories = (json['categories'] as List<dynamic>)
        .map((e) => ListCategoriesCategories.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCategoriesData otherTyped = other as ListCategoriesData;
    return categories == otherTyped.categories;
    
  }
  @override
  int get hashCode => categories.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['categories'] = categories.map((e) => e.toJson()).toList();
    return json;
  }

  ListCategoriesData({
    required this.categories,
  });
}

@immutable
class ListCategoriesVariables {
  late final Optional<String>sectorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListCategoriesVariables.fromJson(Map<String, dynamic> json) {
  
  
    sectorId = Optional.optional(nativeFromJson, nativeToJson);
    sectorId.value = json['sectorId'] == null ? null : nativeFromJson<String>(json['sectorId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCategoriesVariables otherTyped = other as ListCategoriesVariables;
    return sectorId == otherTyped.sectorId;
    
  }
  @override
  int get hashCode => sectorId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(sectorId.state == OptionalState.set) {
      json['sectorId'] = sectorId.toJson();
    }
    return json;
  }

  ListCategoriesVariables({
    required this.sectorId,
  });
}

