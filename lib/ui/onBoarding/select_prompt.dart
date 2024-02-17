import 'package:flutter/material.dart';

class SelectPrompt extends StatelessWidget {
  const SelectPrompt({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function(String prompt) onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: SizedBox(),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Select a captions',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: prompts.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          prompts.sort((a, b) {
            return a.toLowerCase().compareTo(b.toLowerCase());
          });
          return InkWell(
            onTap: () {
              onTap(prompts[index]);
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Text(
                prompts[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

List prompts = [
  "Bad hair day",
  "Bet you can't do this",
  "Christmas is the best time of year.",
  "Dancing makes me happy",
  "Dancing the night away",
  "Dating me is like",
  "Do you like this costume",
  "Do you love animals as much as I do?",
  "Do you love cats as much as I do?",
  "Do you love dogs as much as I do?",
  "Do you love kids as much as I do?",
  "Don't judge me",
  "Feeling frisky",
  "Friends for life",
  "Fun in the sun",
  "Guess where I am in this photo",
  "How would you describe this pic",
  "I feel fab!",
  "I feel great!",
  "I must be crazy",
  "I need my morning coffee",
  "I'm a country girl",
  "I'm a cowboy at heart",
  "I'm famous for this",
  "Life at the beach",
  "Life on the water",
  "Me and my doppelgänger",
  "Me at my favorite concert",
  "Me being serious",
  "Me in my big hair days",
  "Me in my rowdy days",
  "Mondays suck",
  "Mountain life",
  "My alter ego",
  "My best friend and me",
  "My best life",
  "My BFF",
  "My family",
  "My favorite activity",
  "My favorite dress",
  "My favorite place on earth",
  "My favorite suit",
  "My favorite vacation",
  "My funniest moment",
  "My funny face",
  "My greatest achievement",
  "My kids are my world",
  "My love",
  "My mom would kill me",
  "My newest adventure",
  "My newest talent",
  "My proudest moment",
  "My serious face",
  "My work buddies",
  "My world",
  "People say I look like",
  "Silly kid stuff",
  "Simple pleasures",
  "Sunny days make me happy",
  "The best night of my life",
  "The bigger the risk",
  "The outdoor life",
  "They caught me",
  "This is candid me",
  "This takes years of practice",
  "Two is better than one",
  "Wanna do this with me?",
  "Weekends are the best",
  "What one word best describes this?",
  "Wish you were here",
  "You had to be there"
];
