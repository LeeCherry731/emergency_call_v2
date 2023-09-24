class ContactModel {
  final String id;
  final String name;
  final List<Phone> phones;

  ContactModel({
    required this.id,
    required this.name,
    required this.phones,
  });
}

class Phone {
  final String name;
  final String phone;

  Phone({
    required this.name,
    required this.phone,
  });
}
