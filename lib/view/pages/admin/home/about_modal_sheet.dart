import 'package:dara_app/view/shared/components.dart';
import 'package:flutter/material.dart';

import '../../../shared/colors.dart';

class AboutModalSheet extends StatelessWidget {
  const AboutModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(150),
                      bottomLeft: Radius.circular(150),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Image.asset("lib/assets/pictures/about.png"),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: CustomComponents.displayText(
                "Don Al-pha Renting App",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
              child: CustomComponents.displayText(
                "App Version: v1.0",
                fontSize: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: CustomComponents.displayText(
                "We aim to provide an optimized, reliable, and affordable car rental experience. Whether for short-term trips or long-term rentals, our diverse fleet has you covered.",
                fontSize: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  CustomComponents.displayText(
                    "Developers",
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 5),
                  CustomComponents.displayText(
                    "Batch 2021. BSIT. Capstone - Group 20",
                    fontSize: 12,
                  ),
                  const SizedBox(height: 34),
                  CustomComponents.displayText(
                    "Affiliations",
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/about_dara.png",
                        height: 100,
                      ),
                      const SizedBox(width: 15),
                      Image.asset(
                        "lib/assets/pictures/about_ccc.png",
                        height: 100,
                      ),
                      const SizedBox(width: 15),
                      Image.asset(
                        "lib/assets/pictures/about_logo.png",
                        height: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  CustomComponents.displayText(
                    "© 2024 Don Al-pha Renting App. All rights reserved.",
                    fontSize: 10,
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}

void showAboutModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => const AboutModalSheet(),
  );
}
