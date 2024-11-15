import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import "package:flutter/material.dart";

class CarouselPage4 extends StatelessWidget {
  const CarouselPage4({super.key});

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9 - 0.78,
                        child: Container(
                          width: constraints.maxWidth,
                          color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                        ),
                      ),
                      // Actual image
                      Image.asset(
                        "lib/assets/pictures/carousel_image_4.png",
                        width: constraints.maxWidth,
                      ),
                    ],
                  );
                },
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
                ],
              ),
            ),

            //  Header
            const SizedBox(height: 20),
            CustomComponents.displayText(
              ProjectStrings.carousel_4_header,
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),

            //  Body
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: CustomComponents.displayText(
                ProjectStrings.carousel_4_body,
                fontSize: 12,
                textAlign: TextAlign.center
              ),
            ),

            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items to the start and end of the row
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "entry_page_3");
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
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "entry_page_5");
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
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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