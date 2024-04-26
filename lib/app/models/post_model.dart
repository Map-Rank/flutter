import 'dart:io';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'parents/model.dart';

class Post extends Model {
  String? content;
  String? publishedDate;
  var zone;
  var zonePostId;
  var sectorPostId;
  int? postId;
  List? sectors;
  List? imagesUrl;
  int? commentCount;
  int? shareCount;
  int? likeCount;
  User? user;
  List? imagesFilePaths;

  Post({this.postId,
    this.publishedDate,
    this.zone,
    this. sectors,
    this.imagesUrl,
    this.content,
    this.user,
    this.likeCount,
    this.shareCount,
    this.commentCount,
    this.zonePostId,
    this.sectorPostId,
    this.imagesFilePaths
  });

  Post.fromJson(Map<String, dynamic> json) {
    content = stringFromJson(json, 'content');
    postId = intFromJson(json, 'id');
    publishedDate = stringFromJson(json, 'published_at');




    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = postId;
    data['content'] = content;
    data['zone_id'] = zone;
    data['published_at'] = publishedDate;
    //data['sectors'] = sectors;


    return data;
  }

}
