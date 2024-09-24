import 'package:beat/business/favorites.dart';
import 'package:beat/screens/home/home_screen.dart';
import 'package:beat/utils/colors.dart';
import 'package:beat/utils/slider_track_shape.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Favorites(),
      lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'beat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
          sliderTheme: SliderThemeData(
            trackShape: NoPaddingTrackShape(),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
          ),
          colorScheme: const ColorScheme.dark(
            primary: BeatColors.blue,
            secondary: Colors.blue,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
