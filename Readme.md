# PayPro

![Cabecera](PayPro/images/paypro.png)

---------

## URLs
| Roles | Method | Type | Description
|--|--|--|--|
|role_apk|/login|POST|login (public access)
|role_apk|/otp|POST|sends telephone number for OTP verification|
|role_apk|/otp|GET|verifies OTP code|
|role_apk|/checkUserId|POST|checks the user ID|
|role_apk|/registro|POST|registers the user|
|role_user|/login|POST|login (public access)|
|role_user|/transaccion|POST|lets the user perform a transaction|
|role_user|/getPubKey/|GET|provides user's public key|
|role_user|/balance|GET|provides tokens for Account Balance|
|role_user|/addNewToken|POST|adds new tokens|
|role_user|/transacHist2|GET|provides the history of transactions|
|role_user|/transaccion|GET|provides the details from a transaction|
|role_user|/contactos|POST|provides the user's contacts|
|role_user|/transaccion|POST|lets you perform a transaction|
|role_user|/transferToken|POST|lets you transfer a token|
|role_user|/profile|GET|provides you with information like gas price, gas limit, the user's image|
|role_user|/changepass|POST|lets user change the password|
|role_user|/updatePhoto|POST|lets the user update the profile picture|
|role_user|/updateGasPrice|POST|lets the user update the gas price|
|role_user|/updateGasLimit|POST|lets the user update the gas limit|

In order to log in in the app, the following parameters should be introduced:

    {
    "username":"Apk_Paypr0",
    "password":""
    }

Once the log in has been done, we have to keep the cookie sessionID and the token, so that they can be used in every web service.

Then, go through OTP verification, password creation, and user registering.

Once the user has been registered, the user login would be done. Afterwards, the user would have permission to operate.

---------
# Register & Login flow

### Register
In order to register a new user, the following steps have to be followed:

 1. As soon as the app runs, it will launch on register view. Introduce the following information in that view: user's name, telephone number country code and telephone number; and then, go onto "create your account".
 2. Send an OTP code to the users telephone number.
 3. Complete the OTP confirmation view with the code, which is then verified.
 4. Introduce the user ID, which should be different to any other registered user. If ID is already another used by other user, the application tells you to introduce a different user ID.
 5. Type in the password for the user, consisting of a string of 6 characterers.
 6. Type in again the password, so that the application checks if both passwords are exactly the same.
 7. If everything is correct, the user is then registered.

![](PayPro/images/Register.png)

### Login

 1. As soon as the app runs, it will launch on register view, where the user has to press the Sign in button
 2. A view where the user has to type the user ID will be launched.
 3. Finally, type in the password onto the last view, and, if both the user ID and the password, are correct, the user will get into the account. Otherwise, an alert will show the problem during the login proccess.

![](PayPro/images/LogInUser.png)

---------

# Receive flow
In the receive part of the application, two important things are showed:

 - A QR Code with the user public address.
 - The public address itself, which can be copied to clipboard by pressing it

![](PayPro/images/PublicKey.png)

---------

# Support flow

 1. Pressing on Open Messenger, the user is sent to the Intercom interface.
 2. In the Intercom interface, there exists the possibility to continue with an existing conversation or to start a new one.

![](PayPro/images/Support.png)

### iOS Intercom integration
Inside didFinishLaunchingWithOptions, add the following:

```
	Intercom.setApiKey("Your iOS API Key", forAppId: "Your App ID")
```

#### Users registration

Before initializing a new conversation, the user must be registered. This can be done registering an anonymous user or a known user

If an anonymous user is intended to be registered, inside didFinishLaunchingWithOptions, right after Intercom.setApiKey(...), add the following

	Intercom.registerUnidentifiedUser()

In an application like Infinit, every user must have completed the login before launching Intercom. Therefore, they should be added to Intercom as known users.

Users can be registered with an individual indentifier:

	Intercom.registerUser(withUserId: "...")

By using an email address:

	Intercom.registerUser(withEmail: "...")

Or both:

	Intercom.registerUser(withUserId: "...", email: "...")

However, they use userName as an individual indentifier.

#### Updating users

