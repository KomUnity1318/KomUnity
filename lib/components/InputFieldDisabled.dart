import 'package:flutter/material.dart';

class InputFieldDisabled extends StatelessWidget {
  final MediaQueryData medijakveri;
  final String label;
  final String text;
  final double borderRadijus;

  const InputFieldDisabled({
    super.key,
    required this.medijakveri,
    required this.label,
    required this.text,
    required this.borderRadijus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 8,
                  left: medijakveri.size.width * 0.02,
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.headlineMedium!,
                ),
              ),
            ],
          ),
          Container(
            height: 57,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadijus),
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.04),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
