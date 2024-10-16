class AccountantModel {
  String? rentCarName;
  String? rentCarType;
  String? rentCarUID;
  String? rentDeliveryDistance;
  String? rentDeliveryDuration;
  String? rentDeliveryFee;
  String? rentDeliveryLocation;
  String? rentDriverFee;
  String? rentEndDateTime;
  String? rentEstimatedDrivingDistance;
  String? rentEstimatedDrivingDuration;
  String? rentMileageFee;
  String? rentNotes;
  String? rentPickupOrDelivery;
  String? rentRentLocation;
  String? rentRentalFee;
  String? rentRenterEmail;
  String? rentRenterUID;
  String? rentReservationFee;
  String? rentStartDateTime;
  String? rentStatus;
  String? rentTotalAmount;
  String? rentWithDriver;

  AccountantModel({
    required this.rentCarName,
    required this.rentCarType,
    required this.rentCarUID,
    required this.rentDeliveryDistance,
    required this.rentDeliveryDuration,
    required this.rentDeliveryFee,
    required this.rentDeliveryLocation,
    required this.rentDriverFee,
    required this.rentEndDateTime,
    required this.rentEstimatedDrivingDistance,
    required this.rentEstimatedDrivingDuration,
    required this.rentMileageFee,
    required this.rentNotes,
    required this.rentPickupOrDelivery,
    required this.rentRentLocation,
    required this.rentRentalFee,
    required this.rentRenterEmail,
    required this.rentRenterUID,
    required this.rentReservationFee,
    required this.rentStartDateTime,
    required this.rentStatus,
    required this.rentTotalAmount,
    required this.rentWithDriver,
  });

  // Method to convert model to a Map for Firestore upload
  Map<String, String> getModelData() {
    return {
      "rent_carName": rentCarName ?? "",
      "rent_carType": rentCarType ?? "",
      "rent_car_UID": rentCarUID ?? "",
      "rent_deliveryDistance": rentDeliveryDistance ?? "",
      "rent_deliveryDuration": rentDeliveryDuration ?? "",
      "rent_deliveryFee": rentDeliveryFee ?? "",
      "rent_deliveryLocation": rentDeliveryLocation ?? "",
      "rent_driverFee": rentDriverFee ?? "",
      "rent_endDateTime": rentEndDateTime ?? "",
      "rent_estimatedDrivingDistance": rentEstimatedDrivingDistance ?? "",
      "rent_estimatedDrivingDuration": rentEstimatedDrivingDuration ?? "",
      "rent_mileageFee": rentMileageFee ?? "",
      "rent_notes": rentNotes ?? "",
      "rent_pickupOrDelivery": rentPickupOrDelivery ?? "",
      "rent_rentLocation": rentRentLocation ?? "",
      "rent_rentalFee": rentRentalFee ?? "",
      "rent_renterEmail": rentRenterEmail ?? "",
      "rent_renterUID": rentRenterUID ?? "",
      "rent_reservationFee": rentReservationFee ?? "",
      "rent_startDateTime": rentStartDateTime ?? "",
      "rent_status": rentStatus ?? "",
      "rent_totalAmount": rentTotalAmount ?? "",
      "rent_withDriver": rentWithDriver ?? "",
    };
  }

  // Factory constructor to create an instance from Firestore data
  factory AccountantModel.fromFirestore(Map<String, dynamic> data) {
    return AccountantModel(
      rentCarName: data["rent_carName"] ?? "",
      rentCarType: data["rent_carType"] ?? "",
      rentCarUID: data["rent_car_UID"] ?? "",
      rentDeliveryDistance: data["rent_deliveryDistance"] ?? "",
      rentDeliveryDuration: data["rent_deliveryDuration"] ?? "",
      rentDeliveryFee: data["rent_deliveryFee"] ?? "",
      rentDeliveryLocation: data["rent_deliveryLocation"] ?? "",
      rentDriverFee: data["rent_driverFee"] ?? "",
      rentEndDateTime: data["rent_endDateTime"] ?? "",
      rentEstimatedDrivingDistance: data["rent_estimatedDrivingDistance"] ?? "",
      rentEstimatedDrivingDuration: data["rent_estimatedDrivingDuration"] ?? "",
      rentMileageFee: data["rent_mileageFee"] ?? "",
      rentNotes: data["rent_notes"] ?? "",
      rentPickupOrDelivery: data["rent_pickupOrDelivery"] ?? "",
      rentRentLocation: data["rent_rentLocation"] ?? "",
      rentRentalFee: data["rent_rentalFee"] ?? "",
      rentRenterEmail: data["rent_renterEmail"] ?? "",
      rentRenterUID: data["rent_renterUID"] ?? "",
      rentReservationFee: data["rent_reservationFee"] ?? "",
      rentStartDateTime: data["rent_startDateTime"] ?? "",
      rentStatus: data["rent_status"] ?? "",
      rentTotalAmount: data["rent_totalAmount"] ?? "",
      rentWithDriver: data["rent_withDriver"] ?? "",
    );
  }
}
