import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/about/Widget/contact_us.dart';
import 'package:omnitrics_thesis/about/Widget/drawer_header.dart';
import 'package:omnitrics_thesis/about/Widget/faqs.dart';
import 'package:omnitrics_thesis/about/Widget/privacy_policy.dart';
import 'package:omnitrics_thesis/about/Widget/share_app.dart';
import 'package:path/path.dart';

Drawer drawerHome(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        drawerHeader(),
        privacyPolicy(context),
        contactUs(),
        shareApp(),
        faqS(),
      ],
    ),
  );
}