part of 'espy.dart';

class CreateServiceVariablesBuilder {
  String categoryId;
  String sectorId;
  String titleEn;
  int price;
  Optional<String> _priceTagId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateServiceVariablesBuilder priceTagId(String? t) {
   _priceTagId.value = t;
   return this;
  }

  CreateServiceVariablesBuilder(this._dataConnect, {required  this.categoryId,required  this.sectorId,required  this.titleEn,required  this.price,});
  Deserializer<CreateServiceData> dataDeserializer = (dynamic json)  => CreateServiceData.fromJson(jsonDecode(json));
  Serializer<CreateServiceVariables> varsSerializer = (CreateServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateServiceData, CreateServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateServiceData, CreateServiceVariables> ref() {
    CreateServiceVariables vars= CreateServiceVariables(categoryId: categoryId,sectorId: sectorId,titleEn: titleEn,price: price,priceTagId: _priceTagId,);
    return _dataConnect.mutation("CreateService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateServiceServiceInsert {
  final String id;
  CreateServiceServiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateServiceServiceInsert otherTyped = other as CreateServiceServiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateServiceServiceInsert({
    required this.id,
  });
}

@immutable
class CreateServiceData {
  final CreateServiceServiceInsert service_insert;
  CreateServiceData.fromJson(dynamic json):
  
  service_insert = CreateServiceServiceInsert.fromJson(json['service_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateServiceData otherTyped = other as CreateServiceData;
    return service_insert == otherTyped.service_insert;
    
  }
  @override
  int get hashCode => service_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['service_insert'] = service_insert.toJson();
    return json;
  }

  CreateServiceData({
    required this.service_insert,
  });
}

@immutable
class CreateServiceVariables {
  final String categoryId;
  final String sectorId;
  final String titleEn;
  final int price;
  late final Optional<String>priceTagId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateServiceVariables.fromJson(Map<String, dynamic> json):
  
  categoryId = nativeFromJson<String>(json['categoryId']),
  sectorId = nativeFromJson<String>(json['sectorId']),
  titleEn = nativeFromJson<String>(json['titleEn']),
  price = nativeFromJson<int>(json['price']) {
  
  
  
  
  
  
    priceTagId = Optional.optional(nativeFromJson, nativeToJson);
    priceTagId.value = json['priceTagId'] == null ? null : nativeFromJson<String>(json['priceTagId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateServiceVariables otherTyped = other as CreateServiceVariables;
    return categoryId == otherTyped.categoryId && 
    sectorId == otherTyped.sectorId && 
    titleEn == otherTyped.titleEn && 
    price == otherTyped.price && 
    priceTagId == otherTyped.priceTagId;
    
  }
  @override
  int get hashCode => Object.hashAll([categoryId.hashCode, sectorId.hashCode, titleEn.hashCode, price.hashCode, priceTagId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['categoryId'] = nativeToJson<String>(categoryId);
    json['sectorId'] = nativeToJson<String>(sectorId);
    json['titleEn'] = nativeToJson<String>(titleEn);
    json['price'] = nativeToJson<int>(price);
    if(priceTagId.state == OptionalState.set) {
      json['priceTagId'] = priceTagId.toJson();
    }
    return json;
  }

  CreateServiceVariables({
    required this.categoryId,
    required this.sectorId,
    required this.titleEn,
    required this.price,
    required this.priceTagId,
  });
}

