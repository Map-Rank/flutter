import 'dart:io';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'parents/model.dart';

class Post extends Model {
  String? content;
  String? publishedDate;
  var zone;
  var zonePostId;
  var postSectors;
  int? postId;
  List? sectors;
  List? imagesUrl;
  int? commentCount;
  int? shareCount;
  int? likeCount;
  bool? likeTapped;
  bool? commentTapped;
  bool? shareTapped;
  User? user;
  bool? liked;
  List? imagesFilePaths;
  List? commentList;

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
    this.postSectors,
    this.imagesFilePaths,
    this.liked,
    this.likeTapped,
    this.commentTapped,
    this.shareTapped,
    this.commentList
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