Further information can be collected from users so that their Intercom profiles are more complete. The different attributes are saved in ICMUserAttributes, and it is updated by Intercom.updateUser():

	let userAttributes = ICMUserAttributes()   
	userAttributes.name = "Bob”   
	userAttributes.email = "bob@example.com”   
	Intercom.updateUser(userAttributes)  

Besides from the default attributes, new ones can also be added.

	userAttributes.customAttributes = ["paid_subscriber": true, ”monthly_spend": 155.5, "team_mates": 3]

---------

# Send flow

 1. Selection of the contact or public address to which a transaction is desired to be done. There exists two ways to perform this:
	 - Pressing onto "Not in my contact list", by which the user is sent to a view with two options: the possibility to type in the
   wallet public address of the beneficiary, or the possibility to scan
   a QR Code by which an address is obtained.
	 - Pressing onto one of the existing contacts in the list
 3. Choose an currency from the picker view, and type in the amount desired to be sent. This amount must be less than the total amount the user has in his account. If every parameter satisfies every condition, by pressing next, the following view is launched.
 4. In the message view, a message for the transaction can be added. This is only optional so, if the message is empty, there will be no error.
 5. Confirm view, where the user can check the parameters entered and, in case there is any error, the user can go back and fix them. By sliding the bottom bar, the transaction is completed and the user has to wait for the server response.
 6. Finally, if everything is correct, the transaction is done and confirmation view is launched. On the other hand, if any error is encountered, the application goes back to the confirm view, showing an alert stating the error.

![](PayPro/images/ConfirmTransaction.png)

---------

# Account flow

Account can be divided in Balance and Transaction History. Both options can be found on the segmented control located on top of the view.

### Balance
 1. All the tokens the user owns are displayed on this view, as well as the amount of each token. By using the Search bar on top, the user can look for a specific token in the list.
 2. By pressing on "Add Token", addNewTokenView is displayed. This view has 4 text fields where all the information must be filled in in order to add a token to the user's list.

![](PayPro/images/Balance.png)

### Transaction History
 1. Every transaction is displayed on this view. The user can scroll down and see all the transactions done.
 2. If any of the transactions is pressed, the details of such transaction are showed. The last detail in this view, that is, Transaction hash, can be copied to clipboard by pressing on it.

![](PayPro/images/TransactionHistory.png)

---------

# Settings flow

Several actions can be done in this section:

![](PayPro/images/Settings.png)

### Profile Picture

 1. By pressing on the profile picture on top, an alert is showed on screen asking whether you want to select the profile picture from Gallery or by opening the Camera.
 2. Both, doing it with the camera or looking for it in the gallery, will end up changing the profile picture.

### Private key

 1. By pressing onto Private key in, the application launches a view where the user has to confirm his password.
 2. If the password from the previous step is correct, the application navigates to a view where the user's private key is showed. This key can be copied to clipboard by pressing on it.

### Password

 1. By pressing onto Password, the application launches a new view where the user can choose his new password.
 2. By clicking on done, the application navigates to a new view where the user has to confirm the password, and if everything is correct, the password changes.

### Gas price

 1. By pressing onto Gas Price, the application launches a new view where the user can choose the gas price from a picker view. The minimum to choose is 1 Gwei, and the maximum is 100 Gwei.
 2. Pressing onto save, the new gas price is saved for the user. On the other hand, if the user presses back, the gas price is not updated.

### Gas limit

 1. By pressing onto Gas Limit, the application launches a new view where the user can type in the gas limit in a text field.
 2. Pressing onto save, the new gas limit is saved for the user as long as it satisfy the condition that the gas limit is higher than 0. On the other hand, if the user presses back, the gas limit is not updated.

### Web links

 1. About us: pressing on it, the application launches an external link.
 2. Rate us: pressing on it, the application redirects the user to the application link on the respective store: Apple Store for iOS and Play Store for Android.
 3. Info: pressing on it, the application launches another view, where links for Terms of Service, Privacy Policy and Website can be found.

### Log out

 1. By pressing onto Log out, the application shows an alert, where you can cancel to log out, or confirm to log out.
 2. If cancel is pressed, the application goes back to settings. If you confirm to log out, the application launches the register view.

 ---------
# Customize your project
## iOS- host url
To change the Node Url go to the Build Settings Configuration in app and change the "HOST_URL" for your Url instead
