import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tropical_iptv_ios/firebase_options.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/auth/auth_bloc.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/live_caty/live_caty_bloc.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/series_caty/series_caty_bloc.dart';
import 'package:tropical_iptv_ios/presentation/screens/login_screen.dart';
import 'package:tropical_iptv_ios/presentation/screens/home_screen.dart';
import 'package:tropical_iptv_ios/presentation/screens/welcome_screen.dart';
import 'package:tropical_iptv_ios/presentation/screens/server_selection_screen.dart';
import 'package:tropical_iptv_ios/presentation/screens/live/live_tv_screen_v2.dart';
import 'package:tropical_iptv_ios/presentation/screens/movies/movies_screen.dart';
import 'package:tropical_iptv_ios/presentation/screens/series/series_screen.dart';
import 'package:tropical_iptv_ios/presentation/screens/player/video_player_screen.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/firebase/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (only on mobile platforms)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization skipped (web platform): $e');
  }

  // Initialize GetStorage
  await GetStorage.init();
  await GetStorage.init("favorites");

  // Initialize Mobile Ads (only on mobile)
  if (showAds) {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      print('AdMob initialization skipped: $e');
    }
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MyApp(
      iptvApi: IpTvApi(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final IpTvApi iptvApi;

  const MyApp({
    super.key,
    required this.iptvApi,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheck()),
        ),
        BlocProvider<LiveCatyBloc>(
          create: (context) => LiveCatyBloc(iptvApi),
        ),
        BlocProvider<MovieCatyBloc>(
          create: (context) => MovieCatyBloc(iptvApi),
        ),
        BlocProvider<SeriesCatyBloc>(
          create: (context) => SeriesCatyBloc(iptvApi),
        ),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return GetMaterialApp(
            title: kAppName,
            debugShowCheckedModeBanner: false,
            theme: MyThemApp.themeData(context),
            initialRoute: screenSplash,
            getPages: [
              GetPage(
                name: screenSplash,
                page: () => const SplashScreen(),
              ),
              GetPage(
                name: screenLogin,
                page: () => const LoginScreen(),
              ),
              GetPage(
                name: '/home',
                page: () => const HomeScreen(),
              ),
              GetPage(
                name: '/welcome',
                page: () => const WelcomeScreen(),
              ),
              GetPage(
                name: '/server-selection',
                page: () {
                  final userData = Get.arguments as FireUserData?;
                  if (userData == null) {
                    // Se não houver userData, redireciona para login
                    Future.microtask(() => Get.offAllNamed(screenLogin));
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ServerSelectionScreen(userData: userData);
                },
              ),
              GetPage(
                name: '/live-tv',
                page: () => const LiveTvScreenV2(),
              ),
              GetPage(
                name: '/movies',
                page: () => const MoviesScreen(),
              ),
              GetPage(
                name: '/series',
                page: () => const SeriesScreen(),
              ),
              GetPage(
                name: '/player',
                page: () {
                  final args = Get.arguments as Map<String, dynamic>?;
                  if (args == null) {
                    Future.microtask(() => Get.back());
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return VideoPlayerScreen(
                    videoUrl: args['videoUrl'] as String,
                    title: args['title'] as String,
                    posterUrl: args['posterUrl'] as String?,
                  );
                },
              ),
              // Add more routes as screens are created
            ],
          );
        },
      ),
    );
  }
}

// Tropical Play Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(screenLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF1A1A1A), // Dark center
              Color(0xFF0F0F0F), // Darker mid
              Color(0xFF0A0A0A), // Deep black edge
            ],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kColorPrimary.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image fails to load
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              kColorPrimary,
                              kColorSecondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          size: 120,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Loading indicator with glow effect
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kColorPrimary.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    kColorPrimary,
                  ),
                  strokeWidth: 4,
                  backgroundColor: kColorElevated1,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Carregando...',
                style: TextStyle(
                  fontSize: 16,
                  color: kColorTextSecondary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
