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
