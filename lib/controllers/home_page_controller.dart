import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_test/models/country_model.dart';
import 'package:graphql_test/utils/api_provider.dart';

class HomePageController extends GetxController {
  TextEditingController searchTextEditingController = TextEditingController();

  StreamController<List<Countries>> stream = StreamController();

  var selectedFilter = 'Filter'.obs;

  List<DropdownMenuItem<String>> dropdownFilterItems = [];
  List<String> currencyList = [];

  @override
  void onInit() async {
    currencyList.add('INR');
    currencyList.add('USD');
    currencyList.add('EUR');
    currencyList.add('AED');

    dropdownFilterItems = buildDownMenuItems(currencyList);

    stream.add(await getAllCountries(
        searchTextEditingController.text.trim(), selectedFilter.value));

    super.onInit();
  }

  List<DropdownMenuItem<String>> buildDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = [];
    items.add(
      DropdownMenuItem(
        child: Text('Filter', style: TextStyle(color: Colors.grey[600])),
        value: 'Filter',
      ),
    );
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  void onClose() {
    stream.done;
    super.onClose();
  }
}
