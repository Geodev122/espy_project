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
  final ListCategoriesCategoriesSector sector;
  ListCategoriesCategories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  targetRole = userRoleDeserializer(json['targetRole']),
  sector = ListCategoriesCategoriesSector.fromJson(json['sector']);
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
    sector == otherTyped.sector;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, targetRole.hashCode, sector.hashCode]);
  

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
    json['sector'] = sector.toJson();
    return json;
  }

  ListCategoriesCategories({
    required this.id,
    required this.nameEn,
    this.nameAr,
    required this.targetRole,
    required this.sector,
  });
}

@immutable
class ListCategoriesCategoriesSector {
  final String id;
  ListCategoriesCategoriesSector.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCategoriesCategoriesSector otherTyped = other as ListCategoriesCategoriesSector;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListCategoriesCategoriesSector({
    required this.id,
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

