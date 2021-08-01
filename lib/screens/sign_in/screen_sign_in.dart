import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sense_battle/constants/constants.dart';
import 'package:sense_battle/providers/fetch_state.dart';

import 'package:sense_battle/providers/provider_signin.dart';
import 'package:sense_battle/screens/sign_in/add_account_email.dart';
import 'package:sense_battle/screens/sign_in/sense_battle_signin_button.dart';
import 'package:sense_battle/screens/sign_in/third_party_signin.dart';
import 'package:sense_battle/screens/widgets/circular_progress.dart';
import 'package:sense_battle/utils/Print.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late SignInProvider signInProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    signInProvider = Provider.of<SignInProvider>(context);
    

    Print.e("_userCredential: ${signInProvider.userCredential}");

    if (signInProvider.errorMessage != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.rawSnackbar(
          message: signInProvider.errorMessage!, 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Theme.of(context).errorColor,
          borderRadius: Constants.sapceGap,
          duration: Duration(seconds: 1),
        );
        signInProvider.setErrorMessage(null);
        }
      );
    }

    if(signInProvider.userCredential != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.toNamed('/main');
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Constants.sapceGap),
                child: Column(
                  children: [
                    SizedBox(height: Constants.sapceGap*2,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'SignIn',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    SizedBox(height: 100.0,),
                    SenseBattleSignInButton(),
                    SizedBox(height: Constants.sapceGap/2,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Constants.sapceGap),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: (){

                            },
                            child: Text(
                              '약관보기',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          TextButton(
                            onPressed: (){
                              showModalBottomSheet(
                                context: context, 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Constants.sapceGap),
                                ),
                                backgroundColor: Theme.of(context).dialogBackgroundColor,
                                builder: (context) => SizedBox(
                                  height: 480.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(Constants.sapceGap),
                                    child: AddAccountWithEmail(),
                                  )
                                )
                              );
                            },
                            child: Text(
                              '회원가입',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Constants.sapceGap*2,),
                    ThirdPartySignInSection(height: 300,),
                  ],
                ),
              ),
              Visibility(
                visible: signInProvider.fetchState == FetchState.PROGRESS,
                child: CircularProgress(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

