import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  final double? height;
  final double? width;
  const Logo({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image.asset(
        //   'assets/icon/icon.png',
        //   height: height ?? 130,
        //   width: width ?? 130,
        // ),
        SvgPicture.asset(
          'assets/icon/wallet.svg',
          height: height ?? 130,
          width: width ?? 130,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "WhereDidISpend?",
          style: GoogleFonts.openSans(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
