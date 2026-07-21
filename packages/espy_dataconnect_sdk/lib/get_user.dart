part of 'espy.dart';

class GetUserVariablesBuilder {
  String uid;

  final FirebaseDataConnect _dataConnect;
  GetUserVariablesBuilder(this._dataConnect, {required  this.uid,});
  Deserializer<GetUserData> dataDeserializer = (dynamic json)  => GetUserData.fromJson(jsonDecode(json));
  Serializer<GetUserVariables> varsSerializer = (GetUserVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserData, GetUserVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserData, GetUserVariables> ref() {
    GetUserVariables vars= GetUserVariables(uid: uid,);
    return _dataConnect.query("GetUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUserUser {
  final String id;
  final String email;
  final String? name;
  final EnumValue<UserRole> role;
  final int walletBalance;
  final String? photoUrl;
  final bool isActive;
  final GetUserUserProfessionalProfileOnUser? professionalProfile_on_user;
  final GetUserUserInstitutionProfileOnUser? institutionProfile_on_user;
  GetUserUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  role = userRoleDeserializer(json['role']),
  walletBalance = nativeFromJson<int>(json['walletBalance']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  isActive = nativeFromJson<bool>(json['isActive']),
  professionalProfile_on_user = json['professionalProfile_on_user'] == null ? null : GetUserUserProfessionalProfileOnUser.fromJson(json['professionalProfile_on_user']),
  institutionProfile_on_user = json['institutionProfile_on_user'] == null ? null : GetUserUserInstitutionProfileOnUser.fromJson(json['institutionProfile_on_user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserUser otherTyped = other as GetUserUser;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    name == otherTyped.name && 
    role == otherTyped.role && 
    walletBalance == otherTyped.walletBalance && 
    photoUrl == otherTyped.photoUrl && 
    isActive == otherTyped.isActive && 
    professionalProfile_on_user == otherTyped.professionalProfile_on_user && 
    institutionProfile_on_user == otherTyped.institutionProfile_on_user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode, role.hashCode, walletBalance.hashCode, photoUrl.hashCode, isActive.hashCode, professionalProfile_on_user.hashCode, institutionProfile_on_user.hashCode]);
  

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
    json['walletBalance'] = nativeToJson<int>(walletBalance);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['isActive'] = nativeToJson<bool>(isActive);
    if (professionalProfile_on_user != null) {
      json['professionalProfile_on_user'] = professionalProfile_on_user!.toJson();
    }
    if (institutionProfile_on_user != null) {
      json['institutionProfile_on_user'] = institutionProfile_on_user!.toJson();
    }
    return json;
  }

  GetUserUser({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.walletBalance,
    this.photoUrl,
    required this.isActive,
    this.professionalProfile_on_user,
    this.institutionProfile_on_user,
  });
}

@immutable
class GetUserUserProfessionalProfileOnUser {
  final String? specialty;
  final bool isApproved;
  final EnumValue<MembershipTier>? membershipTier;
  final Timestamp? visibilityExpiresAt;
  GetUserUserProfessionalProfileOnUser.fromJson(dynamic json):
  
  specialty = json['specialty'] == null ? null : nativeFromJson<String>(json['specialty']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  membershipTier = json['membershipTier'] == null ? null : membershipTierDeserializer(json['membershipTier']),
  visibilityExpiresAt = json['visibilityExpiresAt'] == null ? null : Timestamp.fromJson(json['visibilityExpiresAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserUserProfessionalProfileOnUser otherTyped = other as GetUserUserProfessionalProfileOnUser;
    return specialty == otherTyped.specialty && 
    isApproved == otherTyped.isApproved && 
    membershipTier == otherTyped.membershipTier && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([specialty.hashCode, isApproved.hashCode, membershipTier.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (specialty != null) {
      json['specialty'] = nativeToJson<String?>(specialty);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    if (membershipTier != null) {
      json['membershipTier'] = 
    membershipTierSerializer(membershipTier!)
    ;
    }
    if (visibilityExpiresAt != null) {
      json['visibilityExpiresAt'] = visibilityExpiresAt!.toJson();
    }
    return json;
  }

  GetUserUserProfessionalProfileOnUser({
    this.specialty,
    required this.isApproved,
    this.membershipTier,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserUserInstitutionProfileOnUser {
  final String? nameAr;
  final bool isApproved;
  final Timestamp? visibilityExpiresAt;
  GetUserUserInstitutionProfileOnUser.fromJson(dynamic json):
  
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  visibilityExpiresAt = json['visibilityExpiresAt'] == null ? null : Timestamp.fromJson(json['visibilityExpiresAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserUserInstitutionProfileOnUser otherTyped = other as GetUserUserInstitutionProfileOnUser;
    return nameAr == otherTyped.nameAr && 
    isApproved == otherTyped.isApproved && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([nameAr.hashCode, isApproved.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    if (visibilityExpiresAt != null) {
      json['visibilityExpiresAt'] = visibilityExpiresAt!.toJson();
    }
    return json;
  }

  GetUserUserInstitutionProfileOnUser({
    this.nameAr,
    required this.isApproved,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserData {
  final GetUserUser? user;
  GetUserData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetUserUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserData otherTyped = other as GetUserData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  GetUserData({
    this.user,
  });
}

@immutable
class GetUserVariables {
  final String uid;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUserVariables.fromJson(Map<String, dynamic> json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserVariables otherTyped = other as GetUserVariables;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  GetUserVariables({
    required this.uid,
  });
}

