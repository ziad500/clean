// ignore_for_file: public_member_api_docs, sort_constructors_first
//onboarding models
class SliderObject {
  String title;
  String subTitle;
  String image;
  SliderObject(this.image, this.subTitle, this.title);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;
  SliderViewObject(this.currentIndex, this.numOfSlides, this.sliderObject);
}

//login models
class Customer {
  String id;
  String name;
  int numberOfNotiffications;
  Customer(
    this.id,
    this.name,
    this.numberOfNotiffications,
  );
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts(
    this.phone,
    this.email,
    this.link,
  );
}

class Authantication {
  Customer? customer;
  Contacts? contacts;
  Authantication(
    this.customer,
    this.contacts,
  );
}

// forgotPassword
class ForgotPassword {
  String support;
  ForgotPassword(this.support);
}

//home page
class Service {
  int id;
  String title;
  String image;
  Service(this.id, this.title, this.image);
}

class Banners {
  int id;
  String link;
  String title;
  String image;
  Banners(this.id, this.link, this.title, this.image);
}

class Stores {
  int id;
  String title;
  String image;
  Stores(this.id, this.title, this.image);
}

class HomeData {
  List<Service> services;

  List<Banners> banners;

  List<Stores> stores;

  HomeData(this.banners, this.services, this.stores);
}

class HomeObject {
  HomeData data;
  HomeObject(this.data);
}
