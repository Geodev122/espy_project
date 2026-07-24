part of 'espy.dart';

class GetAuditDetailsVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetAuditDetailsVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetAuditDetailsData> dataDeserializer = (dynamic json)  => GetAuditDetailsData.fromJson(jsonDecode(json));
  Serializer<GetAuditDetailsVariables> varsSerializer = (GetAuditDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAuditDetailsData, GetAuditDetailsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetAuditDetailsData, GetAuditDetailsVariables> ref() {
    GetAuditDetailsVariables vars= GetAuditDetailsVariables(id: id,);
    return _dataConnect.query("GetAuditDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAuditDetailsUser {
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
  final String? adminNotes;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final GetAuditDetailsUserProfessionalProfileOnUser? professionalProfile_on_user;
  final GetAuditDetailsUserInstitutionProfileOnUser? institutionProfile_on_user;
  final List<GetAuditDetailsUserWalletTransactionsOnUser> walletTransactions_on_user;
  GetAuditDetailsUser.fromJson(dynamic json):
  
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
  adminNotes = json['adminNotes'] == null ? null : nativeFromJson<String>(json['adminNotes']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']),
  professionalProfile_on_user = json['professionalProfile_on_user'] == null ? null : GetAuditDetailsUserProfessionalProfileOnUser.fromJson(json['professionalProfile_on_user']),
  institutionProfile_on_user = json['institutionProfile_on_user'] == null ? null : GetAuditDetailsUserInstitutionProfileOnUser.fromJson(json['institutionProfile_on_user']),
  walletTransactions_on_user = (json['walletTransactions_on_user'] as List<dynamic>)
        .map((e) => GetAuditDetailsUserWalletTransactionsOnUser.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAuditDetailsUser otherTyped = other as GetAuditDetailsUser;
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
    adminNotes == otherTyped.adminNotes && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt && 
    professionalProfile_on_user == otherTyped.professionalProfile_on_user && 
    institutionProfile_on_user == otherTyped.institutionProfile_on_user && 
    walletTransactions_on_user == otherTyped.walletTransactions_on_user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode, role.hashCode, isActive.hashCode, hasProfile.hashCode, photoUrl.hashCode, phone.hashCode, whatsapp.hashCode, walletBalance.hashCode, adminNotes.hashCode, createdAt.hashCode, updatedAt.hashCode, professionalProfile_on_user.hashCode, institutionProfile_on_user.hashCode, walletTransactions_on_user.hashCode]);
  

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
    if (adminNotes != null) {
      json['adminNotes'] = nativeToJson<String?>(adminNotes);
    }
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    if (professionalProfile_on_user != null) {
      json['professionalProfile_on_user'] = professionalProfile_on_user!.toJson();
    }
    if (institutionProfile_on_user != null) {
      json['institutionProfile_on_user'] = institutionProfile_on_user!.toJson();
    }
    json['walletTransactions_on_user'] = walletTransactions_on_user.map((e) => e.toJson()).toList();
    return json;
  }

  GetAuditDetailsUser({
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
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    this.professionalProfile_on_user,
    this.institutionProfile_on_user,
    required this.walletTransactions_on_user,
  });
}

@immutable
class GetAuditDetailsUserProfessionalProfileOnUser {
  final String id;
  final String? fullNameAr;
  final String? specialty;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final EnumValue<MembershipTier>? membershipTier;
  final Timestamp? visibilityExpiresAt;
  GetAuditDetailsUserProfessionalProfileOnUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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

    final GetAuditDetailsUserProfessionalProfileOnUser otherTyped = other as GetAuditDetailsUserProfessionalProfileOnUser;
    return id == otherTyped.id && 
    fullNameAr == otherTyped.fullNameAr && 
    specialty == otherTyped.specialty && 
    isApproved == otherTyped.isApproved && 
    isProfileValidated == otherTyped.isProfileValidated && 
    verificationDocUrl == otherTyped.verificationDocUrl && 
    membershipTier == otherTyped.membershipTier && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, fullNameAr.hashCode, specialty.hashCode, isApproved.hashCode, isProfileValidated.hashCode, verificationDocUrl.hashCode, membershipTier.hashCode, visibilityExpiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
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

  GetAuditDetailsUserProfessionalProfileOnUser({
    required this.id,
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
class GetAuditDetailsUserInstitutionProfileOnUser {
  final String id;
  final String? nameAr;
  final String? registrationNumber;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final Timestamp? visibilityExpiresAt;
  GetAuditDetailsUserInstitutionProfileOnUser.fromJson(dynamic json):
  
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

    final GetAuditDetailsUserInstitutionProfileOnUser otherTyped = other as GetAuditDetailsUserInstitutionProfileOnUser;
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

  GetAuditDetailsUserInstitutionProfileOnUser({
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
class GetAuditDetailsUserWalletTransactionsOnUser {
  final String id;
  final int amount;
  final EnumValue<TransactionType> type;
  final String? description;
  final Timestamp createdAt;
  GetAuditDetailsUserWalletTransactionsOnUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  amount = nativeFromJson<int>(json['amount']),
  type = transactionTypeDeserializer(json['type']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAuditDetailsUserWalletTransactionsOnUser otherTyped = other as GetAuditDetailsUserWalletTransactionsOnUser;
    return id == otherTyped.id && 
    amount == otherTyped.amount && 
    type == otherTyped.type && 
    description == otherTyped.description && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, amount.hashCode, type.hashCode, description.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['amount'] = nativeToJson<int>(amount);
    json['type'] = 
    transactionTypeSerializer(type)
    ;
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetAuditDetailsUserWalletTransactionsOnUser({
    required this.id,
    required this.amount,
    required this.type,
    this.description,
    required this.createdAt,
  });
}

@immutable
class GetAuditDetailsData {
  final GetAuditDetailsUser? user;
  GetAuditDetailsData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetAuditDetailsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAuditDetailsData otherTyped = other as GetAuditDetailsData;
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

  GetAuditDetailsData({
    this.user,
  });
}

@immutable
class GetAuditDetailsVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAuditDetailsVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAuditDetailsVariables otherTyped = other as GetAuditDetailsVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetAuditDetailsVariables({
    required this.id,
  });
}

