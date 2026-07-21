part of 'espy.dart';

class UpdateCategoryVariablesBuilder {
  String id;
  Optional<String> _nameEn = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateCategoryVariablesBuilder nameEn(String? t) {
   _nameEn.value = t;
   return this;
  }

  UpdateCategoryVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateCategoryData> dataDeserializer = (dynamic json)  => UpdateCategoryData.fromJson(jsonDecode(json));
  Serializer<UpdateCategoryVariables> varsSerializer = (UpdateCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateCategoryData, UpdateCategoryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateCategoryData, UpdateCategoryVariables> ref() {
    UpdateCategoryVariables vars= UpdateCategoryVariables(id: id,nameEn: _nameEn,);
    return _dataConnect.mutation("UpdateCategory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateCategoryCategoryUpdate {
  final String id;
  UpdateCategoryCategoryUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryCategoryUpdate otherTyped = other as UpdateCategoryCategoryUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCategoryCategoryUpdate({
    required this.id,
  });
}

@immutable
class UpdateCategoryData {
  final UpdateCategoryCategoryUpdate? category_update;
  UpdateCategoryData.fromJson(dynamic json):
  
  category_update = json['category_update'] == null ? null : UpdateCategoryCategoryUpdate.fromJson(json['category_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryData otherTyped = other as UpdateCategoryData;
    return category_update == otherTyped.category_update;
    
  }
  @override
  int get hashCode => category_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (category_update != null) {
      json['category_update'] = category_update!.toJson();
    }
    return json;
  }

  UpdateCategoryData({
    this.category_update,
  });
}

@immutable
class UpdateCategoryVariables {
  final String id;
  late final Optional<String>nameEn;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateCategoryVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    nameEn = Optional.optional(nativeFromJson, nativeToJson);
    nameEn.value = json['nameEn'] == null ? null : nativeFromJson<String>(json['nameEn']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryVariables otherTyped = other as UpdateCategoryVariables;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(nameEn.state == OptionalState.set) {
      json['nameEn'] = nameEn.toJson();
    }
    return json;
  }

  UpdateCategoryVariables({
    required this.id,
    required this.nameEn,
  });
}

