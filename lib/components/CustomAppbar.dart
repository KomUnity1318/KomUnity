import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget pageTitle;
  final Widget? prvaIkonica;
  final Function? prvaIkonicaFunkcija;
  final Widget? drugaIkonica;
  final Function? drugaIkonicaFunkcija;
  final bool isCenter;

  CustomAppBar({
    required this.pageTitle,
    this.prvaIkonica,
    this.prvaIkonicaFunkcija,
    this.drugaIkonica,
    this.drugaIkonicaFunkcija,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return isCenter
        ? Container(
            padding: EdgeInsets.only(
              top: (medijakveri.size.height - medijakveri.padding.top) * 0.035,
              bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.012,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: () => prvaIkonicaFunkcija!(), child: prvaIkonica),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: medijakveri.size.width * 0.65,
                  ),
                  child: FittedBox(
                    child: pageTitle,
                  ),
                ),
                GestureDetector(onTap: () => drugaIkonicaFunkcija!(), child: drugaIkonica),
              ],
            ),
          )
        : Container(
            height: (medijakveri.size.height - medijakveri.padding.top) * 0.07,
            padding: EdgeInsets.only(
                // top: (medijakveri.size.height - medijakveri.padding.top) * 0.035,
                // bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.012,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (prvaIkonica != null)
                      Container(
                        child: prvaIkonica,
                      ),
                    if (prvaIkonica != null) SizedBox(width: 2),
                    Container(
                      child: pageTitle,
                    ),
                  ],
                ),
                if (drugaIkonica != null) GestureDetector(onTap: () => drugaIkonicaFunkcija!(), child: drugaIkonica),
              ],
            ),
          );
  }
}
