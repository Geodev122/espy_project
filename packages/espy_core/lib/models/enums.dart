/// ESPY PROTOCOL - ENUMS v9.1
library;

enum UserRole {
  visitor,
  professional,
  institution,
  admin,
  pending;

  static UserRole parse(dynamic val) {
    if (val == null) return UserRole.pending;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return UserRole.values.firstWhere(
      (e) => e.name == str,
      orElse: () => UserRole.pending,
    );
  }

  String toSql() => name.toUpperCase();
}

enum MembershipTier {
  basic,
  gold,
  platinum;

  static MembershipTier parse(dynamic val) {
    if (val == null) return MembershipTier.basic;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return MembershipTier.values.firstWhere(
      (e) => e.name == str,
      orElse: () => MembershipTier.basic,
    );
  }

  String toSql() => name.toUpperCase();
}

enum TransactionType {
  recharge,
  purchase,
  refund,
  bonus;

  static TransactionType parse(dynamic val) {
    if (val == null) return TransactionType.purchase;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return TransactionType.values.firstWhere(
      (e) => e.name == str,
      orElse: () => TransactionType.purchase,
    );
  }

  String toSql() => name.toUpperCase();
}

enum InteractionType {
  like,
  dislike,
  view,
  favorite,
  share,
  contact;

  static InteractionType parse(dynamic val) {
    if (val == null) return InteractionType.view;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return InteractionType.values.firstWhere(
      (e) => e.name == str,
      orElse: () => InteractionType.view,
    );
  }

  String toSql() => name.toUpperCase();
}

enum CommunityRequestStatus {
  active,
  fulfilled,
  expired,
  pending;

  static CommunityRequestStatus parse(dynamic val) {
    if (val == null) return CommunityRequestStatus.active;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return CommunityRequestStatus.values.firstWhere(
      (e) => e.name == str,
      orElse: () => CommunityRequestStatus.active,
    );
  }

  String toSql() => name.toUpperCase();
}

enum SupportTicketStatus {
  open,
  closed,
  pending;

  static SupportTicketStatus parse(dynamic val) {
    if (val == null) return SupportTicketStatus.open;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return SupportTicketStatus.values.firstWhere(
      (e) => e.name == str,
      orElse: () => SupportTicketStatus.open,
    );
  }

  String toSql() => name.toUpperCase();
}

enum OrderStatus {
  pending,
  approved,
  paid,
  cancelled;

  static OrderStatus parse(dynamic val) {
    if (val == null) return OrderStatus.pending;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return OrderStatus.values.firstWhere(
      (e) => e.name == str,
      orElse: () => OrderStatus.pending,
    );
  }

  String toSql() => name.toUpperCase();
}

enum DeliveryMode {
  online,
  face_to_face,
  field;

  static DeliveryMode parse(dynamic val) {
    if (val == null) return DeliveryMode.face_to_face;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase().replaceAll('-', '_');
    return DeliveryMode.values.firstWhere(
      (e) => e.name == str,
      orElse: () => DeliveryMode.face_to_face,
    );
  }

  String toSql() => name.toUpperCase();
}

enum UrgencyLevel {
  low,
  medium,
  high,
  emergency;

  static UrgencyLevel parse(dynamic val) {
    if (val == null) return UrgencyLevel.medium;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return UrgencyLevel.values.firstWhere(
      (e) => e.name == str,
      orElse: () => UrgencyLevel.medium,
    );
  }

  String toSql() => name.toUpperCase();
}

enum ModerationStatus {
  pending,
  approved,
  flagged,
  archived;

  static ModerationStatus parse(dynamic val) {
    if (val == null) return ModerationStatus.pending;
    final String str = (val is Enum) ? val.name : val.toString().toLowerCase();
    return ModerationStatus.values.firstWhere(
      (e) => e.name == str,
      orElse: () => ModerationStatus.pending,
    );
  }

  String toSql() => name.toUpperCase();
}
