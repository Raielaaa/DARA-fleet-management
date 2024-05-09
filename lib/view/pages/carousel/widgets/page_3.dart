import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import "package:flutter/material.dart";

class CarouselPage3 extends StatelessWidget {
  const CarouselPage3({super.key});

  @override
    Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xffe8ebf2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset(
                "lib/assets/pictures/carousel_image_3.png",
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomComponents.displayCarouselIndicator(
                    width: 25,
                    height: 5,
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16))
                  ),
                  const SizedBox(width: 10),
                  CustomComponents.displayCarouselIndicator(
                    width: 25,
                    height: 5,
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16))
                  ),
                  const SizedBox(width: 10),
                  CustomComponents.displayCarouselIndicator(
                    width: 25,
                    height: 5
                  ),
                  const SizedBox(width: 10),
                  CustomComponents.displayCarouselIndicator(
                    width: 25,
                    height: 5,
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16))
                  ),
                  const SizedBox(width: 10),
                  CustomComponents.displayCarouselIndicator(
                    width: 25,
                    height: 5,
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16))
                  ),
                  const SizedBox(width: 10),
                  CustomComponents.displayCarouselIndicator(
                    width: 25,
                    height: 5,
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16))
                  ),
                ],
              ),
            ),

            //  Header
            const SizedBox(height: 20),
            CustomComponents.displayText(
              ProjectStrings.carousel_3_header,
              fontWeight: FontWeight.bold,
              fontSize: 26
            ),

            //  Body
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomComponents.displayText(
                ProjectStrings.carousel_3_body,
                fontSize: 14,
                textAlign: TextAlign.center
              ),
            ),

            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items to the start and end of the row
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "entry_page_2");
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 35,
                          left: 35,
                        ),
                        child: CustomComponents.displayText(
                          ProjectStrings.general_back_button,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "entry_page_4");
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                        ),
                        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 35,
                          left: 35,
                        ),
                        child: CustomComponents.displayText(
                          ProjectStrings.general_next_button,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}