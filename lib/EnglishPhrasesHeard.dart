import 'package:flutter/material.dart';
import 'package:sleeplearning/PhrasesHeardQuestion.dart';

class EnglishPhrasesHeard extends StatefulWidget {
  final Map<String, dynamic> responses;

  const EnglishPhrasesHeard({Key? key, required this.responses})
      : super(key: key);

  @override
  State<EnglishPhrasesHeard> createState() => _EnglishPhrasesHeardState();
}

class _EnglishPhrasesHeardState extends State<EnglishPhrasesHeard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    var responses = widget.responses;
    int n = int.parse(responses["numPhrases"]);
    final children = <Widget>[];
    for (var i = 1; i <= n; i++) {
      print(i);
      var w = FirstPhrase(
        responses: responses,
        i: i,
        p: controller,
      );
      children.add(w);
    }
    return PageView(
      physics: const NeverScrollableScrollPhysics(),

      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children: children,
    );
  }
}
