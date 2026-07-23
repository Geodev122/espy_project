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
  final int tokensUsed;
  final String? photoUrl;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final GetUserUserProfessionalProfileOnUser? professionalProfile_on_user;
  final GetUserUserInstitutionProfileOnUser? institutionProfile_on_user;
  final GetUserUserVisitorProfileOnUser? visitorProfile_on_user;
  GetUserUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  role = userRoleDeserializer(json['role']),
  walletBalance = nativeFromJson<int>(json['walletBalance']),
  tokensUsed = nativeFromJson<int>(json['tokensUsed']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  isActive = nativeFromJson<bool>(json['isActive']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']),
  professionalProfile_on_user = json['professionalProfile_on_user'] == null ? null : GetUserUserProfessionalProfileOnUser.fromJson(json['professionalProfile_on_user']),
  institutionProfile_on_user = json['institutionProfile_on_user'] == null ? null : GetUserUserInstitutionProfileOnUser.fromJson(json['institutionProfile_on_user']),
  visitorProfile_on_user = json['visitorProfile_on_user'] == null ? null : GetUserUserVisitorProfileOnUser.fromJson(json['visitorProfile_on_user']);
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
    tokensUsed == otherTyped.tokensUsed && 
    photoUrl == otherTyped.photoUrl && 
    isActive == otherTyped.isActive && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt && 
    professionalProfile_on_user == otherTyped.professionalProfile_on_user && 
    institutionProfile_on_user == otherTyped.institutionProfile_on_user && 
    visitorProfile_on_user == otherTyped.visitorProfile_on_user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode, role.hashCode, walletBalance.hashCode, tokensUsed.hashCode, photoUrl.hashCode, isActive.hashCode, createdAt.hashCode, updatedAt.hashCode, professionalProfile_on_user.hashCode, institutionProfile_on_user.hashCode, visitorProfile_on_user.hashCode]);
  

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
    json['tokensUsed'] = nativeToJson<int>(tokensUsed);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['isActive'] = nativeToJson<bool>(isActive);
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    if (professionalProfile_on_user != null) {
      json['professionalProfile_on_user'] = professionalProfile_on_user!.toJson();
    }
    if (institutionProfile_on_user != null) {
      json['institutionProfile_on_user'] = institutionProfile_on_user!.toJson();
    }
    if (visitorProfile_on_user != null) {
      json['visitorProfile_on_user'] = visitorProfile_on_user!.toJson();
    }
    return json;
  }

  GetUserUser({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.walletBalance,
    required this.tokensUsed,
    this.photoUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.professionalProfile_on_user,
    this.institutionProfile_on_user,
    this.visitorProfile_on_user,
  });
}

@immutable
class GetUserUserProfessionalProfileOnUser {
  final String? specialty;
  final bool isApproved;
  final bool isProfileValidated;
  final EnumValue<MembershipTier>? membershipTier;
  final Timestamp? visibilityExpiresAt;
  GetUserUserProfessionalProfileOnUser.fromJson(dynamic json):
  
  specialty = json['specialty'] == null ? null : nativeFromJson<String>(json['specialty']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  isProfileValidated = nativeFromJson<bool>(json['isProfileValidated']),
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
    isProfileValidated == otherTyped.isProfileValidated && 
    membershipTier == otherTyped.membershipTier && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([specialty.hashCode, isApproved.hashCode, isProfileValidated.hashCode, membershipTier.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (specialty != null) {
      json['specialty'] = nativeToJson<String?>(specialty);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    json['isProfileValidated'] = nativeToJson<bool>(isProfileValidated);
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
    required this.isProfileValidated,
    this.membershipTier,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserUserInstitutionProfileOnUser {
  final String? nameAr;
  final bool isApproved;
  final bool isProfileValidated;
  final Timestamp? visibilityExpiresAt;
  GetUserUserInstitutionProfileOnUser.fromJson(dynamic json):
  
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  isProfileValidated = nativeFromJson<bool>(json['isProfileValidated']),
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
    isProfileValidated == otherTyped.isProfileValidated && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([nameAr.hashCode, isApproved.hashCode, isProfileValidated.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    json['isProfileValidated'] = nativeToJson<bool>(isProfileValidated);
    if (visibilityExpiresAt != null) {
      json['visibilityExpiresAt'] = visibilityExpiresAt!.toJson();
    }
    return json;
  }

  GetUserUserInstitutionProfileOnUser({
    this.nameAr,
    required this.isApproved,
    required this.isProfileValidated,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserUserVisitorProfileOnUser {
  final List<String>? interests;
  GetUserUserVisitorProfileOnUser.fromJson(dynamic json):
  
  interests = json['interests'] == null ? null : (json['interests'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserUserVisitorProfileOnUser otherTyped = other as GetUserUserVisitorProfileOnUser;
    return interests == otherTyped.interests;
    
  }
  @override
  int get hashCode => interests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (interests != null) {
      json['interests'] = interests?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  GetUserUserVisitorProfileOnUser({
    this.interests,
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

