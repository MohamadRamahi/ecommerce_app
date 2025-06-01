import 'package:ecommerce/model/filter_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/drop_dow_button.dart';
import 'package:ecommerce/view/widget/select_table_card_widget.dart';
import 'package:ecommerce/view/widget/slider_price_widget.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final void Function(FilterModel) onApplyFilter;

  const FilterWidget({super.key, required this.onApplyFilter});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();

}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedCategory = '';
  String selectedSize = 'M';
  double minPrice = 0;
  double maxPrice = 100;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveHeight(context, 52),
      width: responsiveWidth(context, 48),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: IconButton(
          onPressed: () => _showFilterBottomSheet(context),
          icon: const Icon(Icons.tune, color: Colors.white),
          padding: EdgeInsets.zero,
          iconSize: responsiveWidth(context, 24),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: responsiveHeight(context, 380),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: responsiveWidth(context, 24),
                vertical: responsiveHeight(context, 16),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: responsiveWidth(context, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, size: responsiveWidth(context, 24)),
                        ),
                      ],
                    ),

                    SizedBox(height: responsiveHeight(context, 16)),

                    /// Sort by Section
                    Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsiveHeight(context, 12)),

                    /// Category Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SelectableCard(
                            title: 'Relevance',
                            isSelected: selectedCategory == 'Relevance',
                            onTap: () => setModalState(() => selectedCategory = 'Relevance'),
                          ),
                          SizedBox(width: responsiveWidth(context, 10)),
                          SelectableCard(
                            title: 'Price:Low - High',
                            isSelected: selectedCategory == 'Price:Low - High',
                            onTap: () => setModalState(() => selectedCategory = 'Price:Low - High'),
                          ),
                          SizedBox(width: responsiveWidth(context, 10)),
                          SelectableCard(
                            title: 'Price:High - Low',
                            isSelected: selectedCategory == 'Price:High - Low',
                            onTap: () => setModalState(() => selectedCategory = 'Price:High - Low'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsiveWidth(context, 16),),
                    SliderPriceWidget(
                      initialRange: RangeValues(minPrice, maxPrice),
                      onChanged: (range) {
                        setModalState(() {
                          minPrice = range.start;
                          maxPrice = range.end;
                        });
                      },
                    ),
                    SizedBox(height: responsiveWidth(context, 16),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Size',
                          style: TextStyle(
                        fontSize: responsiveWidth(context, 20),
                         fontWeight: FontWeight.w600,
                        ),
                        ),
                        DropdownButtonCustom(),
                      ],
                    ),
                    SizedBox(height: responsiveHeight(context, 16),),

                    SizedBox(
                      height: responsiveHeight(context, 54),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedFilters = FilterModel(
                            sortBy: selectedCategory,
                            minPrice: minPrice,
                            maxPrice: maxPrice,
                            size: selectedSize,
                          );
                          widget.onApplyFilter(selectedFilters); // Pass filters up
                          Navigator.pop(context); // Close bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsiveWidth(context, 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


}
