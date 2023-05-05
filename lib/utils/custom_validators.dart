import 'package:form_field_validator/form_field_validator.dart';

class MinValueValidator extends TextFieldValidator {
  final double min;

  MinValueValidator(this.min, {required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    return double.parse(value!) >= min;
  }
}


class MaxValueValidator extends TextFieldValidator {
  final double max;

  MaxValueValidator(this.max, {required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    return double.parse(value!) <= max || max == 0;
  }
}
