enum Role {
  none,
  member,
  staff,
  admin,
}

Role stringToRole(dynamic role) {
  switch (role) {
    case null:
      return Role.none;
    case "none":
      return Role.none;
    case "member":
      return Role.member;
    case "staff":
      return Role.staff;
    case "admin":
      return Role.admin;
    default:
      return Role.none;
  }
}

String roleToString(Role role) {
  switch (role) {
    case Role.none:
      return "none";
    case Role.member:
      return "member";
    case Role.staff:
      return "staff";
    case Role.admin:
      return "admin";
    default:
      return "none";
  }
}
