import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/size_config.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../injection.dart';
import '../../domain/usecases/set_user_open_app_before.dart';
import 'custom_indicator.dart';
import 'custom_page_view.dart';
import '../../../../routes/mobile_app_pages.dart';
import 'package:get/get.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({Key? key}) : super(key: key);

  @override
  _OnBoardingViewBodyState createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPageView(
          pageController: pageController,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: SizeConfig.defaultSize! * 24,
          child: CustomIndicator(
            dotIndex: pageController!.hasClients ? pageController?.page : 0,
          ),
        ),
        Visibility(
          visible: pageController!.hasClients
              ? (pageController?.page == 2 ? false : true)
              : true,
          child: Positioned(
            top: SizeConfig.defaultSize! * 10,
            right: 32,
            child: TextButton(
                onPressed: () {
                  getIt<SetUserOpenAppBefore>().call();
                  Get.offAndToNamed(MobileRoutes.LOGIN);
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.left,
                )),
          ),
        ),
        Positioned(
            left: SizeConfig.defaultSize! * 10,
            right: SizeConfig.defaultSize! * 10,
            bottom: SizeConfig.defaultSize! * 10,
            child: CustomGeneralButton(
              onTap: () {
                if (pageController!.page! < 2) {
                  pageController?.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                } else {
                  getIt<SetUserOpenAppBefore>().call();
                  Get.offAndToNamed(MobileRoutes.LOGIN);
                }
              },
              text: pageController!.hasClients
                  ? (pageController?.page == 2 ? 'Get started' : 'Next')
                  : 'Next',
            )),
      ],
    );
  }
}
