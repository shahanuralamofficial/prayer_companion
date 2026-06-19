import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrayerService {
  PrayerTimes getPrayerTimes({
    required double latitude,
    required double longitude,
    CalculationMethod method = CalculationMethod.muslimWorldLeague,
    Madhab madhab = Madhab.hanafi,
    DateTime? date,
  }) {
    Coordinates coordinates = Coordinates(latitude, longitude);
    CalculationParameters params = _getParametersForMethod(method);
    params.madhab = madhab;

    return PrayerTimes(
      coordinates: coordinates,
      date: date ?? DateTime.now(),
      calculationParameters: params,
      precision: true,
    );
  }

  CalculationParameters _getParametersForMethod(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.dubai:
        return CalculationMethodParameters.dubai();
      case CalculationMethod.egyptian:
        return CalculationMethodParameters.egyptian();
      case CalculationMethod.karachi:
        return CalculationMethodParameters.karachi();
      case CalculationMethod.kuwait:
        return CalculationMethodParameters.kuwait();
      case CalculationMethod.moonsightingCommittee:
        return CalculationMethodParameters.moonsightingCommittee();
      case CalculationMethod.morocco:
        return CalculationMethodParameters.morocco();
      case CalculationMethod.muslimWorldLeague:
        return CalculationMethodParameters.muslimWorldLeague();
      case CalculationMethod.northAmerica:
        return CalculationMethodParameters.northAmerica();
      case CalculationMethod.qatar:
        return CalculationMethodParameters.qatar();
      case CalculationMethod.singapore:
        return CalculationMethodParameters.singapore();
      case CalculationMethod.tehran:
        return CalculationMethodParameters.tehran();
      case CalculationMethod.turkiye:
        return CalculationMethodParameters.turkiye();
      case CalculationMethod.ummAlQura:
        return CalculationMethodParameters.ummAlQura();
      default:
        return CalculationMethodParameters.muslimWorldLeague();
    }
  }
}

final prayerServiceProvider = Provider((ref) => PrayerService());
