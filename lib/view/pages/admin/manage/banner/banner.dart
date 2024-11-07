import "dart:io";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:image_picker/image_picker.dart";
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
  List<String> popupImageUrls = [];
  List<String> promoImageUrls = [];
  List<String> itemsToBeDisplayed = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    setState(() => _isLoading = true);
    try {
      popupImageUrls.clear();
      promoImageUrls.clear();
      itemsToBeDisplayed.clear();

      final popupRef = FirebaseStorage.instance.ref().child('banner_popups');
      final promoRef = FirebaseStorage.instance.ref().child('banner_promos');

      final ListResult popupResult = await popupRef.listAll();
      final ListResult promoResult = await promoRef.listAll();

      for (var ref in popupResult.items) {
        popupImageUrls.add(await ref.getDownloadURL());
      }
      for (var ref in promoResult.items) {
        promoImageUrls.add(await ref.getDownloadURL());
      }

      setState(() {
        itemsToBeDisplayed = _currentSelectedIndex == 0 ? promoImageUrls : popupImageUrls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Failed to load images: $e");
    }
  }

  Future<void> addPhoto() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      Fluttertoast.showToast(msg: "No image selected.");
      return;
    }

    setState(() => _isLoading = true);
    final File imageFile = File(pickedFile.path);
    final String folderName = _currentSelectedIndex == 0 ? 'banner_promos' : 'banner_popups';
    final storageRef = FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

    try {
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        if (_currentSelectedIndex == 0) {
          promoImageUrls.add(downloadUrl);
        } else {
          popupImageUrls.add(downloadUrl);
        }
        itemsToBeDisplayed.add(downloadUrl);
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Image uploaded successfully!");
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: "Failed to upload image: $e");
    }
  }

  Future<void> removePhoto(String imageUrl) async {
    setState(() => _isLoading = true);
    final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

    try {
      await storageRef.delete();
      setState(() {
        if (_currentSelectedIndex == 0) {
          promoImageUrls.remove(imageUrl);
        } else {
          popupImageUrls.remove(imageUrl);
        }
        itemsToBeDisplayed.remove(imageUrl);
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Image deleted successfully!");
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: "Failed to delete image: $e");
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
              sectionHeader("Manage Promotional Banners", "Control app promos and visual pop-ups"),
              const SizedBox(height: 15),
              switchOption(),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    onRefresh: fetchImages,
                    child: listItemsPictures(),
                  ),
                ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.centerLeft, child: CustomComponents.displayText(title, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 3),
          CustomComponents.displayText(subtitle, fontSize: 10),
        ],
      ),
    );
  }

  Widget listItemsPictures() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: itemsToBeDisplayed.length,
        itemBuilder: (BuildContext context, int index) {
          final currentImage = itemsToBeDisplayed[index];
          return imageItem(currentImage);
        },
      ),
    );
  }

  Widget imageItem(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        height: _currentSelectedIndex == 1 ? 400 : 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentSelectedIndex == 0) optionIcon(Icons.photo, "Add Photo", addPhoto),
                  if (_currentSelectedIndex == 0) const SizedBox(width: 40),
                  optionIcon(_currentSelectedIndex == 0 ? Icons.delete : Icons.photo, "${_currentSelectedIndex == 0 ? "Delete" : "Replace"} Photo", () => _currentSelectedIndex == 0
                      ? InfoDialog().showDecoratedTwoOptionsDialog(
                      context: context,
                      header: "Confirm action",
                      content: "Are you sure you want to delete this promo photo?",
                      confirmAction: () async {
                        await removePhoto(imageUrl);
                      }
                    ) : replacePhoto(imageUrl)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> replacePhoto(String oldImageUrl) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      Fluttertoast.showToast(msg: "No image selected for replacement.");
      return;
    }

    setState(() => _isLoading = true);
    final File imageFile = File(pickedFile.path);
    final String folderName = 'banner_popups';
    final storageRef = FirebaseStorage.instance.ref().child(folderName).child("${DateTime.now().millisecondsSinceEpoch}.jpg");

    try {
      // Delete the old image first
      final oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
      await oldImageRef.delete();

      // Upload the new image
      await storageRef.putFile(imageFile);
      final newDownloadUrl = await storageRef.getDownloadURL();

      setState(() {
        final index = popupImageUrls.indexOf(oldImageUrl);
        if (index != -1) {
          popupImageUrls[index] = newDownloadUrl;
          itemsToBeDisplayed[index] = newDownloadUrl;
          PersistentData().popupImageUrls[0] = newDownloadUrl;
        }
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Image replaced successfully!");
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: "Failed to replace image: $e");
    }
  }

  Widget optionIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 25),
          const SizedBox(height: 7),
          CustomComponents.displayText(label, fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget switchOption() {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      onSelect: (index) {
        setState(() {
          _currentSelectedIndex = index;
          itemsToBeDisplayed = index == 0 ? promoImageUrls : popupImageUrls;
        });
      },
      children: [
        CustomComponents.displayText("Promos / Offerings", color: Color(int.parse(ProjectColors.mainColorHex)), fontSize: 12, fontWeight: FontWeight.w600),
        CustomComponents.displayText("Pop-Ups", color: Color(int.parse(ProjectColors.mainColorHex)), fontSize: 12, fontWeight: FontWeight.w600),
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
            onTap: () => PersistentData().openDrawer(0),
            child: Padding(padding: const EdgeInsets.all(20.0), child: Image.asset("lib/assets/pictures/menu.png")),
          ),
          CustomComponents.displayText("App Banners", fontWeight: FontWeight.bold),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
