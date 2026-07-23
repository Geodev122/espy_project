part of 'espy.dart';

class ListSectorsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListSectorsVariablesBuilder(this._dataConnect, );
  Deserializer<ListSectorsData> dataDeserializer = (dynamic json)  => ListSectorsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListSectorsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListSectorsData, void> ref() {
    
    return _dataConnect.query("ListSectors", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListSectorsSectors {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? iconName;
  final String? colorHex;
  final String? description;
  final ListSectorsSectorsTemplate? template;
  ListSectorsSectors.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  iconName = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']),
  colorHex = json['colorHex'] == null ? null : nativeFromJson<String>(json['colorHex']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  template = json['template'] == null ? null : ListSectorsSectorsTemplate.fromJson(json['template']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSectorsSectors otherTyped = other as ListSectorsSectors;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    iconName == otherTyped.iconName && 
    colorHex == otherTyped.colorHex && 
    description == otherTyped.description && 
    template == otherTyped.template;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, iconName.hashCode, colorHex.hashCode, description.hashCode, template.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (iconName != null) {
      json['iconName'] = nativeToJson<String?>(iconName);
    }
    if (colorHex != null) {
      json['colorHex'] = nativeToJson<String?>(colorHex);
    }
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    if (template != null) {
      json['template'] = template!.toJson();
    }
    return json;
  }

  ListSectorsSectors({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.iconName,
    this.colorHex,
    this.description,
    this.template,
  });
}

@immutable
class ListSectorsSectorsTemplate {
  final String? accentColor;
  final String? iconName;
  final List<String>? visibleFields;
  ListSectorsSectorsTemplate.fromJson(dynamic json):
  
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

    final ListSectorsSectorsTemplate otherTyped = other as ListSectorsSectorsTemplate;
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

  ListSectorsSectorsTemplate({
    this.accentColor,
    this.iconName,
    this.visibleFields,
  });
}

@immutable
class ListSectorsData {
  final List<ListSectorsSectors> sectors;
  ListSectorsData.fromJson(dynamic json):
  
  sectors = (json['sectors'] as List<dynamic>)
        .map((e) => ListSectorsSectors.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSectorsData otherTyped = other as ListSectorsData;
    return sectors == otherTyped.sectors;
    
  }
  @override
  int get hashCode => sectors.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sectors'] = sectors.map((e) => e.toJson()).toList();
    return json;
  }

  ListSectorsData({
    required this.sectors,
  });
}

