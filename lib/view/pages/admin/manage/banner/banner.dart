import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:slide_switcher/slide_switcher.dart";
import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/loading.dart";
import "../../../../shared/strings.dart";

class ManageBanner extends StatefulWidget {
  const ManageBanner({super.key});

  @override
  State<ManageBanner> createState() => _ManageBannerState();
}

class _ManageBannerState extends State<ManageBanner> {
  int _currentSelectedIndex = 0;
  // Create a list to hold the image URLs
  List<String> popupImageUrls = [];
  List<String> promoImageUrls = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      // Fetch images from banner_popups
      final popupRef = FirebaseStorage.instance.ref().child('banner_popups');
      final ListResult popupResult = await popupRef.listAll();
      for (var ref in popupResult.items) {
        final String url = await ref.getDownloadURL();
        popupImageUrls.add(url);
      }

      // Fetch images from banner_promos
      final promoRef = FirebaseStorage.instance.ref().child('banner_promos');
      final ListResult promoResult = await promoRef.listAll();
      for (var ref in promoResult.items) {
        final String url = await ref.getDownloadURL();
        promoImageUrls.add(url);
      }

      // Update the UI
      setState(() {});
    } catch (e) {
      debugPrint("Failed to load images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              appBar(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText("Manage Promotional Banners",
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      "Control app promos and visual pop-ups", fontSize: 10),
                ),
              ),
              const SizedBox(height: 15),
              switchOption(),
              const SizedBox(height: 15),
              ///
              const SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }

  Widget switchOption() {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [
        Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
      ],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      onSelect: (index) {
        _currentSelectedIndex = index;
        // _updateListToBeDisplayed();
      },
      children: [
        CustomComponents.displayText(
          "Promos / Offerings",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Pop-Ups",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }

  Widget appBar() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              PersistentData().openDrawer(0);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
          ),
          CustomComponents.displayText(
            "App Banners",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
