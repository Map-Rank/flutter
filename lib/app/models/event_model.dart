import 'dart:io';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'parents/model.dart';

class Event extends Model {
  String? content;
  String? title;
  String? organizer;
  String? publishedDate;
  String? startDate;
  String? endDate;
  var zone;
  var zoneEventId;
  var eventSectors;
  var zoneLevelId;
  var zoneParentId;
  int? eventId;
  var sectors;
  String? imagesUrl;
  int? eventCreatorId;
  List? imagesFileBanner;


  Event({this.eventId,
    this.publishedDate,
    this.title,
    this.zone,
    this. sectors,
    this.imagesUrl,
    this.content,
    this.eventCreatorId,
    this.organizer,
    this.zoneEventId,
    this.eventSectors,
    this.imagesFileBanner,
    this.startDate,
    this.endDate,
    this.zoneParentId,
    this.zoneLevelId,
  });

  Event.fromJson(Map<String, dynamic> json) {
    content = stringFromJson(json, 'content');
    eventId = intFromJson(json, 'id');
    zoneEventId = intFromJson(json, 'zone_id');
    publishedDate = stringFromJson(json, 'published_at');




    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = eventId;
    data['content'] = content;
    data['zone_id'] = zoneEventId;
    data['published_at'] = publishedDate;
    //data['sectors'] = sectors;


    return data;
  }

}
