
import 'parents/model.dart';

class FeedbackModel extends Model {
  String? feedbackText;
  String? rating;
  var imageFile;


  FeedbackModel({this.rating, this.imageFile, this.feedbackText});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }



}
