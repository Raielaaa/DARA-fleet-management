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

  RentInformation({
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
    required this.adminNotes
  });

  Map<String, String> getModelData() {
    return {
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
      "rent_notes" : adminNotes
    };
  }
}