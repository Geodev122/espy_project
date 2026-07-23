part of 'espy.dart';

class ListMetadataTagsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListMetadataTagsVariablesBuilder(this._dataConnect, );
  Deserializer<ListMetadataTagsData> dataDeserializer = (dynamic json)  => ListMetadataTagsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListMetadataTagsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListMetadataTagsData, void> ref() {
    
    return _dataConnect.query("ListMetadataTags", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMetadataTagsServiceTags {
  final String id;
  final String nameEn;
  final String? nameAr;
  ListMetadataTagsServiceTags.fromJson(dynamic json):
  
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

    final ListMetadataTagsServiceTags otherTyped = other as ListMetadataTagsServiceTags;
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

  ListMetadataTagsServiceTags({
    required this.id,
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListMetadataTagsPriceTags {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? category;
  ListMetadataTagsPriceTags.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  category = json['category'] == null ? null : nativeFromJson<String>(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMetadataTagsPriceTags otherTyped = other as ListMetadataTagsPriceTags;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, category.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (category != null) {
      json['category'] = nativeToJson<String?>(category);
    }
    return json;
  }

  ListMetadataTagsPriceTags({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.category,
  });
}

@immutable
class ListMetadataTagsPinCategories {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? iconBase;
  ListMetadataTagsPinCategories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  iconBase = json['iconBase'] == null ? null : nativeFromJson<String>(json['iconBase']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMetadataTagsPinCategories otherTyped = other as ListMetadataTagsPinCategories;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    iconBase == otherTyped.iconBase;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, iconBase.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (iconBase != null) {
      json['iconBase'] = nativeToJson<String?>(iconBase);
    }
    return json;
  }

  ListMetadataTagsPinCategories({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.iconBase,
  });
}

@immutable
class ListMetadataTagsPresenceTags {
  final String id;
  final String nameEn;
  final String? nameAr;
  ListMetadataTagsPresenceTags.fromJson(dynamic json):
  
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

    final ListMetadataTagsPresenceTags otherTyped = other as ListMetadataTagsPresenceTags;
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

  ListMetadataTagsPresenceTags({
    required this.id,
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListMetadataTagsData {
  final List<ListMetadataTagsServiceTags> serviceTags;
  final List<ListMetadataTagsPriceTags> priceTags;
  final List<ListMetadataTagsPinCategories> pinCategories;
  final List<ListMetadataTagsPresenceTags> presenceTags;
  ListMetadataTagsData.fromJson(dynamic json):
  
  serviceTags = (json['serviceTags'] as List<dynamic>)
        .map((e) => ListMetadataTagsServiceTags.fromJson(e))
        .toList(),
  priceTags = (json['priceTags'] as List<dynamic>)
        .map((e) => ListMetadataTagsPriceTags.fromJson(e))
        .toList(),
  pinCategories = (json['pinCategories'] as List<dynamic>)
        .map((e) => ListMetadataTagsPinCategories.fromJson(e))
        .toList(),
  presenceTags = (json['presenceTags'] as List<dynamic>)
        .map((e) => ListMetadataTagsPresenceTags.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMetadataTagsData otherTyped = other as ListMetadataTagsData;
    return serviceTags == otherTyped.serviceTags && 
    priceTags == otherTyped.priceTags && 
    pinCategories == otherTyped.pinCategories && 
    presenceTags == otherTyped.presenceTags;
    
  }
  @override
  int get hashCode => Object.hashAll([serviceTags.hashCode, priceTags.hashCode, pinCategories.hashCode, presenceTags.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceTags'] = serviceTags.map((e) => e.toJson()).toList();
    json['priceTags'] = priceTags.map((e) => e.toJson()).toList();
    json['pinCategories'] = pinCategories.map((e) => e.toJson()).toList();
    json['presenceTags'] = presenceTags.map((e) => e.toJson()).toList();
    return json;
  }

  ListMetadataTagsData({
    required this.serviceTags,
    required this.priceTags,
    required this.pinCategories,
    required this.presenceTags,
  });
}

