part of 'espy.dart';

class CreateAnalyticsSnapshotVariablesBuilder {
  DateTime date;
  int totalUsers;
  double totalRevenue;
  int tokensBurned;
  int activeRequests;
  Optional<String> _topSectorId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateAnalyticsSnapshotVariablesBuilder topSectorId(String? t) {
   _topSectorId.value = t;
   return this;
  }

  CreateAnalyticsSnapshotVariablesBuilder(this._dataConnect, {required  this.date,required  this.totalUsers,required  this.totalRevenue,required  this.tokensBurned,required  this.activeRequests,});
  Deserializer<CreateAnalyticsSnapshotData> dataDeserializer = (dynamic json)  => CreateAnalyticsSnapshotData.fromJson(jsonDecode(json));
  Serializer<CreateAnalyticsSnapshotVariables> varsSerializer = (CreateAnalyticsSnapshotVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateAnalyticsSnapshotData, CreateAnalyticsSnapshotVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateAnalyticsSnapshotData, CreateAnalyticsSnapshotVariables> ref() {
    CreateAnalyticsSnapshotVariables vars= CreateAnalyticsSnapshotVariables(date: date,totalUsers: totalUsers,totalRevenue: totalRevenue,tokensBurned: tokensBurned,activeRequests: activeRequests,topSectorId: _topSectorId,);
    return _dataConnect.mutation("CreateAnalyticsSnapshot", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateAnalyticsSnapshotAnalyticsSnapshotInsert {
  final String id;
  CreateAnalyticsSnapshotAnalyticsSnapshotInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnalyticsSnapshotAnalyticsSnapshotInsert otherTyped = other as CreateAnalyticsSnapshotAnalyticsSnapshotInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAnalyticsSnapshotAnalyticsSnapshotInsert({
    required this.id,
  });
}

@immutable
class CreateAnalyticsSnapshotData {
  final CreateAnalyticsSnapshotAnalyticsSnapshotInsert analyticsSnapshot_insert;
  CreateAnalyticsSnapshotData.fromJson(dynamic json):
  
  analyticsSnapshot_insert = CreateAnalyticsSnapshotAnalyticsSnapshotInsert.fromJson(json['analyticsSnapshot_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnalyticsSnapshotData otherTyped = other as CreateAnalyticsSnapshotData;
    return analyticsSnapshot_insert == otherTyped.analyticsSnapshot_insert;
    
  }
  @override
  int get hashCode => analyticsSnapshot_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['analyticsSnapshot_insert'] = analyticsSnapshot_insert.toJson();
    return json;
  }

  CreateAnalyticsSnapshotData({
    required this.analyticsSnapshot_insert,
  });
}

@immutable
class CreateAnalyticsSnapshotVariables {
  final DateTime date;
  final int totalUsers;
  final double totalRevenue;
  final int tokensBurned;
  final int activeRequests;
  late final Optional<String>topSectorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateAnalyticsSnapshotVariables.fromJson(Map<String, dynamic> json):
  
  date = nativeFromJson<DateTime>(json['date']),
  totalUsers = nativeFromJson<int>(json['totalUsers']),
  totalRevenue = nativeFromJson<double>(json['totalRevenue']),
  tokensBurned = nativeFromJson<int>(json['tokensBurned']),
  activeRequests = nativeFromJson<int>(json['activeRequests']) {
  
  
  
  
  
  
  
    topSectorId = Optional.optional(nativeFromJson, nativeToJson);
    topSectorId.value = json['topSectorId'] == null ? null : nativeFromJson<String>(json['topSectorId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnalyticsSnapshotVariables otherTyped = other as CreateAnalyticsSnapshotVariables;
    return date == otherTyped.date && 
    totalUsers == otherTyped.totalUsers && 
    totalRevenue == otherTyped.totalRevenue && 
    tokensBurned == otherTyped.tokensBurned && 
    activeRequests == otherTyped.activeRequests && 
    topSectorId == otherTyped.topSectorId;
    
  }
  @override
  int get hashCode => Object.hashAll([date.hashCode, totalUsers.hashCode, totalRevenue.hashCode, tokensBurned.hashCode, activeRequests.hashCode, topSectorId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['date'] = nativeToJson<DateTime>(date);
    json['totalUsers'] = nativeToJson<int>(totalUsers);
    json['totalRevenue'] = nativeToJson<double>(totalRevenue);
    json['tokensBurned'] = nativeToJson<int>(tokensBurned);
    json['activeRequests'] = nativeToJson<int>(activeRequests);
    if(topSectorId.state == OptionalState.set) {
      json['topSectorId'] = topSectorId.toJson();
    }
    return json;
  }

  CreateAnalyticsSnapshotVariables({
    required this.date,
    required this.totalUsers,
    required this.totalRevenue,
    required this.tokensBurned,
    required this.activeRequests,
    required this.topSectorId,
  });
}

