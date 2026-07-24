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
  final bool isActive;
  final bool hasProfile;
  final String? adminNotes;
  final int walletBalance;
  final int tokensUsed;
  final String? photoUrl;
  final String? phone;
  final String? whatsapp;
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
  isActive = nativeFromJson<bool>(json['isActive']),
  hasProfile = nativeFromJson<bool>(json['hasProfile']),
  adminNotes = json['adminNotes'] == null ? null : nativeFromJson<String>(json['adminNotes']),
  walletBalance = nativeFromJson<int>(json['walletBalance']),
  tokensUsed = nativeFromJson<int>(json['tokensUsed']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  phone = json['phone'] == null ? null : nativeFromJson<String>(json['phone']),
  whatsapp = json['whatsapp'] == null ? null : nativeFromJson<String>(json['whatsapp']),
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
    isActive == otherTyped.isActive && 
    hasProfile == otherTyped.hasProfile && 
    adminNotes == otherTyped.adminNotes && 
    walletBalance == otherTyped.walletBalance && 
    tokensUsed == otherTyped.tokensUsed && 
    photoUrl == otherTyped.photoUrl && 
    phone == otherTyped.phone && 
    whatsapp == otherTyped.whatsapp && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt && 
    professionalProfile_on_user == otherTyped.professionalProfile_on_user && 
    institutionProfile_on_user == otherTyped.institutionProfile_on_user && 
    visitorProfile_on_user == otherTyped.visitorProfile_on_user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode, role.hashCode, isActive.hashCode, hasProfile.hashCode, adminNotes.hashCode, walletBalance.hashCode, tokensUsed.hashCode, photoUrl.hashCode, phone.hashCode, whatsapp.hashCode, createdAt.hashCode, updatedAt.hashCode, professionalProfile_on_user.hashCode, institutionProfile_on_user.hashCode, visitorProfile_on_user.hashCode]);
  

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
    if (adminNotes != null) {
      json['adminNotes'] = nativeToJson<String?>(adminNotes);
    }
    json['walletBalance'] = nativeToJson<int>(walletBalance);
    json['tokensUsed'] = nativeToJson<int>(tokensUsed);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    if (phone != null) {
      json['phone'] = nativeToJson<String?>(phone);
    }
    if (whatsapp != null) {
      json['whatsapp'] = nativeToJson<String?>(whatsapp);
    }
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
    required this.isActive,
    required this.hasProfile,
    this.adminNotes,
    required this.walletBalance,
    required this.tokensUsed,
    this.photoUrl,
    this.phone,
    this.whatsapp,
    required this.createdAt,
    required this.updatedAt,
    this.professionalProfile_on_user,
    this.institutionProfile_on_user,
    this.visitorProfile_on_user,
  });
}

@immutable
class GetUserUserProfessionalProfileOnUser {
  final String id;
  final String? specialty;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final EnumValue<MembershipTier>? membershipTier;
  final Timestamp? visibilityExpiresAt;
  GetUserUserProfessionalProfileOnUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  specialty = json['specialty'] == null ? null : nativeFromJson<String>(json['specialty']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  isProfileValidated = nativeFromJson<bool>(json['isProfileValidated']),
  verificationDocUrl = json['verificationDocUrl'] == null ? null : nativeFromJson<String>(json['verificationDocUrl']),
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
    return id == otherTyped.id && 
    specialty == otherTyped.specialty && 
    isApproved == otherTyped.isApproved && 
    isProfileValidated == otherTyped.isProfileValidated && 
    verificationDocUrl == otherTyped.verificationDocUrl && 
    membershipTier == otherTyped.membershipTier && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, specialty.hashCode, isApproved.hashCode, isProfileValidated.hashCode, verificationDocUrl.hashCode, membershipTier.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (specialty != null) {
      json['specialty'] = nativeToJson<String?>(specialty);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    json['isProfileValidated'] = nativeToJson<bool>(isProfileValidated);
    if (verificationDocUrl != null) {
      json['verificationDocUrl'] = nativeToJson<String?>(verificationDocUrl);
    }
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
    required this.id,
    this.specialty,
    required this.isApproved,
    required this.isProfileValidated,
    this.verificationDocUrl,
    this.membershipTier,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserUserInstitutionProfileOnUser {
  final String id;
  final String? nameAr;
  final String? registrationNumber;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final Timestamp? visibilityExpiresAt;
  GetUserUserInstitutionProfileOnUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  registrationNumber = json['registrationNumber'] == null ? null : nativeFromJson<String>(json['registrationNumber']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  isProfileValidated = nativeFromJson<bool>(json['isProfileValidated']),
  verificationDocUrl = json['verificationDocUrl'] == null ? null : nativeFromJson<String>(json['verificationDocUrl']),
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
    return id == otherTyped.id && 
    nameAr == otherTyped.nameAr && 
    registrationNumber == otherTyped.registrationNumber && 
    isApproved == otherTyped.isApproved && 
    isProfileValidated == otherTyped.isProfileValidated && 
    verificationDocUrl == otherTyped.verificationDocUrl && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameAr.hashCode, registrationNumber.hashCode, isApproved.hashCode, isProfileValidated.hashCode, verificationDocUrl.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (registrationNumber != null) {
      json['registrationNumber'] = nativeToJson<String?>(registrationNumber);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    json['isProfileValidated'] = nativeToJson<bool>(isProfileValidated);
    if (verificationDocUrl != null) {
      json['verificationDocUrl'] = nativeToJson<String?>(verificationDocUrl);
    }
    if (visibilityExpiresAt != null) {
      json['visibilityExpiresAt'] = visibilityExpiresAt!.toJson();
    }
    return json;
  }

  GetUserUserInstitutionProfileOnUser({
    required this.id,
    this.nameAr,
    this.registrationNumber,
    required this.isApproved,
    required this.isProfileValidated,
    this.verificationDocUrl,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserUserVisitorProfileOnUser {
  final String id;
  final List<String>? interests;
  GetUserUserVisitorProfileOnUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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
    return id == otherTyped.id && 
    interests == otherTyped.interests;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, interests.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (interests != null) {
      json['interests'] = interests?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  GetUserUserVisitorProfileOnUser({
    required this.id,
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

