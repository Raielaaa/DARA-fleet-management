class FeaturedCarInfo {
  final String carName;
  final String carCapacity;
  final String transmission;
  final String mileage;
  final String price;
  final String imageUrl;
  final String rentCount;

  FeaturedCarInfo({
    required this.carName,
    required this.carCapacity,
    required this.transmission,
    required this.mileage,
    required this.price,
    required this.imageUrl,
    required this.rentCount
  });

  factory FeaturedCarInfo.fromFirestore(Map<String, dynamic> data) {
    return FeaturedCarInfo(
        carName: data['car_name'] ?? '',
        carCapacity: data['car_capacity'] ?? '',
        transmission: data['car_transmission'] ?? '',
        mileage: data['car_mileage'] ?? '',
        price: data['car_price'] ?? '',
        imageUrl: data['car_main_pic'] ?? '',
        rentCount: data["car_rent_count"] ?? ""
    );
  }
}