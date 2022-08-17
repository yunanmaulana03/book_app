import 'dart:convert';

import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/helper/theme.dart';
import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(142), // Set this height
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: kPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 40,
              bottom: 30,
              top: 30,
            ),
            child: Text(
              'Let\'s Discover',
              style: whiteTextStyle.copyWith(
                fontSize: 30,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<BookController>(
        child: Center(child: CircularProgressIndicator()),
        builder: (context, controller, child) => Container(
            child: bookController!.bookList == null
                ? child
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 32,
                            left: 40,
                            bottom: 20,
                          ),
                          child: Text(
                            'Popular Books',
                            style: PrimaryTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                        // Divider(),
                        Container(
                          height: 300,
                          child: ListView.builder(
                            // shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: bookController!.bookList!.books!.length,
                            // physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final current =
                                  bookController!.bookList!.books![index];

                              return Container(
                                margin: EdgeInsets.only(
                                  left: 40,
                                ),
                                width: 120,
                                height: 135,
                                child: Stack(
                                  children: [
                                    Image.network(
                                      current.image!,
                                      height: 180,
                                    ),
                                    Positioned(
                                      top: 130,
                                      child: Container(
                                        width: 120,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: kGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              current.title!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BlackTextStyle.copyWith(
                                                fontSize: 10,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                            Text(
                                              current.price!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BlackTextStyle.copyWith(
                                                fontSize: 8,
                                                fontWeight: light,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 40,
                            bottom: 30,
                          ),
                          child: Text(
                            'Catalogue Book',
                            style: PrimaryTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: bookController!.bookList!.books!.length,
                          itemBuilder: (context, index) {
                            final currentBook =
                                bookController!.bookList!.books![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailBookPage(
                                        isbn: currentBook.isbn13!),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 30,
                                    ),
                                    height: 300,
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          currentBook.image!,
                                          height: 180,
                                        ),
                                        Positioned(
                                          top: 140,
                                          child: Container(
                                            width: 150,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: kGreyColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 26,
                                              horizontal: 14,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  currentBook.title!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      BlackTextStyle.copyWith(
                                                    fontSize: 15,
                                                    fontWeight: semiBold,
                                                  ),
                                                ),
                                                Text(
                                                  currentBook.subtitle!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      BlackTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: light,
                                                  ),
                                                ),
                                                Spacer(),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    currentBook.price!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        BlackTextStyle.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: light,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 30,
                                    ),
                                    height: 300,
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          currentBook.image!,
                                          height: 180,
                                        ),
                                        Positioned(
                                          top: 140,
                                          child: Container(
                                            width: 150,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: kGreyColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 26,
                                              horizontal: 14,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  currentBook.title!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      BlackTextStyle.copyWith(
                                                    fontSize: 15,
                                                    fontWeight: semiBold,
                                                  ),
                                                ),
                                                Text(
                                                  currentBook.subtitle!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      BlackTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: light,
                                                  ),
                                                ),
                                                Spacer(),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    currentBook.price!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        BlackTextStyle.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: light,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }
}
