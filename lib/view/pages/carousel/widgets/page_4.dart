import 'package:dara_app/view/shared/colors.dart';
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
              child: Image.asset(
                "lib/assets/pictures/carousel_image_4.png",
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
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
                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            DefaultTextStyle(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
                fontFamily: "SF Pro Display"
              ),
              child: Text(ProjectStrings.carousel_4_header, style: const TextStyle(color: Color.fromARGB(210, 0, 0, 0))),
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
                child: Text(ProjectStrings.carousel_4_body, style: const TextStyle(color: Color.fromARGB(200, 0, 0, 0))),
              ),
            ),
            const SizedBox(height: 70),
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
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SF Pro Display",
                          ),
                          child: Text(ProjectStrings.carousel_back),
                        ),
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
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SF Pro Display",
                          ),
                          child: Text(ProjectStrings.general_next_button),
                        ),
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