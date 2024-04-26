import 'parents/model.dart';

class Setting extends Model {
  String? appName;
  String defaultTheme;
  String mainColor;
  String? mainDarkColor;
  String secondColor;
  String? secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String? scaffoldDarkColor;
  String? scaffoldColor;


  Setting(
      { this.appName,
        required this.mainColor,
        this.mainDarkColor,
        required this.secondColor,
        this.secondDarkColor,
        required this.accentColor,
        required this.accentDarkColor,
        required this.defaultTheme,
        this.scaffoldDarkColor,
        this.scaffoldColor,});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }


}
