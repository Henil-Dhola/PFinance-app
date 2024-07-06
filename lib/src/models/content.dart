import 'package:flutter/material.dart';

class UnbordingContent{
  String images;
  String title;
  String discription;

  UnbordingContent({required this.images,required this.title,required this.discription});
}
List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Security',
      images:'assets/image/12.png',
    discription: "Lorem ipsum dolor sit amet\n,consectetur adipiscing edit.",


  ),
  UnbordingContent(
      title: 'System',
      images:"assets/image/23.png",
      discription: "hello"
  ),
  UnbordingContent(
      title: 'Perspective',
      images:'assets/image/34.png',
      discription: "hy"
  ),
];