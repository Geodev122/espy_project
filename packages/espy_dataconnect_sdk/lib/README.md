# espy_dataconnect_sdk SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
EspyConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetUser
#### Required Arguments
```dart
String uid = ...;
EspyConnector.instance.getUser(
  uid: uid,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserData, GetUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getUser(
  uid: uid,
);
GetUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String uid = ...;

final ref = EspyConnector.instance.getUser(
  uid: uid,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetProfessionalDetails
#### Required Arguments
```dart
String uid = ...;
EspyConnector.instance.getProfessionalDetails(
  uid: uid,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProfessionalDetailsData, GetProfessionalDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getProfessionalDetails(
  uid: uid,
);
GetProfessionalDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String uid = ...;

final ref = EspyConnector.instance.getProfessionalDetails(
  uid: uid,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListActiveServices
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listActiveServices().execute();
```

#### Optional Arguments
We return a builder for each query. For ListActiveServices, we created `ListActiveServicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListActiveServicesVariablesBuilder {
  ...
 
  ListActiveServicesVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listActiveServices()
.categoryId(categoryId)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListActiveServicesData, ListActiveServicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listActiveServices();
ListActiveServicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listActiveServices().ref();
ref.execute();

ref.subscribe(...);
```


### SearchServices
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.searchServices().execute();
```

#### Optional Arguments
We return a builder for each query. For SearchServices, we created `SearchServicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SearchServicesVariablesBuilder {
  ...
 
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

  ...
}
EspyConnector.instance.searchServices()
.query(query)
.minPrice(minPrice)
.maxPrice(maxPrice)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<SearchServicesData, SearchServicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.searchServices();
SearchServicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.searchServices().ref();
ref.execute();

ref.subscribe(...);
```


### ListLocationNodes
#### Required Arguments
```dart
String userId = ...;
EspyConnector.instance.listLocationNodes(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListLocationNodesData, ListLocationNodesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listLocationNodes(
  userId: userId,
);
ListLocationNodesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = EspyConnector.instance.listLocationNodes(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListInteractions
#### Required Arguments
```dart
String actorId = ...;
EspyConnector.instance.listInteractions(
  actorId: actorId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ListInteractions, we created `ListInteractionsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListInteractionsVariablesBuilder {
  ...
   ListInteractionsVariablesBuilder type(InteractionType? t) {
   _type.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listInteractions(
  actorId: actorId,
)
.type(type)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListInteractionsData, ListInteractionsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listInteractions(
  actorId: actorId,
);
ListInteractionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String actorId = ...;

final ref = EspyConnector.instance.listInteractions(
  actorId: actorId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetWalletTransactions
#### Required Arguments
```dart
String userId = ...;
EspyConnector.instance.getWalletTransactions(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetWalletTransactionsData, GetWalletTransactionsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getWalletTransactions(
  userId: userId,
);
GetWalletTransactionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = EspyConnector.instance.getWalletTransactions(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListCommunityRequests
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listCommunityRequests().execute();
```

#### Optional Arguments
We return a builder for each query. For ListCommunityRequests, we created `ListCommunityRequestsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListCommunityRequestsVariablesBuilder {
  ...
 
  ListCommunityRequestsVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  ListCommunityRequestsVariablesBuilder status(CommunityRequestStatus? t) {
   _status.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listCommunityRequests()
.sectorId(sectorId)
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListCommunityRequestsData, ListCommunityRequestsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listCommunityRequests();
ListCommunityRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listCommunityRequests().ref();
ref.execute();

ref.subscribe(...);
```


### ListPendingApprovals
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listPendingApprovals().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPendingApprovalsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listPendingApprovals();
ListPendingApprovalsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listPendingApprovals().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
String id = ...;
String email = ...;
UserRole role = ...;
EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateUser, we created `CreateUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateUserVariablesBuilder {
  ...
   CreateUserVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
)
.name(name)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String email = ...;
UserRole role = ...;

final ref = EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
).ref();
ref.execute();
```


### UpdateUserProfile
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateUserProfile(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateUserProfile, we created `UpdateUserProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateUserProfileVariablesBuilder {
  ...
   UpdateUserProfileVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateUserProfile(
  id: id,
)
.name(name)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateUserProfileData, UpdateUserProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateUserProfile(
  id: id,
);
UpdateUserProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateUserProfile(
  id: id,
).ref();
ref.execute();
```


### CreateService
#### Required Arguments
```dart
String categoryId = ...;
String titleEn = ...;
int price = ...;
EspyConnector.instance.createService(
  categoryId: categoryId,
  titleEn: titleEn,
  price: price,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateServiceData, CreateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createService(
  categoryId: categoryId,
  titleEn: titleEn,
  price: price,
);
CreateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String categoryId = ...;
String titleEn = ...;
int price = ...;

final ref = EspyConnector.instance.createService(
  categoryId: categoryId,
  titleEn: titleEn,
  price: price,
).ref();
ref.execute();
```


### UpdateService
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateService(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateService, we created `UpdateServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateServiceVariablesBuilder {
  ...
   UpdateServiceVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }
  UpdateServiceVariablesBuilder isAllocated(bool? t) {
   _isAllocated.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateService(
  id: id,
)
.isActive(isActive)
.isAllocated(isAllocated)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateServiceData, UpdateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateService(
  id: id,
);
UpdateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateService(
  id: id,
).ref();
ref.execute();
```


### CreateLocationNode
#### Required Arguments
```dart
String countryId = ...;
String label = ...;
double lat = ...;
double lng = ...;
bool isMain = ...;
EspyConnector.instance.createLocationNode(
  countryId: countryId,
  label: label,
  lat: lat,
  lng: lng,
  isMain: isMain,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateLocationNodeData, CreateLocationNodeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createLocationNode(
  countryId: countryId,
  label: label,
  lat: lat,
  lng: lng,
  isMain: isMain,
);
CreateLocationNodeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String countryId = ...;
String label = ...;
double lat = ...;
double lng = ...;
bool isMain = ...;

final ref = EspyConnector.instance.createLocationNode(
  countryId: countryId,
  label: label,
  lat: lat,
  lng: lng,
  isMain: isMain,
).ref();
ref.execute();
```


### SpendTokens
#### Required Arguments
```dart
String userId = ...;
int cost = ...;
int ledgerAmount = ...;
String description = ...;
EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
).execute();
```

#### Optional Arguments
We return a builder for each query. For SpendTokens, we created `SpendTokensBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SpendTokensVariablesBuilder {
  ...
   SpendTokensVariablesBuilder type(TransactionType? t) {
   _type.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
)
.type(type)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<SpendTokensData, SpendTokensVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
);
SpendTokensData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
int cost = ...;
int ledgerAmount = ...;
String description = ...;

final ref = EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
).ref();
ref.execute();
```


### PostCommunityRequest
#### Required Arguments
```dart
String sectorId = ...;
String title = ...;
String description = ...;
EspyConnector.instance.postCommunityRequest(
  sectorId: sectorId,
  title: title,
  description: description,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<PostCommunityRequestData, PostCommunityRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.postCommunityRequest(
  sectorId: sectorId,
  title: title,
  description: description,
);
PostCommunityRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String sectorId = ...;
String title = ...;
String description = ...;

final ref = EspyConnector.instance.postCommunityRequest(
  sectorId: sectorId,
  title: title,
  description: description,
).ref();
ref.execute();
```


### RecordInteraction
#### Required Arguments
```dart
String targetId = ...;
InteractionType type = ...;
EspyConnector.instance.recordInteraction(
  targetId: targetId,
  type: type,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RecordInteractionData, RecordInteractionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.recordInteraction(
  targetId: targetId,
  type: type,
);
RecordInteractionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String targetId = ...;
InteractionType type = ...;

final ref = EspyConnector.instance.recordInteraction(
  targetId: targetId,
  type: type,
).ref();
ref.execute();
```


### ApproveProfessional
#### Required Arguments
```dart
String id = ...;
bool isApproved = ...;
EspyConnector.instance.approveProfessional(
  id: id,
  isApproved: isApproved,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ApproveProfessionalData, ApproveProfessionalVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.approveProfessional(
  id: id,
  isApproved: isApproved,
);
ApproveProfessionalData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool isApproved = ...;

final ref = EspyConnector.instance.approveProfessional(
  id: id,
  isApproved: isApproved,
).ref();
ref.execute();
```

