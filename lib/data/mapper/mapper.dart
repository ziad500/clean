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

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(this?.id ?? Constants.zero, this?.title ?? Constants.empty,
        this?.image ?? Constants.empty);
  }
}

extension BannersResponseMapper on BannersResponse? {
  Banners toDomain() {
    return Banners(this?.id ?? Constants.zero, this?.link ?? Constants.empty,
        this?.title ?? Constants.empty, this?.image ?? Constants.empty);
  }
}

extension StoreResponseMapper on StoreResponse? {
  Stores toDomain() {
    return Stores(this?.id ?? Constants.zero, this?.title ?? Constants.empty,
        this?.image ?? Constants.empty);
  }
}

// lec 141
extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> services = (this
                ?.data
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty().cast<Service>())
        .toList();

    List<Banners> banners = (this
                ?.data
                ?.banners
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty().cast<Banners>())
        .toList();

    List<Stores> stores = (this
                ?.data
                ?.stores
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty().cast<Stores>())
        .toList();
    var data = HomeData(banners, services, stores);
    return HomeObject(data);
  }
}
