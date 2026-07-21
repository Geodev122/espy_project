# Basic Usage

```dart
EspyConnector.instance.CreateUser(createUserVariables).execute();
EspyConnector.instance.UpdateUserProfile(updateUserProfileVariables).execute();
EspyConnector.instance.UpsertProfessionalProfile(upsertProfessionalProfileVariables).execute();
EspyConnector.instance.CreateService(createServiceVariables).execute();
EspyConnector.instance.UpdateService(updateServiceVariables).execute();
EspyConnector.instance.CreateLocationNode(createLocationNodeVariables).execute();
EspyConnector.instance.SpendTokens(spendTokensVariables).execute();
EspyConnector.instance.PostCommunityRequest(postCommunityRequestVariables).execute();
EspyConnector.instance.RecordInteraction(recordInteractionVariables).execute();
EspyConnector.instance.ApproveProfessional(approveProfessionalVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await EspyConnector.instance.ListSupportTickets({ ... })
.status(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

