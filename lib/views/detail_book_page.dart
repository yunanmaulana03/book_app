import 'dart:convert';

import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/helper/theme.dart';
import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
  }) : super(key: key);
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? controller;
  String? love;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Provider.of<BookController>(context, listen: false);
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BookController>(builder: (context, controller, child) {
        return controller.detailBook == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewScreen(
                                  imageUrl: controller.detailBook!.image!),
                            ),
                          );
                        },
                        child: Image.network(
                          controller.detailBook!.image!,
                          width: double.infinity,
                          height: 450,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        color: kWhiteColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            controller.detailBook!.title!,
                            style: BlackTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: regular,
                            ),
                          ),
                          Text(
                            controller.detailBook!.authors!,
                            style: BlackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: light,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(
                                    5,
                                    (index) => Icon(Icons.star,
                                        color: index <
                                                int.parse(controller
                                                    .detailBook!.rating!)
                                            ? Colors.yellow
                                            : Colors.grey)),
                              ),
                              Text(
                                controller.detailBook!.price!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   controller.detailBook!.subtitle!,
                          //   style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.grey),
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            controller.detailBook!.desc!,
                            style: BlackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: regular,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Similiar Books',
                            style: PrimaryTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: semiBold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          controller.similiarBooks == null
                              ? CircularProgressIndicator()
                              : Container(
                                  height: 180,
                                  child: ListView.builder(
                                    // shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        controller.similiarBooks!.books!.length,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final current = controller
                                          .similiarBooks!.books![index];
                                      return Container(
                                        width: 120,
                                        child: Column(
                                          children: [
                                            Image.network(
                                              current.image!,
                                              height: 110,
                                            ),
                                            Text(
                                              current.title!,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: BlackTextStyle.copyWith(
                                                fontSize: 10,
                                                fontWeight: light,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 230,
                                height: 70,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 92,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    Uri uri =
                                        Uri.parse(controller.detailBook!.url!);
                                    try {
                                      (await canLaunchUrl(uri))
                                          ? launchUrl(uri)
                                          : print('tidak berhasil navigasi');
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text(
                                    'Buy',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 24,
                                      fontWeight: medium,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kPrimaryColor,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    love = "yes";
                                    setState(() {});
                                  },
                                  child: LoveIcon(
                                      icon: (love == "yes")
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),

                    // Spacer(),

                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.stretch,
                    //   children: [
                    //     Text('Year: ' + controller.detailBook!.year!),
                    //     Text('ISBN: ' + controller.detailBook!.isbn13!),
                    //     Text(controller.detailBook!.pages! + ' Page'),
                    //     Text('Publisher: ' + controller.detailBook!.publisher!),
                    //     Text('Language: ' + controller.detailBook!.language!),

                    //     // Text(detailBook!.rating!),
                    //   ],
                    // ),
                    // Divider(),
                  ],
                ),
              );
      }),
    );
  }
}

class LoveIcon extends StatelessWidget {
  const LoveIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 50,
      color: kPrimaryColor,
    );
  }
}
