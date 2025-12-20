import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/constants/app_sizes.dart';
import 'package:weather_app/core/constants/app_strings.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';
import 'package:weather_app/features/weather/presentation/controllers/forecast_controller.dart';
import 'package:weather_app/features/weather/presentation/controllers/weather_controller.dart';
import 'package:weather_app/shared/controllers/language_controller.dart';
import 'package:weather_app/shared/controllers/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController controller = Get.find();
  final locale = Get.find<LanguageController>().locale.value.toLanguageTag();

  @override
  void initState() {
    super.initState();
    _initLocaleFormatting();
  }

  Future<void> _initLocaleFormatting() async {
    await initializeDateFormatting(locale, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), 
                  Theme.of(context).colorScheme.primary, 
                ],
              ),
            ),
            child: Column(
              children: [
                _searchBar(),
                const SizedBox(height: AppSizes.paddingL),
                Expanded(
                  child: _homeBody(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        prefixIcon: HeroIcon(HeroIcons.magnifyingGlass),
        hintText: AppStrings.enterCityName.tr,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius2XL),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: AppSizes.font5XL,
      ),
      onSubmitted: (_) => controller.loadWeatherByCity(),
    );
  }

  Widget _homeBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
            strokeWidth: 4,
          )
        );
      }

      if (controller.hasError.value && controller.weather.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                HeroIcons.exclamationCircle, 
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppSizes.iconMain, 
              ),
              const SizedBox(height: AppSizes.paddingL),
              Obx(() => Text(
                controller.errorMsg.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: AppSizes.fontXL,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: AppSizes.paddingS),
              ElevatedButton.icon(
                onPressed: () {},
                icon: HeroIcon(
                  HeroIcons.arrowPath,
                  color: Theme.of(context).colorScheme.secondary,
                  size: AppSizes.iconXL,
                ),
                label: Text(
                  AppStrings.tryAgain.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: AppSizes.fontL
                  ),
                ),
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        );
      }

      if (controller.weather.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                HeroIcons.exclamationTriangle, 
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppSizes.iconMain, 
              ),
              const SizedBox(height: AppSizes.paddingL),
              Text(
                AppStrings.noDataMsg.tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: AppSizes.fontXL,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingS),
              ElevatedButton.icon(
                onPressed: () {},
                icon: HeroIcon(
                  HeroIcons.mapPin,
                  color: Theme.of(context).colorScheme.secondary,
                  size: AppSizes.iconXL,
                  style: HeroIconStyle.solid,
                ),
                label: Text(
                  AppStrings.useMyLoc.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: AppSizes.fontL
                  ),
                ),
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => controller.loadWeatherByCity(),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _weatherCard(),
                  const SizedBox(height: AppSizes.paddingL),
                  _weatherDetail(),
                  const SizedBox(height: AppSizes.paddingL),
                  _forecast(),
                  const SizedBox(height: 80.0),
                  Text(
                    AppStrings.appVersion.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: AppSizes.fontL,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  _changeLanguageButton(),
                  const SizedBox(width: AppSizes.paddingS),
                  _changeThemeButton(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
  
  Widget _changeThemeButton() {
    final ThemeController themeController = Get.find();

    return GestureDetector(
      onTap: () => themeController.toggle(),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingXS),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: Obx(() {
          return HeroIcon(  
            themeController.themeMode.value == ThemeMode.dark
                ? HeroIcons.moon
                : HeroIcons.sun,
            color: Theme.of(context).colorScheme.onSurface,
            size: AppSizes.iconXL,
            style: HeroIconStyle.solid,
          );
        }),
      ),
    );
  }

  Widget _changeLanguageButton() {
    final LanguageController languageController = Get.find();

    return GestureDetector(
      onTap: () {
        final currentLang = Get.locale?.languageCode ?? 'en';

        Get.updateLocale(currentLang == 'id'
            ? Locale('en', 'US')
            : Locale('id', 'ID')
        );

        languageController.toggle();
        controller.loadWeatherByCity();
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingXS),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: HeroIcon(  
          HeroIcons.language,
          color: Theme.of(context).colorScheme.onSurface,
          size: AppSizes.iconXL,
          style: HeroIconStyle.solid,
        ),
      ),
    );
  }

  Widget _weatherCard() {
    final weather = controller.weather.value!;

    return SizedBox(
      width: AppSizes.screenWidth(context),
      height: AppSizes.screenHeight(context) * 0.3,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeroIcon(
                      HeroIcons.mapPin,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: AppSizes.iconXL,
                      style: HeroIconStyle.solid,
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Text(
                      weather.cityName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppSizes.radius2XL),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppStrings.weatherTitle.tr},',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: AppSizes.fontXL,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 64.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            weather.description.capitalize!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: AppSizes.fontL,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat.EEEE(locale).format(weather.dateTime),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: AppSizes.fontL,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMMM yyyy', locale).format(weather.dateTime),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: AppSizes.fontL,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: -(AppSizes.paddingM * 2),
            right: AppSizes.paddingXL * 2,
            child: Image.asset(
              'assets/icons/${weather.icon}.png',
              width: AppSizes.iconMain * 2,
              height: AppSizes.iconMain * 2
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherDetail() {
    final weather = controller.weather.value!;

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSizes.radius2XL),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.0,
            child: Column(
              children: [
                _detailItem(
                  'sunrise',
                  DateFormat.Hm().format(weather.sunrise),
                  AppStrings.sunrise.tr.capitalize!,
                ),
                const SizedBox(height: AppSizes.paddingL),
                _detailItem(
                  'wind',
                  '${weather.windSpeed} m/s',
                  AppStrings.windSpeed.tr.capitalize!,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Column(
              children: [
                _detailItem(
                  'humi',
                  '${weather.humidity}%',
                  AppStrings.humidity.tr.capitalize!,
                ),
                const SizedBox(height: AppSizes.paddingL),
                _detailItem(
                  'temp',
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  AppStrings.temperature.tr.capitalize!,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Column(
              children: [
                _detailItem(
                  'sunset',
                  DateFormat.Hm().format(weather.sunset),
                  AppStrings.sunset.tr.capitalize!,
                ),
                const SizedBox(height: AppSizes.paddingL),
                _detailItem(
                  'pressure',
                  '${weather.pressure} hPa',
                  AppStrings.pressure.tr.capitalize!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String name, String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Image.asset(
            'assets/icons/$name.png', 
            width: AppSizes.icon2XL,
            height: AppSizes.icon2XL,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: AppSizes.fontL
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _forecast() {
    final ForecastController forecastController = Get.find();

    return Obx(() {
      return Container(
        height: 300.0,
        padding: EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppSizes.radius2XL),
        ),
        child: Column(
          children: [
            Text(
              AppStrings.forecastTitle.tr.capitalize!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: forecastController.forecast.length,
                itemBuilder: (context, index) {
                  final item = forecastController.forecast[index];
              
                  return _forecastCard(item);
                }, 
                separatorBuilder: (_, _) => VerticalDivider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 2,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _forecastCard(Forecast item) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingL,
        horizontal: AppSizes.paddingM
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: AppSizes.paddingXS,
            children: [
              Text(
                DateFormat.d().format(item.dateTime),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppSizes.font5XL,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: AppSizes.paddingL,
                height: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Text(
                DateFormat.Hm().format(item.dateTime),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppSizes.fontL,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/icons/${item.icon}.png',
            width: AppSizes.iconL * 2,
            height: AppSizes.iconL * 2,
          ),
          Text(
            '${item.temperature.toStringAsFixed(0)}°C',
              style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppSizes.fontL,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
