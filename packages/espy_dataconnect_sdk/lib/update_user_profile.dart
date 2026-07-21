part of 'espy.dart';

class UpdateUserProfileVariablesBuilder {
  String id;
  Optional<String> _name = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _photoUrl = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _phone = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _whatsapp = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateUserProfileVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder phone(String? t) {
   _phone.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder whatsapp(String? t) {
   _whatsapp.value = t;
   return this;
  }

  UpdateUserProfileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateUserProfileData> dataDeserializer = (dynamic json)  => UpdateUserProfileData.fromJson(jsonDecode(json));
  Serializer<UpdateUserProfileVariables> varsSerializer = (UpdateUserProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserProfileData, UpdateUserProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserProfileData, UpdateUserProfileVariables> ref() {
    UpdateUserProfileVariables vars= UpdateUserProfileVariables(id: id,name: _name,photoUrl: _photoUrl,phone: _phone,whatsapp: _whatsapp,);
    return _dataConnect.mutation("UpdateUserProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateUserProfileUserUpdate {
  final String id;
  UpdateUserProfileUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserProfileUserUpdate otherTyped = other as UpdateUserProfileUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateUserProfileUserUpdate({
    required this.id,
  });
}

@immutable
class UpdateUserProfileData {
  final UpdateUserProfileUserUpdate? user_update;
  UpdateUserProfileData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : UpdateUserProfileUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserProfileData otherTyped = other as UpdateUserProfileData;
    return user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => user_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  UpdateUserProfileData({
    this.user_update,
  });
}

@immutable
class UpdateUserProfileVariables {
  final String id;
  late final Optional<String>name;
  late final Optional<String>photoUrl;
  late final Optional<String>phone;
  late final Optional<String>whatsapp;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateUserProfileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  
  
    photoUrl = Optional.optional(nativeFromJson, nativeToJson);
    photoUrl.value = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']);
  
  
    phone = Optional.optional(nativeFromJson, nativeToJson);
    phone.value = json['phone'] == null ? null : nativeFromJson<String>(json['phone']);
  
  
    whatsapp = Optional.optional(nativeFromJson, nativeToJson);
    whatsapp.value = json['whatsapp'] == null ? null : nativeFromJson<String>(json['whatsapp']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserProfileVariables otherTyped = other as UpdateUserProfileVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    photoUrl == otherTyped.photoUrl && 
    phone == otherTyped.phone && 
    whatsapp == otherTyped.whatsapp;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, photoUrl.hashCode, phone.hashCode, whatsapp.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    if(photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    if(phone.state == OptionalState.set) {
      json['phone'] = phone.toJson();
    }
    if(whatsapp.state == OptionalState.set) {
      json['whatsapp'] = whatsapp.toJson();
    }
    return json;
  }

  UpdateUserProfileVariables({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.phone,
    required this.whatsapp,
  });
}

