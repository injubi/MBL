import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mbl/screen/home_screen.dart';

const DEFAULT_COLORS = [
  // 빨강
  'F44336',
  // 주황
  'FF9800',
  // 노랑
  'FFEB3B',
  // 초록
  'FCAF50',
  // 파랑
  '2196F3',
  // 남
  '3F51B5',
  // 보라
  '9C27B0',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  // final database = LocalDatabase();
  //
  // GetIt.I.registerSingleton<LocalDatabase>(database);

  // final colors = await database.getCategoryColors();
  //
  // if (colors.isEmpty) {
  //   for (String hexCode in DEFAULT_COLORS) {
  //     await database.createCategoryColor(
  //       CategoryColorsCompanion(
  //         hexCode: Value(hexCode),
  //       ),
  //     );
  //   }
  // }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    ),
  );
}
