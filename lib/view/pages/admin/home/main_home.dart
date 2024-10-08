import "package:dara_app/controller/home/home_controller.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/controller/utils/constants.dart";
import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/model/home/featured_car_info.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;

import "../../../../model/account/register_model.dart";
import "../../../../services/firebase/firestore.dart";


class AdminHome extends StatefulWidget {
  final PersistentTabController controller;

  const AdminHome({super.key, required this.controller});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late Future<List<List<String>>> weatherFuture;
  HomeController homeController = HomeController();
  late OpenAI openAI;
  final _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  RegisterModel? _currentUserInfo;



  Future<void> _fetchUserInfo() async {
    // Fetch the user information asynchronously
    _currentUserInfo = await Firestore().getUserInfo(FirebaseAuth.instance.currentUser!.uid);

    // Update the UI after data is fetched
    setState(() {
      // Set the fetched data
      _currentUserInfo = _currentUserInfo;
    });
  }

  // Function to send a message
  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      setState(() {
        _messages.add({'user': userMessage, 'response': 'Thinking...'});
      });

      // Create the request
      final request = ChatCompleteText(
        messages: [
          Messages(role: Role.user, content: userMessage).toJson(),
        ],
        maxToken: 200,
        model: Gpt4oMini2024ChatModel(),
      );

      // Get the response
      ChatCTResponse? response = await openAI.onChatCompletion(request: request);
      String botResponse = response?.choices.first.message?.content ?? 'No response';
      debugPrint("AI response: $botResponse");

      // Update the message with the response
      setState(() {
        _messages.last['response'] = botResponse;
      });

