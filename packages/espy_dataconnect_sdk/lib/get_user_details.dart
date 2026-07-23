part of 'espy.dart';

class GetUserDetailsVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetUserDetailsVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetUserDetailsData> dataDeserializer = (dynamic json)  => GetUserDetailsData.fromJson(jsonDecode(json));
  Serializer<GetUserDetailsVariables> varsSerializer = (GetUserDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserDetailsData, GetUserDetailsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserDetailsData, GetUserDetailsVariables> ref() {
    GetUserDetailsVariables vars= GetUserDetailsVariables(id: id,);
    return _dataConnect.query("GetUserDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUserDetailsUser {
  final String id;
  final String email;
  final String? name;
  final EnumValue<UserRole> role;
  final bool isActive;
  final bool hasProfile;
  final String? photoUrl;
  final String? phone;
  final String? whatsapp;
  final int walletBalance;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final GetUserDetailsUserProfessionalProfileOnUser? professionalProfile_on_user;
  final GetUserDetailsUserInstitutionProfileOnUser? institutionProfile_on_user;
  GetUserDetailsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  role = userRoleDeserializer(json['role']),
  isActive = nativeFromJson<bool>(json['isActive']),
  hasProfile = nativeFromJson<bool>(json['hasProfile']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  phone = json['phone'] == null ? null : nativeFromJson<String>(json['phone']),
  whatsapp = json['whatsapp'] == null ? null : nativeFromJson<String>(json['whatsapp']),
  walletBalance = nativeFromJson<int>(json['walletBalance']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']),
  professionalProfile_on_user = json['professionalProfile_on_user'] == null ? null : GetUserDetailsUserProfessionalProfileOnUser.fromJson(json['professionalProfile_on_user']),
  institutionProfile_on_user = json['institutionProfile_on_user'] == null ? null : GetUserDetailsUserInstitutionProfileOnUser.fromJson(json['institutionProfile_on_user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserDetailsUser otherTyped = other as GetUserDetailsUser;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    name == otherTyped.name && 
    role == otherTyped.role && 
    isActive == otherTyped.isActive && 
    hasProfile == otherTyped.hasProfile && 
    photoUrl == otherTyped.photoUrl && 
    phone == otherTyped.phone && 
    whatsapp == otherTyped.whatsapp && 
    walletBalance == otherTyped.walletBalance && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt && 
    professionalProfile_on_user == otherTyped.professionalProfile_on_user && 
    institutionProfile_on_user == otherTyped.institutionProfile_on_user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode, role.hashCode, isActive.hashCode, hasProfile.hashCode, photoUrl.hashCode, phone.hashCode, whatsapp.hashCode, walletBalance.hashCode, createdAt.hashCode, updatedAt.hashCode, professionalProfile_on_user.hashCode, institutionProfile_on_user.hashCode]);
  

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
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    if (phone != null) {
      json['phone'] = nativeToJson<String?>(phone);
    }
    if (whatsapp != null) {
      json['whatsapp'] = nativeToJson<String?>(whatsapp);
    }
    json['walletBalance'] = nativeToJson<int>(walletBalance);
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    if (professionalProfile_on_user != null) {
      json['professionalProfile_on_user'] = professionalProfile_on_user!.toJson();
    }
    if (institutionProfile_on_user != null) {
      json['institutionProfile_on_user'] = institutionProfile_on_user!.toJson();
    }
    return json;
  }

  GetUserDetailsUser({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.isActive,
    required this.hasProfile,
    this.photoUrl,
    this.phone,
    this.whatsapp,
    required this.walletBalance,
    required this.createdAt,
    required this.updatedAt,
    this.professionalProfile_on_user,
    this.institutionProfile_on_user,
  });
}

@immutable
class GetUserDetailsUserProfessionalProfileOnUser {
  final String? fullNameAr;
  final String? specialty;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final EnumValue<MembershipTier>? membershipTier;
  final Timestamp? visibilityExpiresAt;
  GetUserDetailsUserProfessionalProfileOnUser.fromJson(dynamic json):
  
  fullNameAr = json['fullNameAr'] == null ? null : nativeFromJson<String>(json['fullNameAr']),
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

    final GetUserDetailsUserProfessionalProfileOnUser otherTyped = other as GetUserDetailsUserProfessionalProfileOnUser;
    return fullNameAr == otherTyped.fullNameAr && 
    specialty == otherTyped.specialty && 
    isApproved == otherTyped.isApproved && 
    isProfileValidated == otherTyped.isProfileValidated && 
    verificationDocUrl == otherTyped.verificationDocUrl && 
    membershipTier == otherTyped.membershipTier && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([fullNameAr.hashCode, specialty.hashCode, isApproved.hashCode, isProfileValidated.hashCode, verificationDocUrl.hashCode, membershipTier.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (fullNameAr != null) {
      json['fullNameAr'] = nativeToJson<String?>(fullNameAr);
    }
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

  GetUserDetailsUserProfessionalProfileOnUser({
    this.fullNameAr,
    this.specialty,
    required this.isApproved,
    required this.isProfileValidated,
    this.verificationDocUrl,
    this.membershipTier,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserDetailsUserInstitutionProfileOnUser {
  final String? nameAr;
  final String? registrationNumber;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final Timestamp? visibilityExpiresAt;
  GetUserDetailsUserInstitutionProfileOnUser.fromJson(dynamic json):
  
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

    final GetUserDetailsUserInstitutionProfileOnUser otherTyped = other as GetUserDetailsUserInstitutionProfileOnUser;
    return nameAr == otherTyped.nameAr && 
    registrationNumber == otherTyped.registrationNumber && 
    isApproved == otherTyped.isApproved && 
    isProfileValidated == otherTyped.isProfileValidated && 
    verificationDocUrl == otherTyped.verificationDocUrl && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([nameAr.hashCode, registrationNumber.hashCode, isApproved.hashCode, isProfileValidated.hashCode, verificationDocUrl.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
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

  GetUserDetailsUserInstitutionProfileOnUser({
    this.nameAr,
    this.registrationNumber,
    required this.isApproved,
    required this.isProfileValidated,
    this.verificationDocUrl,
    this.visibilityExpiresAt,
  });
}

@immutable
class GetUserDetailsData {
  final GetUserDetailsUser? user;
  GetUserDetailsData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetUserDetailsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserDetailsData otherTyped = other as GetUserDetailsData;
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

  GetUserDetailsData({
    this.user,
  });
}

@immutable
class GetUserDetailsVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUserDetailsVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserDetailsVariables otherTyped = other as GetUserDetailsVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetUserDetailsVariables({
    required this.id,
  });
}

