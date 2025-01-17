import 'package:flutter/material.dart';

BoxDecoration screenBgImage() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/background/login_bg.png'),
      fit: BoxFit.fitHeight,
    ),
  );
}


BoxDecoration signInBottomImage() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/background/signin_bottom_bg.png'),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration signInLogoImage() {
  return const BoxDecoration(
    color: Colors.black,
    image: DecorationImage(
      image: AssetImage('assets/background/logo.png'),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration signInContainerImage() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/background/signin_container_image.png'),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration homeAddIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/add.png'),
      //fit: BoxFit.fill,
    ),
  );
}

BoxDecoration homeFilterIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/filter_icon.png'),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration filterCloseIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/filter_close_icon.png'),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration deleteIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/delete.png'),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration editIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/edit.png'),
      fit: BoxFit.fitHeight,
    ),
  );
}

BoxDecoration menuIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/menu.png'),
      fit: BoxFit.fitHeight,
    ),
  );
}

BoxDecoration userIcon() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/icons/user.png'),
    ),
  );
}
