import 'package:flutter/material.dart';
import 'package:flutter_auth_app/domain/domain.dart';
import 'package:flutter_auth_app/presentation/presentation.dart';
import 'package:flutter_auth_app/utils/ext/context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart' hide log;

///*********************************************
/// Created by ukietux on 25/08/20 with ♥
/// (>’_’)> email : hey.mudassir@gmail.com
/// github : https://www.github.com/Lzyct <(’_’<)
///*********************************************
/// © 2020 | All Right Reserved

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.showDialog = true});
  final bool showDialog;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;
  final List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (_currentPage < _lastPage) {
            _currentPage++;
            await context
                .read<UsersCubit>()
                .fetchUsers(UsersParams(page: _currentPage));
          }
        }
      }
    });
    Future.delayed(
      Duration.zero,
      () => context.showInfoDialog(collectInfo()),
    );
  }

  // Future<void> _showDialog() async {
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => WillPopScope(
  //       onWillPop: () async => false,
  //       child: Material(color: Colors.transparent, child: collectInfo()),
  //     ),
  //   );
  // }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.

  @override
  Widget build(BuildContext context) {
    return Parent(
      child: RefreshIndicator(
        color: Theme.of(context).iconTheme.color,
        onRefresh: () {
          _currentPage = 1;
          _lastPage = 1;
          _users.clear();

          return context
              .read<UsersCubit>()
              .refreshUsers(UsersParams(page: _currentPage));
        },
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(4.0435, 39.6682),
            zoom: 9.2,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              // onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ),
      ),
    );
  }

  Widget collectInfo() {
    return SizedBox(
      // width: 300,
      height: 300,
      // color: Colors.white,
      child: PageView(
        controller: _pageController,
        children: [intro(), feedBack(), end()],
      ),
    );
  }

  Widget end() {
    return Container(
      // padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "THANK YOU",
            style: TextStyle(color: Palette.primary, fontSize: 21),
          ),
          SpacerV(
            value: Dimens.space16,
          ),
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check_box,
              size: 65,
              color: Colors.white,
            ).center(),
          ),
          SpacerV(
            value: Dimens.space12,
          ),
          Button(
            title: 'Done',
            onPressed: () => context.dismiss(),
          )
        ],
      ),
    );
  }

  Widget intro() {
    return Container(
      // padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "THE CLEAN BEACHES 🏖️",
            style: TextStyle(color: Palette.primary, fontSize: 21),
          ),
          SpacerV(
            value: Dimens.space16,
          ),
          const Text(
            "Clean beaches would like to take some information about your experience at the beach. Press next to participate.",
          ),
          SpacerV(
            value: Dimens.space12,
          ),
          Button(
            title: 'Next',
            onPressed: () => _pageController.animateToPage(
              1,
              duration: 500.milliseconds,
              curve: Curves.ease,
            ),
          )
        ],
      ),
    );
  }

  List<String> feedBackStrings = [
    "Too much litter",
    "Medium amount of litter",
    "Small amount of litter",
  ];
  String _selectedValue = "Too much litter";

  Widget feedBack() {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "YOUR FEEDBACK",
            style: TextStyle(color: Palette.primary, fontSize: 21),
          ),
          SpacerV(
            value: Dimens.space16,
          ),
          const Text(
            "Tell us what you think about the beach",
          ),
          SpacerV(
            value: Dimens.space12,
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                //<-- SEE HERE
                borderSide: BorderSide(width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                //<-- SEE HERE
                borderSide: BorderSide(width: 2),
              ),
              filled: true,
            ),
            value: _selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue!;
              });
            },
            items:
                feedBackStrings.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
          SpacerV(value: Dimens.space24),
          Button(
            title: 'Next',
            onPressed: () => _pageController.animateToPage(
              2,
              duration: 500.milliseconds,
              curve: Curves.easeIn,
            ),
          )
        ],
      ),
    );
  }
}
