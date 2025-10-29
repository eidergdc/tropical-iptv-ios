import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tropical_iptv_ios/repository/locale/locale.dart';
import 'package:tropical_iptv_ios/repository/models/category.dart';
import 'package:tropical_iptv_ios/repository/models/channel_live.dart';
import 'package:tropical_iptv_ios/repository/models/channel_movie.dart';
import 'package:tropical_iptv_ios/repository/models/channel_serie.dart';
import 'package:tropical_iptv_ios/repository/models/epg.dart';
import 'package:tropical_iptv_ios/repository/models/movie_detail.dart';
import 'package:tropical_iptv_ios/repository/models/serie_details.dart';
import 'package:tropical_iptv_ios/repository/models/user.dart';

part 'auth.dart';
part 'iptv.dart';

final Dio _dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ),
);
