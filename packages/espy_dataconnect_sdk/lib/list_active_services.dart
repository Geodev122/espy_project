part of 'espy.dart';

class ListActiveServicesVariablesBuilder {
  Optional<String> _categoryId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _sectorId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListActiveServicesVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  ListActiveServicesVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }

  ListActiveServicesVariablesBuilder(this._dataConnect, );
  Deserializer<ListActiveServicesData> dataDeserializer = (dynamic json)  => ListActiveServicesData.fromJson(jsonDecode(json));
  Serializer<ListActiveServicesVariables> varsSerializer = (ListActiveServicesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListActiveServicesData, ListActiveServicesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListActiveServicesData, ListActiveServicesVariables> ref() {
    ListActiveServicesVariables vars= ListActiveServicesVariables(categoryId: _categoryId,sectorId: _sectorId,);
    return _dataConnect.query("ListActiveServices", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListActiveServicesServices {
  final String id;
  final String titleEn;
  final String? titleAr;
  final int? price;
  final String? imageUrl;
  final EnumValue<DeliveryMode>? deliveryMode;
  final ListActiveServicesServicesPriceTag? priceTag;
  final ListActiveServicesServicesCategory category;
  final List<ListActiveServicesServicesServiceListingTagsOnService> serviceListingTags_on_service;
  final ListActiveServicesServicesProvider provider;
  ListActiveServicesServices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  titleEn = nativeFromJson<String>(json['titleEn']),
  titleAr = json['titleAr'] == null ? null : nativeFromJson<String>(json['titleAr']),
  price = json['price'] == null ? null : nativeFromJson<int>(json['price']),
  imageUrl = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']),
  deliveryMode = json['deliveryMode'] == null ? null : deliveryModeDeserializer(json['deliveryMode']),
  priceTag = json['priceTag'] == null ? null : ListActiveServicesServicesPriceTag.fromJson(json['priceTag']),
  category = ListActiveServicesServicesCategory.fromJson(json['category']),
  serviceListingTags_on_service = (json['serviceListingTags_on_service'] as List<dynamic>)
        .map((e) => ListActiveServicesServicesServiceListingTagsOnService.fromJson(e))
        .toList(),
  provider = ListActiveServicesServicesProvider.fromJson(json['provider']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveServicesServices otherTyped = other as ListActiveServicesServices;
    return id == otherTyped.id && 
    titleEn == otherTyped.titleEn && 
    titleAr == otherTyped.titleAr && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl && 
    deliveryMode == otherTyped.deliveryMode && 
    priceTag == otherTyped.priceTag && 
    category == otherTyped.category && 
    serviceListingTags_on_service == otherTyped.serviceListingTags_on_service && 
    provider == otherTyped.provider;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, titleEn.hashCode, titleAr.hashCode, price.hashCode, imageUrl.hashCode, deliveryMode.hashCode, priceTag.hashCode, category.hashCode, serviceListingTags_on_service.hashCode, provider.hashCode]);
  

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
    if (priceTag != null) {
      json['priceTag'] = priceTag!.toJson();
    }
    json['category'] = category.toJson();
    json['serviceListingTags_on_service'] = serviceListingTags_on_service.map((e) => e.toJson()).toList();
    json['provider'] = provider.toJson();
    return json;
  }

  ListActiveServicesServices({
    required this.id,
    required this.titleEn,
    this.titleAr,
    this.price,
    this.imageUrl,
    this.deliveryMode,
    this.priceTag,
    required this.category,
    required this.serviceListingTags_on_service,
    required this.provider,
  });
}

@immutable
class ListActiveServicesServicesPriceTag {
  final String nameEn;
  final String? nameAr;
  ListActiveServicesServicesPriceTag.fromJson(dynamic json):
  
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

    final ListActiveServicesServicesPriceTag otherTyped = other as ListActiveServicesServicesPriceTag;
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

  ListActiveServicesServicesPriceTag({
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListActiveServicesServicesCategory {
  final ListActiveServicesServicesCategoryTemplate? template;
  ListActiveServicesServicesCategory.fromJson(dynamic json):
  
  template = json['template'] == null ? null : ListActiveServicesServicesCategoryTemplate.fromJson(json['template']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveServicesServicesCategory otherTyped = other as ListActiveServicesServicesCategory;
    return template == otherTyped.template;
    
  }
  @override
  int get hashCode => template.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (template != null) {
      json['template'] = template!.toJson();
    }
    return json;
  }

  ListActiveServicesServicesCategory({
    this.template,
  });
}

@immutable
class ListActiveServicesServicesCategoryTemplate {
  final String? accentColor;
  final String? iconName;
  final List<String>? visibleFields;
  ListActiveServicesServicesCategoryTemplate.fromJson(dynamic json):
  
  accentColor = json['accentColor'] == null ? null : nativeFromJson<String>(json['accentColor']),
  iconName = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']),
  visibleFields = json['visibleFields'] == null ? null : (json['visibleFields'] as List<dynamic>)
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

    final ListActiveServicesServicesCategoryTemplate otherTyped = other as ListActiveServicesServicesCategoryTemplate;
    return accentColor == otherTyped.accentColor && 
    iconName == otherTyped.iconName && 
    visibleFields == otherTyped.visibleFields;
    
  }
  @override
  int get hashCode => Object.hashAll([accentColor.hashCode, iconName.hashCode, visibleFields.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (accentColor != null) {
      json['accentColor'] = nativeToJson<String?>(accentColor);
    }
    if (iconName != null) {
      json['iconName'] = nativeToJson<String?>(iconName);
    }
    if (visibleFields != null) {
      json['visibleFields'] = visibleFields?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  ListActiveServicesServicesCategoryTemplate({
    this.accentColor,
    this.iconName,
    this.visibleFields,
  });
}

@immutable
class ListActiveServicesServicesServiceListingTagsOnService {
  final ListActiveServicesServicesServiceListingTagsOnServiceTag tag;
  ListActiveServicesServicesServiceListingTagsOnService.fromJson(dynamic json):
  
  tag = ListActiveServicesServicesServiceListingTagsOnServiceTag.fromJson(json['tag']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveServicesServicesServiceListingTagsOnService otherTyped = other as ListActiveServicesServicesServiceListingTagsOnService;
    return tag == otherTyped.tag;
    
  }
  @override
  int get hashCode => tag.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tag'] = tag.toJson();
    return json;
  }

  ListActiveServicesServicesServiceListingTagsOnService({
    required this.tag,
  });
}

@immutable
class ListActiveServicesServicesServiceListingTagsOnServiceTag {
  final String nameEn;
  final String? nameAr;
  ListActiveServicesServicesServiceListingTagsOnServiceTag.fromJson(dynamic json):
  
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

    final ListActiveServicesServicesServiceListingTagsOnServiceTag otherTyped = other as ListActiveServicesServicesServiceListingTagsOnServiceTag;
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

  ListActiveServicesServicesServiceListingTagsOnServiceTag({
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListActiveServicesServicesProvider {
  final String id;
  final String? name;
  final String? photoUrl;
  ListActiveServicesServicesProvider.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveServicesServicesProvider otherTyped = other as ListActiveServicesServicesProvider;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    photoUrl == otherTyped.photoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, photoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    return json;
  }

  ListActiveServicesServicesProvider({
    required this.id,
    this.name,
    this.photoUrl,
  });
}

@immutable
class ListActiveServicesData {
  final List<ListActiveServicesServices> services;
  ListActiveServicesData.fromJson(dynamic json):
  
  services = (json['services'] as List<dynamic>)
        .map((e) => ListActiveServicesServices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveServicesData otherTyped = other as ListActiveServicesData;
    return services == otherTyped.services;
    
  }
  @override
  int get hashCode => services.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['services'] = services.map((e) => e.toJson()).toList();
    return json;
  }

  ListActiveServicesData({
    required this.services,
  });
}

@immutable
class ListActiveServicesVariables {
  late final Optional<String>categoryId;
  late final Optional<String>sectorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListActiveServicesVariables.fromJson(Map<String, dynamic> json) {
  
  
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null ? null : nativeFromJson<String>(json['categoryId']);
  
  
    sectorId = Optional.optional(nativeFromJson, nativeToJson);
    sectorId.value = json['sectorId'] == null ? null : nativeFromJson<String>(json['sectorId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveServicesVariables otherTyped = other as ListActiveServicesVariables;
    return categoryId == otherTyped.categoryId && 
    sectorId == otherTyped.sectorId;
    
  }
  @override
  int get hashCode => Object.hashAll([categoryId.hashCode, sectorId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    if(sectorId.state == OptionalState.set) {
      json['sectorId'] = sectorId.toJson();
    }
    return json;
  }

  ListActiveServicesVariables({
    required this.categoryId,
    required this.sectorId,
  });
}

