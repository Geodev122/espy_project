part of 'espy.dart';

class UpdateUserAdminVariablesBuilder {
  String id;
  Optional<String> _name = Optional.optional(nativeFromJson, nativeToJson);
  Optional<UserRole> _role = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
  Optional<bool> _isActive = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _phone = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _whatsapp = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _balance = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateUserAdminVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder role(UserRole? t) {
   _role.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder phone(String? t) {
   _phone.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder whatsapp(String? t) {
   _whatsapp.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder balance(int? t) {
   _balance.value = t;
   return this;
  }

  UpdateUserAdminVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateUserAdminData> dataDeserializer = (dynamic json)  => UpdateUserAdminData.fromJson(jsonDecode(json));
  Serializer<UpdateUserAdminVariables> varsSerializer = (UpdateUserAdminVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserAdminData, UpdateUserAdminVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserAdminData, UpdateUserAdminVariables> ref() {
    UpdateUserAdminVariables vars= UpdateUserAdminVariables(id: id,name: _name,role: _role,isActive: _isActive,phone: _phone,whatsapp: _whatsapp,notes: _notes,balance: _balance,);
    return _dataConnect.mutation("UpdateUserAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateUserAdminUserUpdate {
  final String id;
  UpdateUserAdminUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserAdminUserUpdate otherTyped = other as UpdateUserAdminUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateUserAdminUserUpdate({
    required this.id,
  });
}

@immutable
class UpdateUserAdminData {
  final UpdateUserAdminUserUpdate? user_update;
  UpdateUserAdminData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : UpdateUserAdminUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserAdminData otherTyped = other as UpdateUserAdminData;
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

  UpdateUserAdminData({
    this.user_update,
  });
}

@immutable
class UpdateUserAdminVariables {
  final String id;
  late final Optional<String>name;
  late final Optional<UserRole>role;
  late final Optional<bool>isActive;
  late final Optional<String>phone;
  late final Optional<String>whatsapp;
  late final Optional<String>notes;
  late final Optional<int>balance;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateUserAdminVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  
  
    role = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
    role.value = json['role'] == null ? null : UserRole.values.byName(json['role']);
  
  
    isActive = Optional.optional(nativeFromJson, nativeToJson);
    isActive.value = json['isActive'] == null ? null : nativeFromJson<bool>(json['isActive']);
  
  
    phone = Optional.optional(nativeFromJson, nativeToJson);
    phone.value = json['phone'] == null ? null : nativeFromJson<String>(json['phone']);
  
  
    whatsapp = Optional.optional(nativeFromJson, nativeToJson);
    whatsapp.value = json['whatsapp'] == null ? null : nativeFromJson<String>(json['whatsapp']);
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  
    balance = Optional.optional(nativeFromJson, nativeToJson);
    balance.value = json['balance'] == null ? null : nativeFromJson<int>(json['balance']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserAdminVariables otherTyped = other as UpdateUserAdminVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    role == otherTyped.role && 
    isActive == otherTyped.isActive && 
    phone == otherTyped.phone && 
    whatsapp == otherTyped.whatsapp && 
    notes == otherTyped.notes && 
    balance == otherTyped.balance;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, role.hashCode, isActive.hashCode, phone.hashCode, whatsapp.hashCode, notes.hashCode, balance.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    if(role.state == OptionalState.set) {
      json['role'] = role.toJson();
    }
    if(isActive.state == OptionalState.set) {
      json['isActive'] = isActive.toJson();
    }
    if(phone.state == OptionalState.set) {
      json['phone'] = phone.toJson();
    }
    if(whatsapp.state == OptionalState.set) {
      json['whatsapp'] = whatsapp.toJson();
    }
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    if(balance.state == OptionalState.set) {
      json['balance'] = balance.toJson();
    }
    return json;
  }

  UpdateUserAdminVariables({
    required this.id,
    required this.name,
    required this.role,
    required this.isActive,
    required this.phone,
    required this.whatsapp,
    required this.notes,
    required this.balance,
  });
}

