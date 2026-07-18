part of 'espy.dart';

class CreateServiceVariablesBuilder {
  String categoryId;
  String titleEn;
  int price;

  final FirebaseDataConnect _dataConnect;
  CreateServiceVariablesBuilder(this._dataConnect, {required  this.categoryId,required  this.titleEn,required  this.price,});
  Deserializer<CreateServiceData> dataDeserializer = (dynamic json)  => CreateServiceData.fromJson(jsonDecode(json));
  Serializer<CreateServiceVariables> varsSerializer = (CreateServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateServiceData, CreateServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateServiceData, CreateServiceVariables> ref() {
    CreateServiceVariables vars= CreateServiceVariables(categoryId: categoryId,titleEn: titleEn,price: price,);
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
  final String titleEn;
  final int price;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateServiceVariables.fromJson(Map<String, dynamic> json):
  
  categoryId = nativeFromJson<String>(json['categoryId']),
  titleEn = nativeFromJson<String>(json['titleEn']),
  price = nativeFromJson<int>(json['price']);
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
    titleEn == otherTyped.titleEn && 
    price == otherTyped.price;
    
  }
  @override
  int get hashCode => Object.hashAll([categoryId.hashCode, titleEn.hashCode, price.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['categoryId'] = nativeToJson<String>(categoryId);
    json['titleEn'] = nativeToJson<String>(titleEn);
    json['price'] = nativeToJson<int>(price);
    return json;
  }

  CreateServiceVariables({
    required this.categoryId,
    required this.titleEn,
    required this.price,
  });
}

