import 'package:fitness/models/categoryModel.dart';
import 'package:fitness/models/dietModel.dart';
import 'package:fitness/models/popularModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  List<DietModel> diets = [];

  List<PopularModel> popular = [];

  // Controller for search field
  final TextEditingController _searchController = TextEditingController();

  // State to manage search results
  List<dynamic> searchResults = [];
  bool isSearching = false;

  void getCategories() {
    categories = CategoryModel.getCategories();
  }

  void getDiets() {
    diets = DietModel.getDiets();
  }

  void getPopular() {
    popular = PopularModel.getPopular();
  }

  void _showCategoryDetails(CategoryModel category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // like a pop up page
        return GestureDetector(
          onDoubleTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize
                  .min, // this will manage the hight of the box depending on the content
              children: [
                SvgPicture.asset(
                  category.iconPath,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16), // manage space between the contents
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category
                      .description, // Add a description field to your CategoryModel
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   child: const Text(
                //     "Close",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        searchResults.clear();
      } else {
        isSearching = true;
        searchResults = [
          ...categories.where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase())),
          ...diets.where(
              (diet) => diet.name.toLowerCase().contains(query.toLowerCase())),
          ...popular.where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase())),
        ];
      }
    });
  }

  // @override
  @override
  Widget build(BuildContext context) {
    getCategories();
    getDiets();
    getPopular();
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          searchField(),
          SizedBox(
            height: 40,
          ),
          if (isSearching)
            searchResultsSection()
          else ...[
            categoriesSection(),
            const SizedBox(height: 40),
            recommendationSection(),
            const SizedBox(height: 40),
            popularItemsSection(),
          ],
          // SizedBox(height: ,)
        ],
      ),
    );
  }

  Widget searchResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Search Results",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchResults.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final item = searchResults[index];
            if (item is CategoryModel) {
              return _buildCategoryItem(item);
            } else if (item is DietModel) {
              return _buildDietItem(item);
            } else if (item is PopularModel) {
              return _buildPopularItem(item);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return GestureDetector(
      onTap: () => _showCategoryDetails(category),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: category.boxColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              category.iconPath,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 16),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietItem(DietModel diet) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.07),
            offset: const Offset(0, 10),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            diet.iconPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diet.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${diet.level} | ${diet.duration} | ${diet.calorie}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItem(PopularModel popular) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.07),
            offset: const Offset(0, 10),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            popular.iconPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                popular.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${popular.level} | ${popular.duration} | ${popular.calorie}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column popularItemsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          "Popular",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 250,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                height: 110,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color(0xff1D1617).withOpacity(0.07),
                      offset: Offset(0, 10),
                      blurRadius: 40,
                      spreadRadius: 0)
                ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        popular[index].iconPath,
                        width: 65,
                        height: 65,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            popular[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            popular[index].level +
                                ' | ' +
                                popular[index].duration +
                                ' | ' +
                                popular[index].calorie,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/icons/button.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ]),
                // decoration: BoxDecoration(
                //     color: popular[index].boxIsSelected
                //         ? Colors.white
                //         : Colors.transparent,
                //     boxShadow: popular[index].boxIsSelected
                //         ? [
                //             BoxShadow(
                //                 color:
                //                     Color(0xff1D1617).withOpacity(0.07),
                //                 offset: Offset(0, 10),
                //                 blurRadius: 40,
                //                 spreadRadius: 0)
                //           ]
                //         : []),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 25),
            padding: EdgeInsets.only(left: 20, right: 20),
            itemCount: popular.length),
      )
    ]);
  }

  Column recommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            "Recommendation  for Diet",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            height: 240,
            child: ListView.separated(
              itemCount: diets.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20, right: 20),
              separatorBuilder: (context, index) => SizedBox(width: 25),
              itemBuilder: (context, index) {
                return Container(
                  width: 210,
                  decoration: BoxDecoration(
                      color: categories[index].boxColor.withOpacity(
                            0.3,
                          ),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(diets[index].iconPath),
                      Column(
                        children: [
                          Text(
                            diets[index].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            diets[index].level +
                                ' | ' +
                                diets[index].duration +
                                ' | ' +
                                diets[index].calorie,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              diets[index].viewIsSelected
                                  ? Color(0xff9DcEFF)
                                  : Colors.transparent,
                              diets[index].viewIsSelected
                                  ? Color(0xff92A3FD)
                                  : Colors.transparent,
                            ]),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            'View',
                            style: TextStyle(
                                color: diets[index].viewIsSelected
                                    ? Colors.white
                                    : Color(0xffC58BF2),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
      ],
    );
  }

  Column categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            "Category",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 120,
          child: ListView.separated(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20, right: 20),
              separatorBuilder: (context, index) => SizedBox(
                    width: 20,
                  ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showCategoryDetails(categories[index]);
                  },
                  child: Container(
                    width: 100,
                    // height: 80,
                    decoration: BoxDecoration(
                        color: categories[index].boxColor.withOpacity(
                              0.3,
                            ),
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(categories[index].iconPath),
                          ),
                        ),
                        Text(
                          categories[index].name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Container searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(15),
            hintText: 'Search Pancake',
            hintStyle: TextStyle(
              color: Color(0xffD0DADA),
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Search.svg'),
            ),
            suffixIcon: Container(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VerticalDivider(
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset('assets/icons/Filter.svg'),
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Breakfast',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => {print('back button tapped')},
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => {},
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(
              'assets/icons/dots.svg',
            ),
          ),
        ),
      ],
    );
  }
}
