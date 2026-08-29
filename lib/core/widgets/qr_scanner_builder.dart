import 'package:flutter/widgets.dart';

typedef QrScannerBuilder =
    Widget Function(BuildContext context, void Function(String code) onDetect);
