import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final Color? backgroundColor, textColor;
  final bool isBorder;
  final double visina;
  final double? fontsize;
  final double? sirina;
  final double okoTeksta;
  final double borderRadius;
  final Function funkcija;
  final Widget? icon;

  Button({
    required this.buttonText,
    required this.borderRadius,
    required this.visina,
    required this.backgroundColor,
    required this.isBorder,
    required this.funkcija,
    this.fontsize,
    this.sirina,
    this.textColor = Colors.white,
    this.icon,
    this.okoTeksta = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => funkcija(),
      child: Container(
        width: sirina,
        padding: EdgeInsets.symmetric(
          vertical: visina,
          horizontal: okoTeksta,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              offset: Offset(1, 2),
              blurRadius: 4,
              spreadRadius: -3,
              blurStyle: BlurStyle.normal,
            ),
          ],
          color: backgroundColor,
          border: Border.all(
            color: isBorder ? Theme.of(context).primaryColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 10),
            Text(
              buttonText,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    // fontWeight: FontWeight.w600,
                    fontSize: fontsize ?? 20,
                    color: textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
