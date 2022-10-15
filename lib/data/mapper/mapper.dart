import 'package:clean/data/response/responses.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/app/extensions.dart';
import 'package:clean/app/constants.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
        this?.id.orEmpty() ?? Constants.empty,
        this?.name.orEmpty() ?? Constants.empty,
        this?.numberOfNotiffications.orZero() ?? Constants.zero);
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
        this?.email.orEmpty() ?? Constants.empty,
        this?.phone.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension AuthanticationResponseMapper on AuthenticationResponse? {
  Authantication toDomain() {
    return Authantication(this?.customer.toDomain(), this?.contacts.toDomain());
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  ForgotPassword toDomain() {
    return ForgotPassword(this?.support.orEmpty() ?? Constants.empty);
  }
}
