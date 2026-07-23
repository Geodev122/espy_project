part of 'espy.dart';

class UpsertPriceTagVariablesBuilder {
  String id;
  String nameEn;
  String nameAr;
  Optional<String> _category = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertPriceTagVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }

  UpsertPriceTagVariablesBuilder(this._dataConnect, {required  this.id,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertPriceTagData> dataDeserializer = (dynamic json)  => UpsertPriceTagData.fromJson(jsonDecode(json));
  Serializer<UpsertPriceTagVariables> varsSerializer = (UpsertPriceTagVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertPriceTagData, UpsertPriceTagVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertPriceTagData, UpsertPriceTagVariables> ref() {
    UpsertPriceTagVariables vars= UpsertPriceTagVariables(id: id,nameEn: nameEn,nameAr: nameAr,category: _category,);
    return _dataConnect.mutation("UpsertPriceTag", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertPriceTagPriceTagUpsert {
  final String id;
  UpsertPriceTagPriceTagUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPriceTagPriceTagUpsert otherTyped = other as UpsertPriceTagPriceTagUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertPriceTagPriceTagUpsert({
    required this.id,
  });
}

@immutable
class UpsertPriceTagData {
  final UpsertPriceTagPriceTagUpsert priceTag_upsert;
  UpsertPriceTagData.fromJson(dynamic json):
  
  priceTag_upsert = UpsertPriceTagPriceTagUpsert.fromJson(json['priceTag_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPriceTagData otherTyped = other as UpsertPriceTagData;
    return priceTag_upsert == otherTyped.priceTag_upsert;
    
  }
  @override
  int get hashCode => priceTag_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['priceTag_upsert'] = priceTag_upsert.toJson();
    return json;
  }

  UpsertPriceTagData({
    required this.priceTag_upsert,
  });
}

@immutable
class UpsertPriceTagVariables {
  final String id;
  final String nameEn;
  final String nameAr;
  late final Optional<String>category;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertPriceTagVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']) {
  
  
  
  
  
    category = Optional.optional(nativeFromJson, nativeToJson);
    category.value = json['category'] == null ? null : nativeFromJson<String>(json['category']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPriceTagVariables otherTyped = other as UpsertPriceTagVariables;
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
    json['nameAr'] = nativeToJson<String>(nameAr);
    if(category.state == OptionalState.set) {
      json['category'] = category.toJson();
    }
    return json;
  }

  UpsertPriceTagVariables({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.category,
  });
}