      _controller.clear(); // Clear the text field
    }
  }

  Widget displayBottomSheetChatBot(BuildContext context, StateSetter updateModalState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // Adjust height as needed
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Start from the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // User message (right aligned)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                message['user']!,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      // Bot response (left aligned)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                message['response']!,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input field at the bottom of the screen
          Padding(
            padding: MediaQuery.of(context).viewInsets, // Prevents keyboard overlap
            child: _buildInputField(updateModalState),
          ),
          const SizedBox(height: 150)
        ],
      ),
    );
  }

  // Input field for sending messages
  Widget _buildInputField(StateSetter updateModalState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter your prompt...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onSubmitted: (_) => _sendMessage(), // Trigger message send on submission
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _sendMessage(), // Trigger message send on button press
          ),
        ],
      ),
    );
  }




























  @override
  void initState() {
    super.initState();
    // Initialize the future directly in initState
    weatherFuture = homeController.getWeatherForecast();

    try {
      //  chatgpt
      openAI = OpenAI.instance.build(
        token: Constants.CHAT_GPT_SECRET_KEY, // Replace with your OpenAI API
        baseOption: HttpSetup(
          receiveTimeout: Duration(seconds: 20),
          connectTimeout: Duration(seconds: 20),
        ),
        enableLog: true,
      );
    } catch(e) {
      debugPrint("ChatGPT error: ${e.toString()}");
    }

    // Optionally, show the opening banner after initializing the future
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.showOpeningBanner(context);
      debugPrint("User type - ${PersistentData().userType}");
    });

    try {
      _fetchUserInfo();
    } catch(e) {
      debugPrint("main_home-fetchUserInfo error: ${e.toString()}");
    }
  }

  Widget weatherWidget() {
    return FutureBuilder<List<List<String>>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // LoadingDialog().show(context: context, content: "Retrieving weather data from the database");

            return const Center(
              child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4.0,
                  )),
            );
          } else {
            // Dismiss the loading dialog when data is ready or error occurs
            // LoadingDialog().dismiss();

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No weather data available'));
            } else {
              List<List<String>> weatherData = snapshot.data!;

              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomComponents.displayText(
                          weatherData[index][0],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        Image.network(
                          "http://openweathermap.org/img/wn/${weatherData[index][3]}@4x.png",
                          width: MediaQuery.of(context).size.width / 4 - 15,
                        ),
                        CustomComponents.displayText(
                          "${weatherData[index][1].split(".")[0]} ${ProjectStrings.admin_home_weather_temp_placeholder}",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        CustomComponents.displayText(
                          "${weatherData[index][2].split(".")[0]}${ProjectStrings.admin_home_weather_wind_placeholder}",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ],
                    );
                  }));
            }
          }
        });
  }

  Future<void> _refreshPage() async {
    // Fetch new data and update the UI
    homeController.fetchCars();
    CustomComponents.showToastMessage("Page refreshed", Colors.black54, Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    //  manage name
    String manageTextIfDriver = PersistentData().userType == "Driver" ? ProjectStrings.driver_apply : ProjectStrings.admin_home_top_options_manage;
    InfoDialog().dismissBoolean();

    return PopScope(
      canPop: false,
      child: Center(
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
          child: Container(
            color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
                radix: 16)),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  //  Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "lib/assets/pictures/app_logo_circle.png",
                          width: 120.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 30, left: 30),
                            child: CustomComponents.displayText(
                              PersistentData().userType,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomComponents.displayText("Hello, ${_currentUserInfo?.role}",
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              CustomComponents.displayText(
                                "PH ${_currentUserInfo?.number}",
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: Colors.grey
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            "lib/assets/pictures/home_top_image.png",
                            fit: BoxFit
                                .contain, // Ensure the image fits within its container
                          ),
                        ),
                      ],
                    ),
                  ),

                  //  Top options
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        //  inquire
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                widget.controller.jumpToTab(1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white38,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "lib/assets/pictures/home_logo_inquire.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: CustomComponents.displayText(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          ProjectStrings
                                              .admin_home_top_options_inquire,
                                          color: Color(int.parse(
                                              ProjectColors.darkGray.substring(2),
                                              radix: 16)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //  contact
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                homeController.showContactBottomDialog(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white38,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "lib/assets/pictures/home_top_contact.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: CustomComponents.displayText(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          ProjectStrings
                                              .admin_home_top_options_contact,
                                          color: Color(int.parse(
                                              ProjectColors.darkGray.substring(2),
                                              radix: 16)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //  report
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed("to_report");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white38,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "lib/assets/pictures/home_top_report.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: CustomComponents.displayText(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          ProjectStrings
                                              .admin_home_top_options_report,
                                          color: Color(int.parse(
                                              ProjectColors.darkGray.substring(2),
                                              radix: 16)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //  AI chatbot
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setModalState) {
                                        return displayBottomSheetChatBot(context, setModalState);
                                      },
                                    );
                                  }
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white38,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "lib/assets/pictures/home_top_settings.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: CustomComponents.displayText(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          ProjectStrings
                                              .admin_home_top_options_settings,
                                          color: Color(int.parse(
                                              ProjectColors.darkGray.substring(2),
                                              radix: 16)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //  manage
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                homeController.topOptionManageAccessibility(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white38,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "lib/assets/pictures/home_top_manage.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: CustomComponents.displayText(
                                          manageTextIfDriver,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: Color(int.parse(
                                              ProjectColors.darkGray.substring(2),
                                              radix: 16)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        //  Weather
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.admin_home_weather_header,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              CustomComponents.displayText(
                                "${ProjectStrings.admin_home_weather_date_placeholder} ${HomeController().getCurrentDate()}",
                                color: Color(int.parse(
                                    ProjectColors.lightGray.substring(2),
                                    radix: 16)),
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    ProjectColors.mainColorHex.substring(2),
                                    radix: 16)),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: weatherWidget()
                              )
                          ),
                        ),
                        //  Featured
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.admin_home_featured_header,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("car_list");
                                },
                                child: CustomComponents.displayText(
                                  ProjectStrings.admin_home_featured_see_all,
                                  color: Color(int.parse(
                                      ProjectColors.mainColorHex.substring(2),
                                      radix: 16)),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: SizedBox(
                            height: 190.0, // Set a specific height
                            child: FutureBuilder<List<FeaturedCarInfo>>(
                              future: homeController.fetchCars(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator()); // Loading indicator
                                } else if (snapshot.hasError) {
                                  return const Center(child: Text('Error loading cars')); // Error handling
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No cars available')); // No data handling
                                }

                                List<FeaturedCarInfo> cars = snapshot.data!;
                                //  sort the list by car_rent_count in descending order
                                cars.sort((a, b) => b.rentCount.compareTo(a.rentCount));
                                List<FeaturedCarInfo> topThreeCars = cars.take(3).toList();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topThreeCars.length,
                                  itemBuilder: (context, index) {
                                    FeaturedCarInfo car = topThreeCars[index];

                                    return featuredItemUI(
                                      imageUrl: car.mainPicUrl,
                                      carName: car.name,
                                      transmission: car.transmission,
                                      mileage: car.mileage,
                                      price: car.price,
                                      capacity: car.capacity,
                                      carInfo: car
                                    );
                                  },
                                );
                              }
                            ),
                          ),
                        ),
                        //  Banner
                        const SizedBox(height: 20),
                        Container(
                          color: Colors.grey[300],
                          width: double.infinity,
                          height: 200,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomComponents.displayText(
                                      ProjectStrings.admin_home_banner_header,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 125,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 25),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 290,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child: Image.asset(
                                              "lib/assets/pictures/home_bottom_banner_1.jpg",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 290,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child: Image.asset(
                                              "lib/assets/pictures/home_bottom_banner_2.jpg",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 290,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child: Image.asset(
                                              "lib/assets/pictures/home_bottom_banner_3.jpg",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 40)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget featuredItemUI({
    required String imageUrl,
    required String carName,
    required String transmission,
    required String mileage,
    required String price,
    required String capacity,
    required FeaturedCarInfo carInfo
  }) {
    String fullUrl = 'https://firebasestorage.googleapis.com/v0/b/dara-renting-app.appspot.com/o/${Uri.encodeComponent(imageUrl)}?alt=media';

    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Container(
        width:
        250, // Set a specific width to your container
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      fullUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Image not found'));
                      })
                ),
              ),
              CustomComponents.displayText(
                carName,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  CustomComponents.displayText(
                    "$capacity seaters",
                    fontSize: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                    child: Container(
                      width: 1,
                      height: 10,
                      color: Colors.grey,
                    ),
                  ),
                  CustomComponents.displayText(
                    mileage,
                    fontSize: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                    child: Container(
                      width: 1,
                      height: 10,
                      color: Colors.grey,
                    ),
                  ),
                  CustomComponents.displayText(
                    transmission,
                    fontSize: 10,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.displayText(
                      "$price PHP",
                      fontWeight: FontWeight.w600,
                      color: Color(int.parse(
                          ProjectColors.mainColorHex
                              .substring(2),
                          radix: 16)),
                      fontSize: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        PersistentData().selectedCarItem = CompleteCarInfo(
                            carType: carInfo.carType,
                            transmission: carInfo.transmission,
                            totalEarnings: carInfo.totalEarnings,
                            rentCount: carInfo.rentCount,
                            price: carInfo.price,
                            name: carInfo.name,
                            mileage: carInfo.mileage,
                            pic5Url: carInfo.pic5Url,
                            pic4Url: carInfo.pic4Url,
                            pic3Url: carInfo.pic3Url,
                            pic2Url: carInfo.pic2Url,
                            pic1Url: carInfo.pic1Url,
                            mainPicUrl: carInfo.mainPicUrl,
                            availability: carInfo.availability,
                            capacity: carInfo.capacity,
                            color: carInfo.color,
                            engine: carInfo.engine,
                            fuel: carInfo.fuel,
                            fuelVariant: carInfo.fuelVariant,
                            horsePower: carInfo.horsePower,
                            longDescription: carInfo.longDescription,
                            shortDescription: carInfo.shortDescription
                        );
                        Navigator.of(context).pushNamed("selected_item");
                      },
                      child: Icon(
                        Icons.list,
                        color: Color(int.parse(
                            ProjectColors.lightGray
                                .substring(2),
                            radix: 16)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
