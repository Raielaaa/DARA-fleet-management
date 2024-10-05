class CompleteCarInfo {
  final String availability;
  final String capacity;
  final String color;
  final String engine;
  final String fuel;
  final String fuelVariant;
  final String horsePower;
  final String longDescription;
  final String shortDescription;
  final String mainPicUrl;
  final String pic1Url;
  final String pic2Url;
  final String pic3Url;
  final String pic4Url;
  final String pic5Url;
  final String mileage;
  final String name;
  final String price;
  final String rentCount;
  final String totalEarnings;
  final String transmission;
  final String carType;

  CompleteCarInfo({
    required this.carType,
    required this.transmission,
    required this.totalEarnings,
    required this.rentCount,
    required this.price,
    required this.name,
    required this.mileage,
    required this.pic5Url,
    required this.pic4Url,
    required this.pic3Url,
    required this.pic2Url,
    required this.pic1Url,
    required this.mainPicUrl,
    required this.availability,
    required this.capacity,
    required this.color,
    required this.engine,
    required this.fuel,
    required this.fuelVariant,
    required this.horsePower,
    required this.longDescription,
    required this.shortDescription
  });

  factory CompleteCarInfo.fromFirestore(Map<String, dynamic> data) {
    return CompleteCarInfo(
      name: data["car_name"] ?? "",
      carType: data["car_type"] ?? "",
      transmission: data["car_transmission"] ?? "",
      totalEarnings: data["car_total_earnings"] ?? "",
      rentCount: data["car_rent_count"] ?? "",
      price: data["car_price"] ?? "",
      mileage: data["car_mileage"] ?? "",
      pic5Url: data["car_pic5"] ?? "",
      pic4Url: data["car_pic4"] ?? "",
      pic3Url: data["car_pic3"] ?? "",
      pic2Url: data["car_pic2"] ?? "",
      pic1Url: data["car_pic1"] ?? "",
      mainPicUrl: data["car_main_pic"] ?? "",
      availability: data["car_availability"] ?? "",
      capacity: data["car_capacity"] ?? "",
      color: data["car_color"] ?? "",
      engine: data["car_engine"] ?? "",
      fuel: data["car_fuel"] ?? "",
      fuelVariant: data["car_fuel_variant"] ?? "",
      horsePower: data["car_horse_power"] ?? "",
      longDescription:  data["car_long_description"] ?? "",
      shortDescription: data["car_short_description"] ?? ""
    );
  }
}