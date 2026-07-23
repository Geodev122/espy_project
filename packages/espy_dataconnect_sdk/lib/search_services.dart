part of 'espy.dart';

class SearchServicesVariablesBuilder {
  Optional<String> _query = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _minPrice = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _maxPrice = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  SearchServicesVariablesBuilder query(String? t) {
   _query.value = t;
   return this;
  }
  SearchServicesVariablesBuilder minPrice(int? t) {
   _minPrice.value = t;
   return this;
  }
  SearchServicesVariablesBuilder maxPrice(int? t) {
   _maxPrice.value = t;
   return this;
  }

  SearchServicesVariablesBuilder(this._dataConnect, );
  Deserializer<SearchServicesData> dataDeserializer = (dynamic json)  => SearchServicesData.fromJson(jsonDecode(json));
  Serializer<SearchServicesVariables> varsSerializer = (SearchServicesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchServicesData, SearchServicesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<SearchServicesData, SearchServicesVariables> ref() {
    SearchServicesVariables vars= SearchServicesVariables(query: _query,minPrice: _minPrice,maxPrice: _maxPrice,);
    return _dataConnect.query("SearchServices", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SearchServicesServices {
  final String id;
  final String titleEn;
  final int? price;
  final String? imageUrl;
  final SearchServicesServicesProvider provider;
  SearchServicesServices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  titleEn = nativeFromJson<String>(json['titleEn']),
  price = json['price'] == null ? null : nativeFromJson<int>(json['price']),
  imageUrl = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']),
  provider = SearchServicesServicesProvider.fromJson(json['provider']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchServicesServices otherTyped = other as SearchServicesServices;
    return id == otherTyped.id && 
    titleEn == otherTyped.titleEn && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl && 
    provider == otherTyped.provider;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, titleEn.hashCode, price.hashCode, imageUrl.hashCode, provider.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['titleEn'] = nativeToJson<String>(titleEn);
    if (price != null) {
      json['price'] = nativeToJson<int?>(price);
    }
    if (imageUrl != null) {
      json['imageUrl'] = nativeToJson<String?>(imageUrl);
    }
    json['provider'] = provider.toJson();
    return json;
  }

  SearchServicesServices({
    required this.id,
    required this.titleEn,
    this.price,
    this.imageUrl,
    required this.provider,
  });
}

@immutable
class SearchServicesServicesProvider {
  final String id;
  final String? name;
  SearchServicesServicesProvider.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchServicesServicesProvider otherTyped = other as SearchServicesServicesProvider;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    return json;
  }

  SearchServicesServicesProvider({
    required this.id,
    this.name,
  });
}

@immutable
class SearchServicesData {
  final List<SearchServicesServices> services;
  SearchServicesData.fromJson(dynamic json):
  
  services = (json['services'] as List<dynamic>)
        .map((e) => SearchServicesServices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchServicesData otherTyped = other as SearchServicesData;
    return services == otherTyped.services;
    
  }
  @override
  int get hashCode => services.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['services'] = services.map((e) => e.toJson()).toList();
    return json;
  }

  SearchServicesData({
    required this.services,
  });
}

@immutable
class SearchServicesVariables {
  late final Optional<String>query;
  late final Optional<int>minPrice;
  late final Optional<int>maxPrice;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SearchServicesVariables.fromJson(Map<String, dynamic> json) {
  
  
    query = Optional.optional(nativeFromJson, nativeToJson);
    query.value = json['query'] == null ? null : nativeFromJson<String>(json['query']);
  
  
    minPrice = Optional.optional(nativeFromJson, nativeToJson);
    minPrice.value = json['minPrice'] == null ? null : nativeFromJson<int>(json['minPrice']);
  
  
    maxPrice = Optional.optional(nativeFromJson, nativeToJson);
    maxPrice.value = json['maxPrice'] == null ? null : nativeFromJson<int>(json['maxPrice']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchServicesVariables otherTyped = other as SearchServicesVariables;
    return query == otherTyped.query && 
    minPrice == otherTyped.minPrice && 
    maxPrice == otherTyped.maxPrice;
    
  }
  @override
  int get hashCode => Object.hashAll([query.hashCode, minPrice.hashCode, maxPrice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(query.state == OptionalState.set) {
      json['query'] = query.toJson();
    }
    if(minPrice.state == OptionalState.set) {
      json['minPrice'] = minPrice.toJson();
    }
    if(maxPrice.state == OptionalState.set) {
      json['maxPrice'] = maxPrice.toJson();
    }
    return json;
  }

  SearchServicesVariables({
    required this.query,
    required this.minPrice,
    required this.maxPrice,
  });
}

