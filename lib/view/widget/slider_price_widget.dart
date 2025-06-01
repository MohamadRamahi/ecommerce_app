import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class SliderPriceWidget extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final RangeValues initialRange;
  final void Function(RangeValues) onChanged;

  const SliderPriceWidget({
    super.key,
    this.minValue = 0,
    this.maxValue = 10000,
    required this.initialRange,
    required this.onChanged,
  });

  @override
  _SliderPriceWidgetState createState() => _SliderPriceWidgetState();
}

class _SliderPriceWidgetState extends State<SliderPriceWidget> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: responsiveWidth(context, 18),
              ),
            ),
            Text(
              '\$${_currentRangeValues.start.round()} - \$${_currentRangeValues.end.round()}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: responsiveWidth(context, 18),
              ),
            ),
          ],
        ),

        SizedBox(height: responsiveHeight(context, 10)),

        /// RangeSlider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.white,
            trackHeight: responsiveHeight(context, 5),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: responsiveWidth(context, 5),
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: responsiveWidth(context, 14),
            ),
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: 100,
            labels: RangeLabels(
              '\$${_currentRangeValues.start.round()}',
              '\$${_currentRangeValues.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
              widget.onChanged(values); // Notify parent
            },
          ),
        ),
      ],
    );
  }
}
