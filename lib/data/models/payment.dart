import 'package:equatable/equatable.dart';
class Payment extends Equatable {

    String options;
    String title;
    String name;
    String phone;
    String email;
    String ref;
    String? description;

    Payment({required this.options, required this.title, required this.name, required this.phone, required this.email,
      required this.ref, this.description});

    factory Payment.fromJson(dynamic json) {
      return Payment(
        title: json["title"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        options: json["options"],
        ref: json["ref"],
        description: json["description"],
      );
    }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["name"] = name;
    data["phone"] = phone;
    data["email"] = email;
    data["options"] = options;
    data["ref"] = ref;
    data["description"] = description;
    return data;
  }

  @override
  List<Object?> get props => [
    options,
    title,
    name,
    phone,
    email,
    ref,
    description
  ];

}
