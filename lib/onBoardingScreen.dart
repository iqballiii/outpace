import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  int currentPage = 0;
  List<String> onBoardingImages = [];
  List<String> onBoardingText = [
    'Do\'s and donn\'ts from WHO for COVID-19',
    'Always remember to wear your mask',
  ];
  String mobileNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget indicatorCircles(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: Offset(2.2, 2.2), color: Colors.black.withOpacity(0.2))
        ],
        shape: BoxShape.circle,
        color: isActive ? Color(0xff3EC6FF) : Color(0xffDDDDDD),
      ),
    );
  }

  Widget screen1() {
    return Container(
      child: Column(
        children: [
          Image(
            image: NetworkImage(
                'https://image.freepik.com/free-vector/illustrated-man-running-from-particles-coronavirus_23-2148649886.jpg'),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'This app will help you maintain social distancing',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget screen2() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: NetworkImage(
                'https://cdn-b.medlife.com/2020/03/coronavirus-dos-donts.jpg'),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'Do\'s',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          AutoSizeText(
              '1. Hand Wash\n2. Cover Your Mouth & Nose\n3. Consult A Doctor If Sick\n4. Stay Indoors'),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Don\'ts',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          AutoSizeText(
              '5. Avoid Close Contact With Anyone\n6. Do Not Spit\n7. Avoid Using Public Transport\n8. Do Not Use Over The Counter Medicines\n9. Don’t Panic, Take It Easy\n10. Don’t Touch Your Face'),
        ],
      ),
    );
  }

  Widget screen3() {
    return Container(
      child: Column(
        children: [
          Image(
            image: NetworkImage(
                'https://cdn-b.medlife.com/2020/03/Cover-your-mouth-and-nose.jpg'),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'Always remember to wear your mask',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget screen4() {
    return Container(
      child: Column(
        children: [
          Image(
            image: NetworkImage(
                'https://cdn-b.medlife.com/2020/03/Stay-indoors.jpg'),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'Welcome to the social distancing app',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('Please enter your mobile number to proceed'),
          SizedBox(
            height: 15.0,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value.length < 10)
                  return 'please enter 10 digit number';
                else
                  return null;
              },
              onChanged: (value) {
                mobileNumber = value;
              },
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusColor: Colors.grey,
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              height: MediaQuery.of(context).size.height * 0.78,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                controller: pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: [
                  screen1(),
                  screen2(),
                  screen3(),
                  screen4(),
                ],
              ),
            ),
            currentPage == 3
                ? Builder(
                    builder: (cont) => Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      height: 45.0,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(int.parse(mobileNumber))),
                                (_) => false);
                          } else {
                            Scaffold.of(cont).showSnackBar(SnackBar(
                                content: Text('Please enter a number')));
                          }
                        },
                        color: Colors.lightBlue,
                        child: Text('Continue'),
                      ),
                    ),
                  )
                : Container(
                    height: 60.0,
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < 4; i++)
                      if (i == currentPage)
                        indicatorCircles(true)
                      else
                        indicatorCircles(false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
