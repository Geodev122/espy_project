part of 'espy.dart';

class ListServiceModerationQueueVariablesBuilder {
  Optional<ModerationStatus> _status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListServiceModerationQueueVariablesBuilder status(ModerationStatus? t) {
   _status.value = t;
   return this;
  }

  ListServiceModerationQueueVariablesBuilder(this._dataConnect, );
  Deserializer<ListServiceModerationQueueData> dataDeserializer = (dynamic json)  => ListServiceModerationQueueData.fromJson(jsonDecode(json));
  Serializer<ListServiceModerationQueueVariables> varsSerializer = (ListServiceModerationQueueVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListServiceModerationQueueData, ListServiceModerationQueueVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListServiceModerationQueueData, ListServiceModerationQueueVariables> ref() {
    ListServiceModerationQueueVariables vars= ListServiceModerationQueueVariables(status: _status,);
    return _dataConnect.query("ListServiceModerationQueue", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListServiceModerationQueueServices {
  final String id;
  final String titleEn;
  final String? titleAr;
  final int? price;
  final String? imageUrl;
  final EnumValue<DeliveryMode>? deliveryMode;
  final EnumValue<ModerationStatus> moderationStatus;
  final String? flagReason;
  final ListServiceModerationQueueServicesCategory category;
  final ListServiceModerationQueueServicesSector sector;
  final ListServiceModerationQueueServicesProvider provider;
  ListServiceModerationQueueServices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  titleEn = nativeFromJson<String>(json['titleEn']),
  titleAr = json['titleAr'] == null ? null : nativeFromJson<String>(json['titleAr']),
  price = json['price'] == null ? null : nativeFromJson<int>(json['price']),
  imageUrl = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']),
  deliveryMode = json['deliveryMode'] == null ? null : deliveryModeDeserializer(json['deliveryMode']),
  moderationStatus = moderationStatusDeserializer(json['moderationStatus']),
  flagReason = json['flagReason'] == null ? null : nativeFromJson<String>(json['flagReason']),
  category = ListServiceModerationQueueServicesCategory.fromJson(json['category']),
  sector = ListServiceModerationQueueServicesSector.fromJson(json['sector']),
  provider = ListServiceModerationQueueServicesProvider.fromJson(json['provider']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceModerationQueueServices otherTyped = other as ListServiceModerationQueueServices;
    return id == otherTyped.id && 
    titleEn == otherTyped.titleEn && 
    titleAr == otherTyped.titleAr && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl && 
    deliveryMode == otherTyped.deliveryMode && 
    moderationStatus == otherTyped.moderationStatus && 
    flagReason == otherTyped.flagReason && 
    category == otherTyped.category && 
    sector == otherTyped.sector && 
    provider == otherTyped.provider;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, titleEn.hashCode, titleAr.hashCode, price.hashCode, imageUrl.hashCode, deliveryMode.hashCode, moderationStatus.hashCode, flagReason.hashCode, category.hashCode, sector.hashCode, provider.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['titleEn'] = nativeToJson<String>(titleEn);
    if (titleAr != null) {
      json['titleAr'] = nativeToJson<String?>(titleAr);
    }
    if (price != null) {
      json['price'] = nativeToJson<int?>(price);
    }
    if (imageUrl != null) {
      json['imageUrl'] = nativeToJson<String?>(imageUrl);
    }
    if (deliveryMode != null) {
      json['deliveryMode'] = 
    deliveryModeSerializer(deliveryMode!)
    ;
    }
    json['moderationStatus'] = 
    moderationStatusSerializer(moderationStatus)
    ;
    if (flagReason != null) {
      json['flagReason'] = nativeToJson<String?>(flagReason);
    }
    json['category'] = category.toJson();
    json['sector'] = sector.toJson();
    json['provider'] = provider.toJson();
    return json;
  }

  ListServiceModerationQueueServices({
    required this.id,
    required this.titleEn,
    this.titleAr,
    this.price,
    this.imageUrl,
    this.deliveryMode,
    required this.moderationStatus,
    this.flagReason,
    required this.category,
    required this.sector,
    required this.provider,
  });
}

@immutable
class ListServiceModerationQueueServicesCategory {
  final String nameEn;
  final String? nameAr;
  ListServiceModerationQueueServicesCategory.fromJson(dynamic json):
  
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceModerationQueueServicesCategory otherTyped = other as ListServiceModerationQueueServicesCategory;
    return nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr;
    
  }
  @override
  int get hashCode => Object.hashAll([nameEn.hashCode, nameAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    return json;
  }

  ListServiceModerationQueueServicesCategory({
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListServiceModerationQueueServicesSector {
  final String nameEn;
  final String? nameAr;
  ListServiceModerationQueueServicesSector.fromJson(dynamic json):
  
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceModerationQueueServicesSector otherTyped = other as ListServiceModerationQueueServicesSector;
    return nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr;
    
  }
  @override
  int get hashCode => Object.hashAll([nameEn.hashCode, nameAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    return json;
  }

  ListServiceModerationQueueServicesSector({
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListServiceModerationQueueServicesProvider {
  final String id;
  final String? name;
  final String? photoUrl;
  final String email;
  ListServiceModerationQueueServicesProvider.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceModerationQueueServicesProvider otherTyped = other as ListServiceModerationQueueServicesProvider;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    photoUrl == otherTyped.photoUrl && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, photoUrl.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  ListServiceModerationQueueServicesProvider({
    required this.id,
    this.name,
    this.photoUrl,
    required this.email,
  });
}

@immutable
class ListServiceModerationQueueData {
  final List<ListServiceModerationQueueServices> services;
  ListServiceModerationQueueData.fromJson(dynamic json):
  
  services = (json['services'] as List<dynamic>)
        .map((e) => ListServiceModerationQueueServices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceModerationQueueData otherTyped = other as ListServiceModerationQueueData;
    return services == otherTyped.services;
    
  }
  @override
  int get hashCode => services.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['services'] = services.map((e) => e.toJson()).toList();
    return json;
  }

  ListServiceModerationQueueData({
    required this.services,
  });
}

@immutable
class ListServiceModerationQueueVariables {
  late final Optional<ModerationStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListServiceModerationQueueVariables.fromJson(Map<String, dynamic> json) {
  
  
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

    final ListServiceModerationQueueVariables otherTyped = other as ListServiceModerationQueueVariables;
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

  ListServiceModerationQueueVariables({
    required this.status,
  });
}

