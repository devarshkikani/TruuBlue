import 'package:dating/theme/textstyle.dart';
import 'package:flutter/material.dart';

SizedBox sizedBox5 = SizedBox(
  height: 5,
);

SizedBox sizedBox10 = SizedBox(
  height: 10,
);

SizedBox sizedBox15 = SizedBox(
  height: 15,
);

SizedBox sizedBox20 = SizedBox(
  height: 20,
);

SizedBox sizedBox25 = SizedBox(
  height: 25,
);

SizedBox sizedBox30 = SizedBox(
  height: 30,
);

Widget rowDottedWidget(String text, {int? index}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        index != null ? '  $index.  ' : '  •  ',
        style: index != null ? regualrText14 : boldText16,
      ),
      Expanded(
        child: Text(
          text,
          style: regualrText14,
        ),
      ),
    ],
  );
}

Widget rowAlfaWidget(String text, {String? index}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        index != null ? '  $index  ' : '  •  ',
        style: index != null ? regualrText14 : boldText16,
      ),
      Expanded(
        child: Text(
          text,
          style: regualrText14,
        ),
      ),
    ],
  );
}
