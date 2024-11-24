class RentInformation {
  String renterUID;
  String renterEmail;
  String carName;
  String startDateTime;
  String endDateTime;
  String rentLocation;
  String deliveryLocation;
  String estimatedDrivingDistance;
  String estimatedDrivingDuration;
  String pickupOrDelivery;
  String deliveryDistance;
  String deliveryDuration;
  String withDriver;
  String rentalFee;
  String mileageFee;
  String deliveryFee;
  String driverFee;
  String reservationFee;
  String totalAmount;
  String carType;
  String rentStatus;
  String adminNotes;
  String rent_car_UID;
  String carOwner;
  String paymentStatus;
  String postApproveStatus;
  String imagePathForAlternativePayment;

  RentInformation({
    required this.postApproveStatus,
    required this.paymentStatus,
    required this.rent_car_UID,
    required this.renterUID,
    required this.renterEmail,
    required this.carName,
    required this.startDateTime,
    required this.endDateTime,
    required this.rentLocation,
    required this.deliveryLocation,
    required this.estimatedDrivingDistance,
    required this.estimatedDrivingDuration,
    required this.pickupOrDelivery,
    required this.deliveryDistance,
    required this.deliveryDuration,
    required this.withDriver,
    required this.rentalFee,
    required this.mileageFee,
    required this.deliveryFee,
    required this.driverFee,
    required this.reservationFee,
    required this.totalAmount,
    required this.carType,
    required this.rentStatus,
    required this.adminNotes,
    required this.carOwner,
    required this.imagePathForAlternativePayment
  });

  Map<String, String> getModelData() {
    return {
      "rent_image_path_for_alternative_payment" : imagePathForAlternativePayment,
      "rent_post_approve_status" : postApproveStatus,
      "rent_payment_status" : paymentStatus,
      "rent_car_UID" : rent_car_UID,
      "rent_carType" : carType,
      "rent_renterUID" : renterUID,
      "rent_renterEmail" : renterEmail,
      "rent_carName" : carName,
      "rent_startDateTime" : startDateTime,
      "rent_endDateTime" : endDateTime,
      "rent_rentLocation" : rentLocation,
      "rent_deliveryLocation" : deliveryLocation,
      "rent_estimatedDrivingDistance" : estimatedDrivingDistance,
      "rent_estimatedDrivingDuration" : estimatedDrivingDuration,
      "rent_pickupOrDelivery" : pickupOrDelivery,
      "rent_deliveryDistance" : deliveryDistance,
      "rent_deliveryDuration" : deliveryDuration,
      "rent_withDriver" : withDriver,
      "rent_rentalFee" : rentalFee,
      "rent_mileageFee" : mileageFee,
      "rent_deliveryFee" : deliveryFee,
      "rent_driverFee" : driverFee,
      "rent_reservationFee" : reservationFee,
      "rent_totalAmount" : totalAmount,
      "rent_status" : rentStatus,
      "rent_notes" : adminNotes,
      "rent_car_owner" : carOwner
    };
  }

  factory RentInformation.fromFirestore(Map<String, dynamic> data) {
    return RentInformation(
        imagePathForAlternativePayment: data["rent_image_path_for_alternative_payment"] ?? "",
        postApproveStatus: data["rent_post_approve_status"] ?? "",
        paymentStatus: data["rent_payment_status"] ?? "",
        carType: data["rent_carType"] ?? "",
        rent_car_UID: data["rent_car_UID"] ?? "",
        renterUID: data["rent_renterUID"] ?? "",
        renterEmail: data["rent_renterEmail"] ?? "",
        carName: data["rent_carName"] ?? "",
        startDateTime: data["rent_startDateTime"] ?? "",
        endDateTime: data["rent_endDateTime"] ?? "",
        rentLocation: data["rent_rentLocation"] ?? "",
        deliveryLocation: data["rent_deliveryLocation"] ?? "",
        estimatedDrivingDistance: data["rent_estimatedDrivingDistance"] ?? "",
        estimatedDrivingDuration: data["rent_estimatedDrivingDuration"] ?? "",
        pickupOrDelivery: data["rent_pickupOrDelivery"] ?? "",
        deliveryDistance: data["rent_deliveryDistance"] ?? "",
        deliveryDuration: data["rent_deliveryDuration"] ?? "",
        withDriver: data["rent_withDriver"] ?? "",
        rentalFee: data["rent_rentalFee"] ?? "",
        mileageFee: data["rent_mileageFee"] ?? "",
        deliveryFee: data["rent_deliveryFee"] ?? "",
        reservationFee: data["rent_reservationFee"] ?? "",
        totalAmount: data["rent_totalAmount"] ?? "",
        rentStatus: data["rent_status"] ?? "",
        adminNotes:  data["rent_notes"] ?? "",
        driverFee: data["rent_driverFee"] ?? "",
      carOwner: data["rent_car_owner"] ?? ""
    );
  }
}