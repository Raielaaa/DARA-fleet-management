class FirebaseConstants {
  static const String registerCollection = "dara-registered-user-data";
  static const String carInfoCollection = "dara-car-info";
  static String URlforCarImages(String imagePath) {
    return "https://firebasestorage.googleapis.com/v0/b/dara-renting-app.appspot.com/o/car_images%2$imagePath}?alt=media";
  }
}