part of 'espy.dart';

class ListPendingApprovalsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListPendingApprovalsVariablesBuilder(this._dataConnect, );
  Deserializer<ListPendingApprovalsData> dataDeserializer = (dynamic json)  => ListPendingApprovalsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListPendingApprovalsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListPendingApprovalsData, void> ref() {
    
    return _dataConnect.query("ListPendingApprovals", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListPendingApprovalsProfessionalProfiles {
  final String id;
  final String? fullNameAr;
  final ListPendingApprovalsProfessionalProfilesUser user;
  ListPendingApprovalsProfessionalProfiles.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  fullNameAr = json['fullNameAr'] == null ? null : nativeFromJson<String>(json['fullNameAr']),
  user = ListPendingApprovalsProfessionalProfilesUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingApprovalsProfessionalProfiles otherTyped = other as ListPendingApprovalsProfessionalProfiles;
    return id == otherTyped.id && 
    fullNameAr == otherTyped.fullNameAr && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, fullNameAr.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (fullNameAr != null) {
      json['fullNameAr'] = nativeToJson<String?>(fullNameAr);
    }
    json['user'] = user.toJson();
    return json;
  }

  ListPendingApprovalsProfessionalProfiles({
    required this.id,
    this.fullNameAr,
    required this.user,
  });
}

@immutable
class ListPendingApprovalsProfessionalProfilesUser {
  final String id;
  final String email;
  final Timestamp createdAt;
  ListPendingApprovalsProfessionalProfilesUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingApprovalsProfessionalProfilesUser otherTyped = other as ListPendingApprovalsProfessionalProfilesUser;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  ListPendingApprovalsProfessionalProfilesUser({
    required this.id,
    required this.email,
    required this.createdAt,
  });
}

@immutable
class ListPendingApprovalsData {
  final List<ListPendingApprovalsProfessionalProfiles> professionalProfiles;
  ListPendingApprovalsData.fromJson(dynamic json):
  
  professionalProfiles = (json['professionalProfiles'] as List<dynamic>)
        .map((e) => ListPendingApprovalsProfessionalProfiles.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingApprovalsData otherTyped = other as ListPendingApprovalsData;
    return professionalProfiles == otherTyped.professionalProfiles;
    
  }
  @override
  int get hashCode => professionalProfiles.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['professionalProfiles'] = professionalProfiles.map((e) => e.toJson()).toList();
    return json;
  }

  ListPendingApprovalsData({
    required this.professionalProfiles,
  });
}

