part of 'espy.dart';

class GetProfessionalDetailsVariablesBuilder {
  String uid;

  final FirebaseDataConnect _dataConnect;
  GetProfessionalDetailsVariablesBuilder(this._dataConnect, {required  this.uid,});
  Deserializer<GetProfessionalDetailsData> dataDeserializer = (dynamic json)  => GetProfessionalDetailsData.fromJson(jsonDecode(json));
  Serializer<GetProfessionalDetailsVariables> varsSerializer = (GetProfessionalDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProfessionalDetailsData, GetProfessionalDetailsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetProfessionalDetailsData, GetProfessionalDetailsVariables> ref() {
    GetProfessionalDetailsVariables vars= GetProfessionalDetailsVariables(uid: uid,);
    return _dataConnect.query("GetProfessionalDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProfessionalDetailsProfessionalProfile {
  final String id;
  final String? fullNameAr;
  final String? specialty;
  final String? specialtyAr;
  final String? bioEn;
  final String? bioAr;
  final bool isApproved;
  final bool isHonorVerified;
  final bool isProfileValidated;
  final EnumValue<MembershipTier>? membershipTier;
  final int serviceSlots;
  final int practicePins;
  final Timestamp? visibilityExpiresAt;
  final GetProfessionalDetailsProfessionalProfileUser user;
  GetProfessionalDetailsProfessionalProfile.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  fullNameAr = json['fullNameAr'] == null ? null : nativeFromJson<String>(json['fullNameAr']),
  specialty = json['specialty'] == null ? null : nativeFromJson<String>(json['specialty']),
  specialtyAr = json['specialtyAr'] == null ? null : nativeFromJson<String>(json['specialtyAr']),
  bioEn = json['bioEn'] == null ? null : nativeFromJson<String>(json['bioEn']),
  bioAr = json['bioAr'] == null ? null : nativeFromJson<String>(json['bioAr']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  isHonorVerified = nativeFromJson<bool>(json['isHonorVerified']),
  isProfileValidated = nativeFromJson<bool>(json['isProfileValidated']),
  membershipTier = json['membershipTier'] == null ? null : membershipTierDeserializer(json['membershipTier']),
  serviceSlots = nativeFromJson<int>(json['serviceSlots']),
  practicePins = nativeFromJson<int>(json['practicePins']),
  visibilityExpiresAt = json['visibilityExpiresAt'] == null ? null : Timestamp.fromJson(json['visibilityExpiresAt']),
  user = GetProfessionalDetailsProfessionalProfileUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProfessionalDetailsProfessionalProfile otherTyped = other as GetProfessionalDetailsProfessionalProfile;
    return id == otherTyped.id && 
    fullNameAr == otherTyped.fullNameAr && 
    specialty == otherTyped.specialty && 
    specialtyAr == otherTyped.specialtyAr && 
    bioEn == otherTyped.bioEn && 
    bioAr == otherTyped.bioAr && 
    isApproved == otherTyped.isApproved && 
    isHonorVerified == otherTyped.isHonorVerified && 
    isProfileValidated == otherTyped.isProfileValidated && 
    membershipTier == otherTyped.membershipTier && 
    serviceSlots == otherTyped.serviceSlots && 
    practicePins == otherTyped.practicePins && 
    visibilityExpiresAt == otherTyped.visibilityExpiresAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, fullNameAr.hashCode, specialty.hashCode, specialtyAr.hashCode, bioEn.hashCode, bioAr.hashCode, isApproved.hashCode, isHonorVerified.hashCode, isProfileValidated.hashCode, membershipTier.hashCode, serviceSlots.hashCode, practicePins.hashCode, visibilityExpiresAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (fullNameAr != null) {
      json['fullNameAr'] = nativeToJson<String?>(fullNameAr);
    }
    if (specialty != null) {
      json['specialty'] = nativeToJson<String?>(specialty);
    }
    if (specialtyAr != null) {
      json['specialtyAr'] = nativeToJson<String?>(specialtyAr);
    }
    if (bioEn != null) {
      json['bioEn'] = nativeToJson<String?>(bioEn);
    }
    if (bioAr != null) {
      json['bioAr'] = nativeToJson<String?>(bioAr);
    }
    json['isApproved'] = nativeToJson<bool>(isApproved);
    json['isHonorVerified'] = nativeToJson<bool>(isHonorVerified);
    json['isProfileValidated'] = nativeToJson<bool>(isProfileValidated);
    if (membershipTier != null) {
      json['membershipTier'] = 
    membershipTierSerializer(membershipTier!)
    ;
    }
    json['serviceSlots'] = nativeToJson<int>(serviceSlots);
    json['practicePins'] = nativeToJson<int>(practicePins);
    if (visibilityExpiresAt != null) {
      json['visibilityExpiresAt'] = visibilityExpiresAt!.toJson();
    }
    json['user'] = user.toJson();
    return json;
  }

  GetProfessionalDetailsProfessionalProfile({
    required this.id,
    this.fullNameAr,
    this.specialty,
    this.specialtyAr,
    this.bioEn,
    this.bioAr,
    required this.isApproved,
    required this.isHonorVerified,
    required this.isProfileValidated,
    this.membershipTier,
    required this.serviceSlots,
    required this.practicePins,
    this.visibilityExpiresAt,
    required this.user,
  });
}

@immutable
class GetProfessionalDetailsProfessionalProfileUser {
  final String email;
  final String? photoUrl;
  final String? whatsapp;
  GetProfessionalDetailsProfessionalProfileUser.fromJson(dynamic json):
  
  email = nativeFromJson<String>(json['email']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  whatsapp = json['whatsapp'] == null ? null : nativeFromJson<String>(json['whatsapp']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProfessionalDetailsProfessionalProfileUser otherTyped = other as GetProfessionalDetailsProfessionalProfileUser;
    return email == otherTyped.email && 
    photoUrl == otherTyped.photoUrl && 
    whatsapp == otherTyped.whatsapp;
    
  }
  @override
  int get hashCode => Object.hashAll([email.hashCode, photoUrl.hashCode, whatsapp.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = nativeToJson<String>(email);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    if (whatsapp != null) {
      json['whatsapp'] = nativeToJson<String?>(whatsapp);
    }
    return json;
  }

  GetProfessionalDetailsProfessionalProfileUser({
    required this.email,
    this.photoUrl,
    this.whatsapp,
  });
}

@immutable
class GetProfessionalDetailsData {
  final GetProfessionalDetailsProfessionalProfile? professionalProfile;
  GetProfessionalDetailsData.fromJson(dynamic json):
  
  professionalProfile = json['professionalProfile'] == null ? null : GetProfessionalDetailsProfessionalProfile.fromJson(json['professionalProfile']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProfessionalDetailsData otherTyped = other as GetProfessionalDetailsData;
    return professionalProfile == otherTyped.professionalProfile;
    
  }
  @override
  int get hashCode => professionalProfile.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (professionalProfile != null) {
      json['professionalProfile'] = professionalProfile!.toJson();
    }
    return json;
  }

  GetProfessionalDetailsData({
    this.professionalProfile,
  });
}

@immutable
class GetProfessionalDetailsVariables {
  final String uid;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProfessionalDetailsVariables.fromJson(Map<String, dynamic> json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProfessionalDetailsVariables otherTyped = other as GetProfessionalDetailsVariables;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  GetProfessionalDetailsVariables({
    required this.uid,
  });
}

