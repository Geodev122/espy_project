part of 'espy.dart';

class SearchUsersAdminVariablesBuilder {
  Optional<String> _query = Optional.optional(nativeFromJson, nativeToJson);
  Optional<UserRole> _role = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
  Optional<bool> _hasProfile = Optional.optional(nativeFromJson, nativeToJson);
  Optional<bool> _isActive = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  SearchUsersAdminVariablesBuilder query(String? t) {
   _query.value = t;
   return this;
  }
  SearchUsersAdminVariablesBuilder role(UserRole? t) {
   _role.value = t;
   return this;
  }
  SearchUsersAdminVariablesBuilder hasProfile(bool? t) {
   _hasProfile.value = t;
   return this;
  }
  SearchUsersAdminVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }

  SearchUsersAdminVariablesBuilder(this._dataConnect, );
  Deserializer<SearchUsersAdminData> dataDeserializer = (dynamic json)  => SearchUsersAdminData.fromJson(jsonDecode(json));
  Serializer<SearchUsersAdminVariables> varsSerializer = (SearchUsersAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchUsersAdminData, SearchUsersAdminVariables>> execute() {
    return ref().execute();
  }

  QueryRef<SearchUsersAdminData, SearchUsersAdminVariables> ref() {
    SearchUsersAdminVariables vars= SearchUsersAdminVariables(query: _query,role: _role,hasProfile: _hasProfile,isActive: _isActive,);
    return _dataConnect.query("SearchUsersAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SearchUsersAdminUsers {
  final String id;
  final String email;
  final String? name;
  final EnumValue<UserRole> role;
  final bool isActive;
  final bool hasProfile;
  final String? phone;
  final String? whatsapp;
  final Timestamp createdAt;
  SearchUsersAdminUsers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  role = userRoleDeserializer(json['role']),
  isActive = nativeFromJson<bool>(json['isActive']),
  hasProfile = nativeFromJson<bool>(json['hasProfile']),
  phone = json['phone'] == null ? null : nativeFromJson<String>(json['phone']),
  whatsapp = json['whatsapp'] == null ? null : nativeFromJson<String>(json['whatsapp']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchUsersAdminUsers otherTyped = other as SearchUsersAdminUsers;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    name == otherTyped.name && 
    role == otherTyped.role && 
    isActive == otherTyped.isActive && 
    hasProfile == otherTyped.hasProfile && 
    phone == otherTyped.phone && 
    whatsapp == otherTyped.whatsapp && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode, role.hashCode, isActive.hashCode, hasProfile.hashCode, phone.hashCode, whatsapp.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    json['role'] = 
    userRoleSerializer(role)
    ;
    json['isActive'] = nativeToJson<bool>(isActive);
    json['hasProfile'] = nativeToJson<bool>(hasProfile);
    if (phone != null) {
      json['phone'] = nativeToJson<String?>(phone);
    }
    if (whatsapp != null) {
      json['whatsapp'] = nativeToJson<String?>(whatsapp);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  SearchUsersAdminUsers({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.isActive,
    required this.hasProfile,
    this.phone,
    this.whatsapp,
    required this.createdAt,
  });
}

@immutable
class SearchUsersAdminData {
  final List<SearchUsersAdminUsers> users;
  SearchUsersAdminData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => SearchUsersAdminUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchUsersAdminData otherTyped = other as SearchUsersAdminData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  SearchUsersAdminData({
    required this.users,
  });
}

@immutable
class SearchUsersAdminVariables {
  late final Optional<String>query;
  late final Optional<UserRole>role;
  late final Optional<bool>hasProfile;
  late final Optional<bool>isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SearchUsersAdminVariables.fromJson(Map<String, dynamic> json) {
  
  
    query = Optional.optional(nativeFromJson, nativeToJson);
    query.value = json['query'] == null ? null : nativeFromJson<String>(json['query']);
  
  
    role = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
    role.value = json['role'] == null ? null : UserRole.values.byName(json['role']);
  
  
    hasProfile = Optional.optional(nativeFromJson, nativeToJson);
    hasProfile.value = json['hasProfile'] == null ? null : nativeFromJson<bool>(json['hasProfile']);
  
  
    isActive = Optional.optional(nativeFromJson, nativeToJson);
    isActive.value = json['isActive'] == null ? null : nativeFromJson<bool>(json['isActive']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchUsersAdminVariables otherTyped = other as SearchUsersAdminVariables;
    return query == otherTyped.query && 
    role == otherTyped.role && 
    hasProfile == otherTyped.hasProfile && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([query.hashCode, role.hashCode, hasProfile.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(query.state == OptionalState.set) {
      json['query'] = query.toJson();
    }
    if(role.state == OptionalState.set) {
      json['role'] = role.toJson();
    }
    if(hasProfile.state == OptionalState.set) {
      json['hasProfile'] = hasProfile.toJson();
    }
    if(isActive.state == OptionalState.set) {
      json['isActive'] = isActive.toJson();
    }
    return json;
  }

  SearchUsersAdminVariables({
    required this.query,
    required this.role,
    required this.hasProfile,
    required this.isActive,
  });
}

