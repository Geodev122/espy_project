part of 'espy.dart';

class ListBroadcastModerationQueueVariablesBuilder {
  Optional<ModerationStatus> _status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListBroadcastModerationQueueVariablesBuilder status(ModerationStatus? t) {
   _status.value = t;
   return this;
  }

  ListBroadcastModerationQueueVariablesBuilder(this._dataConnect, );
  Deserializer<ListBroadcastModerationQueueData> dataDeserializer = (dynamic json)  => ListBroadcastModerationQueueData.fromJson(jsonDecode(json));
  Serializer<ListBroadcastModerationQueueVariables> varsSerializer = (ListBroadcastModerationQueueVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListBroadcastModerationQueueData, ListBroadcastModerationQueueVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListBroadcastModerationQueueData, ListBroadcastModerationQueueVariables> ref() {
    ListBroadcastModerationQueueVariables vars= ListBroadcastModerationQueueVariables(status: _status,);
    return _dataConnect.query("ListBroadcastModerationQueue", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListBroadcastModerationQueueBroadcasts {
  final String id;
  final String title;
  final String message;
  final String? targetCountry;
  final String? targetRegion;
  final String? targetCity;
  final String status;
  final EnumValue<ModerationStatus> moderationStatus;
  final String? flagReason;
  final EnumValue<UserRole>? targetRole;
  final ListBroadcastModerationQueueBroadcastsTargetSector? targetSector;
  final ListBroadcastModerationQueueBroadcastsTargetCategory? targetCategory;
  final ListBroadcastModerationQueueBroadcastsSender sender;
  final Timestamp createdAt;
  ListBroadcastModerationQueueBroadcasts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  message = nativeFromJson<String>(json['message']),
  targetCountry = json['targetCountry'] == null ? null : nativeFromJson<String>(json['targetCountry']),
  targetRegion = json['targetRegion'] == null ? null : nativeFromJson<String>(json['targetRegion']),
  targetCity = json['targetCity'] == null ? null : nativeFromJson<String>(json['targetCity']),
  status = nativeFromJson<String>(json['status']),
  moderationStatus = moderationStatusDeserializer(json['moderationStatus']),
  flagReason = json['flagReason'] == null ? null : nativeFromJson<String>(json['flagReason']),
  targetRole = json['targetRole'] == null ? null : userRoleDeserializer(json['targetRole']),
  targetSector = json['targetSector'] == null ? null : ListBroadcastModerationQueueBroadcastsTargetSector.fromJson(json['targetSector']),
  targetCategory = json['targetCategory'] == null ? null : ListBroadcastModerationQueueBroadcastsTargetCategory.fromJson(json['targetCategory']),
  sender = ListBroadcastModerationQueueBroadcastsSender.fromJson(json['sender']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListBroadcastModerationQueueBroadcasts otherTyped = other as ListBroadcastModerationQueueBroadcasts;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    message == otherTyped.message && 
    targetCountry == otherTyped.targetCountry && 
    targetRegion == otherTyped.targetRegion && 
    targetCity == otherTyped.targetCity && 
    status == otherTyped.status && 
    moderationStatus == otherTyped.moderationStatus && 
    flagReason == otherTyped.flagReason && 
    targetRole == otherTyped.targetRole && 
    targetSector == otherTyped.targetSector && 
    targetCategory == otherTyped.targetCategory && 
    sender == otherTyped.sender && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, message.hashCode, targetCountry.hashCode, targetRegion.hashCode, targetCity.hashCode, status.hashCode, moderationStatus.hashCode, flagReason.hashCode, targetRole.hashCode, targetSector.hashCode, targetCategory.hashCode, sender.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['message'] = nativeToJson<String>(message);
    if (targetCountry != null) {
      json['targetCountry'] = nativeToJson<String?>(targetCountry);
    }
    if (targetRegion != null) {
      json['targetRegion'] = nativeToJson<String?>(targetRegion);
    }
    if (targetCity != null) {
      json['targetCity'] = nativeToJson<String?>(targetCity);
    }
    json['status'] = nativeToJson<String>(status);
    json['moderationStatus'] = 
    moderationStatusSerializer(moderationStatus)
    ;
    if (flagReason != null) {
      json['flagReason'] = nativeToJson<String?>(flagReason);
    }
    if (targetRole != null) {
      json['targetRole'] = 
    userRoleSerializer(targetRole!)
    ;
    }
    if (targetSector != null) {
      json['targetSector'] = targetSector!.toJson();
    }
    if (targetCategory != null) {
      json['targetCategory'] = targetCategory!.toJson();
    }
    json['sender'] = sender.toJson();
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  ListBroadcastModerationQueueBroadcasts({
    required this.id,
    required this.title,
    required this.message,
    this.targetCountry,
    this.targetRegion,
    this.targetCity,
    required this.status,
    required this.moderationStatus,
    this.flagReason,
    this.targetRole,
    this.targetSector,
    this.targetCategory,
    required this.sender,
    required this.createdAt,
  });
}

@immutable
class ListBroadcastModerationQueueBroadcastsTargetSector {
  final String id;
  final String nameEn;
  ListBroadcastModerationQueueBroadcastsTargetSector.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListBroadcastModerationQueueBroadcastsTargetSector otherTyped = other as ListBroadcastModerationQueueBroadcastsTargetSector;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    return json;
  }

  ListBroadcastModerationQueueBroadcastsTargetSector({
    required this.id,
    required this.nameEn,
  });
}

@immutable
class ListBroadcastModerationQueueBroadcastsTargetCategory {
  final String id;
  final String nameEn;
  ListBroadcastModerationQueueBroadcastsTargetCategory.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListBroadcastModerationQueueBroadcastsTargetCategory otherTyped = other as ListBroadcastModerationQueueBroadcastsTargetCategory;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    return json;
  }

  ListBroadcastModerationQueueBroadcastsTargetCategory({
    required this.id,
    required this.nameEn,
  });
}

@immutable
class ListBroadcastModerationQueueBroadcastsSender {
  final String id;
  final String? name;
  final String email;
  ListBroadcastModerationQueueBroadcastsSender.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListBroadcastModerationQueueBroadcastsSender otherTyped = other as ListBroadcastModerationQueueBroadcastsSender;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  ListBroadcastModerationQueueBroadcastsSender({
    required this.id,
    this.name,
    required this.email,
  });
}

@immutable
class ListBroadcastModerationQueueData {
  final List<ListBroadcastModerationQueueBroadcasts> broadcasts;
  ListBroadcastModerationQueueData.fromJson(dynamic json):
  
  broadcasts = (json['broadcasts'] as List<dynamic>)
        .map((e) => ListBroadcastModerationQueueBroadcasts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListBroadcastModerationQueueData otherTyped = other as ListBroadcastModerationQueueData;
    return broadcasts == otherTyped.broadcasts;
    
  }
  @override
  int get hashCode => broadcasts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['broadcasts'] = broadcasts.map((e) => e.toJson()).toList();
    return json;
  }

  ListBroadcastModerationQueueData({
    required this.broadcasts,
  });
}

@immutable
class ListBroadcastModerationQueueVariables {
  late final Optional<ModerationStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListBroadcastModerationQueueVariables.fromJson(Map<String, dynamic> json) {
  
  
    status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : ModerationStatus.values.byName(json['status']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListBroadcastModerationQueueVariables otherTyped = other as ListBroadcastModerationQueueVariables;
    return status == otherTyped.status;
    
  }
  @override
  int get hashCode => status.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    return json;
  }

  ListBroadcastModerationQueueVariables({
    required this.status,
  });
}

