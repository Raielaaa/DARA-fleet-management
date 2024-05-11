import "package:flutter/material.dart";

Container termsAndCondition(BuildContext context) => Container(
  padding: const EdgeInsets.all(25),
  child: ListView(
    children: [
      Container(
        //  Back button
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "register_email_pass");
          },
          icon: const Icon(Icons.arrow_back),
          iconSize: 25.0, // desired size
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(), // override default min size of 48px
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    ],
  ),
);