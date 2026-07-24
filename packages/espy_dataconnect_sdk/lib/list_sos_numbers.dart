part of 'espy.dart';

class ListSosNumbersVariablesBuilder {
  Optional<String> _countryId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _sectorId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _categoryId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListSosNumbersVariablesBuilder countryId(String? t) {
   _countryId.value = t;
   return this;
  }
  ListSosNumbersVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  ListSosNumbersVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }

  ListSosNumbersVariablesBuilder(this._dataConnect, );
  Deserializer<ListSosNumbersData> dataDeserializer = (dynamic json)  => ListSosNumbersData.fromJson(jsonDecode(json));
  Serializer<ListSosNumbersVariables> varsSerializer = (ListSosNumbersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListSosNumbersData, ListSosNumbersVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListSosNumbersData, ListSosNumbersVariables> ref() {
    ListSosNumbersVariables vars= ListSosNumbersVariables(countryId: _countryId,sectorId: _sectorId,categoryId: _categoryId,);
    return _dataConnect.query("ListSosNumbers", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListSosNumbersSosNumbers {
  final String id;
  final String labelEn;
  final String? labelAr;
  final String number;
  final ListSosNumbersSosNumbersCountry country;
  final ListSosNumbersSosNumbersSector? sector;
  final ListSosNumbersSosNumbersCategory? category;
  ListSosNumbersSosNumbers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  labelEn = nativeFromJson<String>(json['labelEn']),
  labelAr = json['labelAr'] == null ? null : nativeFromJson<String>(json['labelAr']),
  number = nativeFromJson<String>(json['number']),
  country = ListSosNumbersSosNumbersCountry.fromJson(json['country']),
  sector = json['sector'] == null ? null : ListSosNumbersSosNumbersSector.fromJson(json['sector']),
  category = json['category'] == null ? null : ListSosNumbersSosNumbersCategory.fromJson(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSosNumbersSosNumbers otherTyped = other as ListSosNumbersSosNumbers;
    return id == otherTyped.id && 
    labelEn == otherTyped.labelEn && 
    labelAr == otherTyped.labelAr && 
    number == otherTyped.number && 
    country == otherTyped.country && 
    sector == otherTyped.sector && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, labelEn.hashCode, labelAr.hashCode, number.hashCode, country.hashCode, sector.hashCode, category.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['labelEn'] = nativeToJson<String>(labelEn);
    if (labelAr != null) {
      json['labelAr'] = nativeToJson<String?>(labelAr);
    }
    json['number'] = nativeToJson<String>(number);
    json['country'] = country.toJson();
    if (sector != null) {
      json['sector'] = sector!.toJson();
    }
    if (category != null) {
      json['category'] = category!.toJson();
    }
    return json;
  }

  ListSosNumbersSosNumbers({
    required this.id,
    required this.labelEn,
    this.labelAr,
    required this.number,
    required this.country,
    this.sector,
    this.category,
  });
}

@immutable
class ListSosNumbersSosNumbersCountry {
  final String id;
  ListSosNumbersSosNumbersCountry.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSosNumbersSosNumbersCountry otherTyped = other as ListSosNumbersSosNumbersCountry;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListSosNumbersSosNumbersCountry({
    required this.id,
  });
}

@immutable
class ListSosNumbersSosNumbersSector {
  final String id;
  ListSosNumbersSosNumbersSector.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSosNumbersSosNumbersSector otherTyped = other as ListSosNumbersSosNumbersSector;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListSosNumbersSosNumbersSector({
    required this.id,
  });
}

@immutable
class ListSosNumbersSosNumbersCategory {
  final String id;
  ListSosNumbersSosNumbersCategory.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSosNumbersSosNumbersCategory otherTyped = other as ListSosNumbersSosNumbersCategory;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListSosNumbersSosNumbersCategory({
    required this.id,
  });
}

@immutable
class ListSosNumbersData {
  final List<ListSosNumbersSosNumbers> sosNumbers;
  ListSosNumbersData.fromJson(dynamic json):
  
  sosNumbers = (json['sosNumbers'] as List<dynamic>)
        .map((e) => ListSosNumbersSosNumbers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSosNumbersData otherTyped = other as ListSosNumbersData;
    return sosNumbers == otherTyped.sosNumbers;
    
  }
  @override
  int get hashCode => sosNumbers.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sosNumbers'] = sosNumbers.map((e) => e.toJson()).toList();
    return json;
  }

  ListSosNumbersData({
    required this.sosNumbers,
  });
}

@immutable
class ListSosNumbersVariables {
  late final Optional<String>countryId;
  late final Optional<String>sectorId;
  late final Optional<String>categoryId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListSosNumbersVariables.fromJson(Map<String, dynamic> json) {
  
  
    countryId = Optional.optional(nativeFromJson, nativeToJson);
    countryId.value = json['countryId'] == null ? null : nativeFromJson<String>(json['countryId']);
  
  
    sectorId = Optional.optional(nativeFromJson, nativeToJson);
    sectorId.value = json['sectorId'] == null ? null : nativeFromJson<String>(json['sectorId']);
  
  
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null ? null : nativeFromJson<String>(json['categoryId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSosNumbersVariables otherTyped = other as ListSosNumbersVariables;
    return countryId == otherTyped.countryId && 
    sectorId == otherTyped.sectorId && 
    categoryId == otherTyped.categoryId;
    
  }
  @override
  int get hashCode => Object.hashAll([countryId.hashCode, sectorId.hashCode, categoryId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(countryId.state == OptionalState.set) {
      json['countryId'] = countryId.toJson();
    }
    if(sectorId.state == OptionalState.set) {
      json['sectorId'] = sectorId.toJson();
    }
    if(categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    return json;
  }

  ListSosNumbersVariables({
    required this.countryId,
    required this.sectorId,
    required this.categoryId,
  });
}

