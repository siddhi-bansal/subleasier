import 'package:flutter/material.dart';
import 'package:subleasier/sublessee/individual_posting.dart';


class ImageCard extends StatelessWidget {
  final dynamic posting;

  const ImageCard({Key? key, this.posting}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IndividualPosting(posting: posting)),
        );
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(
                        Colors.transparent),
                shadowColor:
                    WidgetStateProperty.all<Color?>(
                        Colors.transparent),
                shape: WidgetStateProperty.all<
                        RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                20)))),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.only(
                          right: 10,
                          left: 10),
                  child: Image.network(
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    posting['images'][0],
                    loadingBuilder: (BuildContext
                            imageContext,
                        Widget child,
                        ImageChunkEvent?
                            loadingProgress) {
                      if (loadingProgress ==
                          null) {
                        return child;
                      }
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    },
                  ),
                )),
                const SizedBox(height: 16),
                Text(
                    '\$${posting['price']}/month',
                    style: const TextStyle(
                        color: Colors.black)),
              ],
            ));
}
  }