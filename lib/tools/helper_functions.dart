import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

String getConversationID(String userID, String peerID) {
  return userID.hashCode <= peerID.hashCode
      ? userID + '_' + peerID
      : peerID + '_' + userID;
}

Widget getUserCircleAvatar(PersonalizedUser personalizedUser, double radius) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: personalizedUser.profilePicDownloadUrl == null
        ? personalizedUser.avatarBackgroundColor
        : null,
    child: personalizedUser.profilePicDownloadUrl == null
        ? Center(
            child: Text(
              personalizedUser.firstName[0],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        : CachedNetworkImage(
            imageUrl: personalizedUser.profilePicDownloadUrl!,
            imageBuilder: (context, imageProvider) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => new SpinKitFadingCircle(
                  color: Colors.white,
                  size: 40.0,
                ),
            errorWidget: (context, url, error) => new Icon(Icons.error)),
  );
}

String readTimestamp(String timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' day ago';
    } else {
      time = diff.inDays.toString() + ' days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' week ago ';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' weeks ago ';
    }
  }

  return time;
}
