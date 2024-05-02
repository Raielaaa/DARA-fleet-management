import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/strings.dart';
import "package:flutter/material.dart";

class CarouselPage6 extends StatelessWidget {
  const CarouselPage6({super.key});

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
            Image.asset(
              "lib/assets/pictures/carousel_image_1.png",
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 45,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 45,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 45,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 45,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 45,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 45,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DefaultTextStyle(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
                fontFamily: "SF Pro Display"
              ),
              child: Text(ProjectStrings.carousel_6_header),
            ),
            const SizedBox(height: 20),
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "SF Pro Display"
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(ProjectStrings.carousel_6_body),
              ),
            ),
            const SizedBox(height: 70),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100)
                  ),
                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 35,
                    left: 35
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "SF Pro Display"
                    ),
                    child: Text(ProjectStrings.carousel_next),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}