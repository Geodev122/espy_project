part of 'espy.dart';

class ListAllUsersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListAllUsersVariablesBuilder(this._dataConnect, );
  Deserializer<ListAllUsersData> dataDeserializer = (dynamic json)  => ListAllUsersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListAllUsersData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListAllUsersData, void> ref() {
    
    return _dataConnect.query("ListAllUsers", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListAllUsersUsers {
  final String id;
  final String email;
  final String? name;
  final EnumValue<UserRole> role;
  final bool isActive;
  final bool hasProfile;
  final String? phone;
  final String? whatsapp;
  final Timestamp createdAt;
  ListAllUsersUsers.fromJson(dynamic json):
  
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

    final ListAllUsersUsers otherTyped = other as ListAllUsersUsers;
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

  ListAllUsersUsers({
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
class ListAllUsersData {
  final List<ListAllUsersUsers> users;
  ListAllUsersData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => ListAllUsersUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAllUsersData otherTyped = other as ListAllUsersData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  ListAllUsersData({
    required this.users,
  });
}

