class FirebaseConstants {
  static const String registerRoleCollection = "dara-user-role";
  static const String registerCollection = "dara-registered-user-data";
  static const String carInfoCollection = "dara-car-info";
  static const String rentRecordsCollection = "dara-rent-records";
  static const String rentDocumentsUpload = "rent_documents_upload";
  static const String reportImages = "report_images";
  static const String userReportCollection = "dara-user-reports";
  static const String outsourceApplication = "dara-outsource-application";
  static const String driverApplication = "dara-driver-application";
  static const String accountantCollection = "dara-accountant-records";
  static const String bannerPromosCollection = "banner_promos";
  static const String bannerPopupsCollection = "banner_popups";
  static const String garageCollection = "dara-garage-location";

  static String URlforCarImages(String imagePath) {
    return "https://firebasestorage.googleapis.com/v0/b/dara-renting-app.appspot.com/o/car_images%2$imagePath}?alt=media";
  }

  static String retrieveImage(String imageUrl) {
    return 'https://firebasestorage.googleapis.com/v0/b/dara-renting-app.appspot.com/o/${Uri.encodeComponent(imageUrl)}?alt=media';
  }
}