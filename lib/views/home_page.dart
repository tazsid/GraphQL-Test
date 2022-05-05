import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_test/controllers/home_page_controller.dart';
import 'package:graphql_test/models/country_model.dart';
import 'package:graphql_test/utils/api_provider.dart';
import 'package:graphql_test/views/navigate_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController? homePageController;

  @override
  void initState() {
    homePageController = Get.put(HomePageController());

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<HomePageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                      maxLines: 1,
                      onSubmitted: (text) async {
                        FocusScope.of(context).unfocus();

                        homePageController?.stream.add(await getAllCountries(
                            text.trim().toUpperCase(),
                            homePageController?.selectedFilter.value));
                      },
                      onChanged: (text) async {
                        if (text.trim().isEmpty) {
                          homePageController?.stream.add(await getAllCountries(
                              text, homePageController?.selectedFilter.value));
                        }
                      },
                      controller:
                          homePageController!.searchTextEditingController,
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.search,
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Search by code',
                        counterText: '',
                      )),
                ),
                Card(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.only(left: 10),
                    child: Obx(
                      () => DropdownButton<String>(
                          value: homePageController?.selectedFilter.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: homePageController?.dropdownFilterItems,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) async {
                            homePageController?.selectedFilter.value = value!;

                            homePageController?.stream.add(
                                await getAllCountries(
                                    homePageController
                                        ?.searchTextEditingController.text
                                        .trim(),
                                    homePageController?.selectedFilter.value));
                          }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Expanded(
              child: StreamBuilder<List<Countries>>(
                stream: homePageController?.stream.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var countries = snapshot.data;

                    if (countries != null && countries.isNotEmpty) {
                      countries.sort((a, b) => a.name!.compareTo(b.name!));
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: Get.height * .01),
                              child: Text(countries[index].name!),
                            );
                          });
                    }

                    return Center(
                        child: Text(
                      homePageController?.selectedFilter.value == 'Filter'
                          ? 'Country does not exists for the country code'
                          : 'Country does not exists for the country code or does not have the selected currency',
                      textAlign: TextAlign.center,
                    ));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          Get.to(() => const Navigate(), transition: Transition.cupertino);
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: Colors.blue,
        textColor: Colors.white,
        child: const Text('Route Navigation'),
      ),
    );
  }
}
