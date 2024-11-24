import 'dart:io';

import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/services/gcash/gcash_payment.dart';
import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/loading.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class RentProcess {
  File? _selectedImage;
  String _imageName = ProjectStrings.rp_details_fees_proof_payment_image_notice;

  void startGcashPayment(BuildContext context, double amount) {
    gcashPayment(context, amount);
  }

  Future<void> _pickImage(BuildContext context, String imageName) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Use a method to update the state of your widget
      _selectedImage = File(image.path);
      _imageName = image.name;

      // Rebuild the bottom sheet with updated image
      Navigator.pop(context); // Close the current bottom sheet
      showUploadPhotoBottomDialog(context, imageName); // Re-open with updated state
    }
  }

  Future<void> showUploadPhotoBottomDialog(BuildContext context, String imageName) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomComponents.displayText(
                ProjectStrings.rp_details_fees_proof_payment,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              CustomComponents.displayText(
                ProjectStrings.rp_details_fees_proof_payment_subheader,
                fontSize: 10,
              ),

              const SizedBox(height: 15),
              CustomComponents.displayText(
                ProjectStrings.rp_details_fees_proof_payment_gcash,
                fontSize: 10,
                fontWeight: FontWeight.bold
              ),
              const SizedBox(height: 5),
              CustomComponents.displayText(
                ProjectStrings.rp_details_fees_proof_payment_gcash_name,
                fontSize: 10
              ),
              const SizedBox(height: 3),
              CustomComponents.displayText(
                ProjectStrings.rp_details_fees_proof_payment_gcash_number,
                fontSize: 10
              ),

              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => _pickImage(context, imageName),
                child: _uploadPhoto(),
              ),
              const SizedBox(height: 10),
              CustomComponents.displayText(
                _imageName,
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
              ),

              //  proceed button
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Color(
                            int.parse(ProjectColors.mainColorHex.substring(2),
                                radix: 16))),
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)))),
                    onPressed: () async {
                      try {
                        LoadingDialog().show(
                          context: context,
                          content: "Please wait while we upload your selected photo.",
                        );
                        await _uploadImageToFirebase(imageName);
                        PersistentData().gcashAlternativeImagePath = imageName;
                        LoadingDialog().dismiss();
                        debugPrint("GcashAlternativeImage-Path: ${PersistentData().gcashAlternativeImagePath}");
                        Navigator.of(context).pushNamed("rp_submit_documents");
                      } catch(e) {
                        LoadingDialog().dismiss();
                        CustomComponents.showToastMessage("An error occurred while trying to upload your image", Colors.red, Colors.white);
                        debugPrint("An error occurred@rent_process.dart@showUploadPhotoBottomDialog()");
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: CustomComponents.displayText(
                            ProjectStrings.ps_proceed_button,
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),

              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImageToFirebase(String imageName) async {
    try {
      final String fileName = imageName;

      final Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      await storageReference.putFile(_selectedImage!);
    } catch (e) {
      debugPrint("Error uploading image: $e");
    }
  }

  Widget _uploadPhoto() {
    return Container(
        decoration: BoxDecoration(
          border: DashedBorder.fromBorderSide(
            dashLength: 4,
            side: BorderSide(
              color: Color(int.parse(ProjectColors.userInfoDialogBrokenLinesColor.substring(2), radix: 16)),
              width: 1,
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SizedBox(
            width: 60,
            height: 60,
            child: _selectedImage == null
                ? Image.asset(
                    "lib/assets/pictures/user_info_upload.png",
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );
  }
}
