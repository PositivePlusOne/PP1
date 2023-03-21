import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileSettingsContent extends StatelessWidget {
  const ProfileSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return PositiveTextField();
  }
}

//* Header with Back, Account, and Notifications buttons (only Back button is in scope)

//* Title: Profile

//* Profile image/button (Out of scope: see [PP1-279])

//* Text box: Display Name [Populated from user data]

//* Button to change Display Name

//* About You subheading and text [Populated from user data]

//* Button to change About You text

//* Info message: Always displayed in app

//* Text box: Date of Birth [Populated from user data] (disabled)

//* Message with link to Guidance: Guidance (Out of scope)

//* Info message: Display In App [State: Shows stored user preference]

//* Text box: Gender [Populated from user data]

//* Button to change Gender

//* Info message: Display In App [State: Shows stored user preference]

//* Text box: HIV Status [Populated from user data]

//* Button to change HIV Status

//* Info message: Display In App [State: Shows stored user preference]

//* Text box: Location [Populated from user data]

//* Button to change Location

//* Info message: Display In App [State: Shows stored user preference. This option should be disabled if no location has been supplied]