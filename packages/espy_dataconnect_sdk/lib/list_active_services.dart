part of 'espy.dart';

class ListActiveServicesVariablesBuilder {
  Optional<String> _categoryId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListActiveServicesVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }

  ListActiveServicesVariablesBuilder(this._dataConnect, );
  Deserializer<ListActiveServicesData> dataDeserializer = (dynamic json)  => ListActiveServicesData.fromJson(jsonDecode(json));
  Serializer<ListActiveServicesVariables> varsSerializer = (ListActiveServicesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListActiveServicesData, ListActiveServicesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListActiveServicesData, ListActiveServicesVariables> ref() {
    ListActiveServicesVariables vars= ListActiveServicesVariables(categoryId: _categoryId,);
    return _dataConnect.query("ListActiveServices", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListActiveServicesServices {
  final String id;
  final String titleEn;
  final String? titleAr;
  final String? descriptionEn;
  final int? price;
  final String? imageUrl;
  final ListActiveServicesServicesProvider provider;
  ListActiveServicesServices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  titleEn = nativeFromJson<String>(json['titleEn']),
  titleAr = json['titleAr'] == null ? null : nativeFromJson<String>(json['titleAr']),
  descriptionEn = json['descriptionEn'] == null ? null : nativeFromJson<String>(json['descriptionEn']),
  price = json['price'] == null ? null : nativeFromJson<int>(json['price']),
  imageUrl = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']),
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
    descriptionEn == otherTyped.descriptionEn && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl && 
    provider == otherTyped.provider;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, titleEn.hashCode, titleAr.hashCode, descriptionEn.hashCode, price.hashCode, imageUrl.hashCode, provider.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['titleEn'] = nativeToJson<String>(titleEn);
    if (titleAr != null) {
      json['titleAr'] = nativeToJson<String?>(titleAr);
    }
    if (descriptionEn != null) {
      json['descriptionEn'] = nativeToJson<String?>(descriptionEn);
    }
    if (price != null) {
      json['price'] = nativeToJson<int?>(price);
    }
    if (imageUrl != null) {
      json['imageUrl'] = nativeToJson<String?>(imageUrl);
    }
    json['provider'] = provider.toJson();
    return json;
  }

  ListActiveServicesServices({
    required this.id,
    required this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.price,
    this.imageUrl,
    required this.provider,
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
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListActiveServicesVariables.fromJson(Map<String, dynamic> json) {
  
  
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null ? null : nativeFromJson<String>(json['categoryId']);
  
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
    return categoryId == otherTyped.categoryId;
    
  }
  @override
  int get hashCode => categoryId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    return json;
  }

  ListActiveServicesVariables({
    required this.categoryId,
  });
}

