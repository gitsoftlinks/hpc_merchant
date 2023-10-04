import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:flutter/material.dart';

import '../app/custom_widgets/custom_button.dart';

Future showPermissionDialog(t, void Function(BuildContext c) f) async {
  await showDialog(
      context: navigatorKeyGlobal.currentState!.context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.close),
                  )),
            ),
            Material(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      t,
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                          height: 45,
                          text: "Open Setting",
                          onPressed: () {
                            f(context);
                          }),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      });
}
