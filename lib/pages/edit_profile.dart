import 'package:brk_mobile/models/user_model.dart';
import 'package:brk_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:brk_mobile/theme.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    Widget buildNameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: subtitleTextStyle.copyWith(
                fontSize: 13,
                fontWeight: medium,
              ),
            ),
            TextFormField(
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
              decoration: InputDecoration(
                hintText: user.name,
                hintStyle: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: light,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: accentColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget buildUsernameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: subtitleTextStyle.copyWith(
                fontSize: 13,
                fontWeight: medium,
              ),
            ),
            TextFormField(
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
              decoration: InputDecoration(
                hintText: '@${user.username}',
                hintStyle: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: light,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: accentColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget buildEmailInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: subtitleTextStyle.copyWith(
                fontSize: 13,
                fontWeight: medium,
              ),
            ),
            TextFormField(
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
              decoration: InputDecoration(
              hintText: user.email,
                hintStyle: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: light,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: accentColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget buildContent() {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        margin: EdgeInsets.only(
          top: 20.0,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  // image: NetworkImage(user.profilePhotoUrl!),
                  image: AssetImage('assets/images/img_profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            buildNameInput(),
            buildUsernameInput(),
            buildEmailInput(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: secondaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: buildContent(),
    );
  }
}
